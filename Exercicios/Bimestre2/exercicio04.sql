CREATE DATABASE BdVestibular;
GO;

USE DATABASE BdVestibular;
GO;

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
    NroVagas INT

    CONSTRAINT CK_Curso_CargaHoraria2800ou3600 CHECK(CargaHoraria = 2800 OR CargaHoraria = 3600); -- A)
);

CREATE TABLE Inscricao (
    CodIns INT IDENTITY(1, 1) PRIMARY KEY,
    Nota DECIMAL(3, 2),
    AnoInscr INT,
    DataInscrcao DATE,

    CodCan INT REFERENCES Candidato(CodCan),
    CodCurOpcao1 INT REFERENCES Curso(CodCur),
    CodCurOpcao2 INT REFERENCES Curso(CodCur),
);

CREATE TABLE Pagamento (
    CodPag INT IDENTITY(1, 1) PRIMARY KEY,
    VlPago MONEY,
    VlJurosMulta MONEY,
    DtPagto DATE,
    DtRegistro DATE,

    CodIns INT UNIQUE REFERENCES Inscricao(CodIns),

    -- DtVencto é calculada automaticamente com base na DtRegistro
    DtVencto AS (DATEADD(DAY, 10, DtRegistro)), -- D)
);

-- b)
ALTER TABLE Candidato
ADD Situacao VARCHAR(22);

ALTER TABLE Candidato
ADD CONSTRAINT CK_Candidato_SituacaoCandidato CHECK(Situacao IN ('Aprovado', 'Reprovado', 'Aprovado em 2ª chamada'));

-- c)
ALTER TABLE Inscricao
ADD Situacao VARCHAR(20);

ALTER TABLE Inscricao
ADD CONSTRAINT CK_Inscricao_SituacaoPagamento CHECK(Situacao IN ('Aguardando Pagamento', 'Cancelado', 'Encerrado', 'Pago'));






