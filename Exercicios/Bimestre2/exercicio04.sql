CREATE DATABASE BdVestibular;
GO

USE BdVestibular;
GO

CREATE TABLE Candidato (
    CodCan INT IDENTITY(1, 1) PRIMARY KEY,
    Nome VARCHAR(250),
    Endereco VARCHAR(500),
    CPF CHAR(11),
    RG VARCHAR(11)
);

CREATE TABLE Curso (
    CodCur INT IDENTITY(1, 1) PRIMARY KEY,
    Nome VARCHAR(250),
    CargaHoraria INT,
    NroVagas INT,

    CONSTRAINT CK_Curso_CargaHoraria2800ou3600 CHECK(CargaHoraria = 2800 OR CargaHoraria = 3600) -- A)
);

CREATE TABLE Inscricao (
    CodIns INT IDENTITY(1, 1) PRIMARY KEY,
    Nota DECIMAL(4, 2), 
    AnoInscr INT,
    DataInscrcao DATE,

    CodCan INT REFERENCES Candidato(CodCan),
    CodCurOpcao1 INT REFERENCES Curso(CodCur),
    CodCurOpcao2 INT REFERENCES Curso(CodCur)
);

CREATE TABLE Pagamento (
    CodPag INT IDENTITY(1, 1) PRIMARY KEY,
    VlPago MONEY,
    VlJurosMulta MONEY,
    DtPagto DATE,
    DtRegistro DATE,

    CodIns INT UNIQUE REFERENCES Inscricao(CodIns),

    DtVencto AS (DATEADD(DAY, 10, DtRegistro)) -- D)
);

-- b) Situação do Candidato
ALTER TABLE Candidato
ADD Situacao VARCHAR(22);

ALTER TABLE Candidato
ADD CONSTRAINT CK_Candidato_SituacaoCandidato CHECK(Situacao IN ('Aprovado', 'Reprovado', 'Aprovado em 2ª chamada'));

-- c) Situação da Inscrição
ALTER TABLE Inscricao
ADD Situacao VARCHAR(20);

ALTER TABLE Inscricao
ADD CONSTRAINT CK_Inscricao_SituacaoPagamento CHECK(Situacao IN ('Aguardando pagamento', 'Cancelado', 'Encerrado', 'Pago'));

-- e) Cada candidato pode realizar apenas uma inscrição por ano.
ALTER TABLE Inscricao
ADD CONSTRAINT UQ_Inscricao_CandidatoAno UNIQUE (CodCan, AnoInscr);

-- f) A Primeira e a segunda opção de cursos não pode ser igual.
ALTER TABLE Inscricao
ADD CONSTRAINT CK_Inscricao_PrimeiraOpcaoCursoDiferenteSegundaOpcao CHECK(CodCurOpcao1 <> CodCurOpcao2);

-- g) A data de cadastro do candidato é inserida automaticamente com a data do sistema.
ALTER TABLE Pagamento
ADD DataCadastro DATE CONSTRAINT DF_Candidato_DataCadastro DEFAULT GETDATE();

-- 3 - Quando uma nova inscrição for realizada, o sistema deverá registrar a inscrição e gerar automaticamente um boleto de pagamento no banco de dados.
BEGIN TRANSACTION T1
    BEGIN TRY

        DECLARE @CodIns INT

        INSERT INTO Inscricao(AnoInscr, Situacao, CodCan, CodCurOpcao1, CodCurOpcao2)
                    VALUES(2019, 'Aguardando pagamento', 1, 13, 27)
        
        SET @CodIns = SCOPE_IDENTITY()
        
        INSERT INTO Pagamento(DtRegistro, CodIns)
                    VALUES(GETDATE(), @CodIns)
        
        COMMIT TRANSACTION T1
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION T1
    END CATCH

-- 4 - Após a realização da prova do vestibular, o sistema deverá registrar a nota obtida pelo candidato na inscrição e atualizar a situação do candidato para um dos valores permitidos.
BEGIN TRANSACTION T2
    BEGIN TRY
        UPDATE Inscricao SET Nota = 85.00 WHERE CodIns = 117
        UPDATE Candidato SET Situacao = 'Aprovado' WHERE CodCan = (
            SELECT CodCan FROM Inscricao WHERE CodIns = 117
        )

        COMMIT TRANSACTION T2
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION T2
    END CATCH

-- 5 - Quando um pagamento for registrado, o sistema deverá atualizar os dados do pagamento e alterar a situação da inscrição correspondente para "Pago".
BEGIN TRANSACTION T3
    BEGIN TRY
        UPDATE Pagamento
            SET VlPago = 75.00, VlJurosMulta = 5.00, DtPagto = '2019-06-15'
            WHERE CodPag = 11556

        UPDATE Inscricao SET Situacao = 'Pago' WHERE CodIns = (
            SELECT CodIns FROM Pagamento WHERE CodPag = 11556
        )

        COMMIT TRANSACTION T3
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION T3
    END CATCH
