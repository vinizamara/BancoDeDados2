-- Analise o cenário da locadora de veículos (BdLocadora) descrito abaixo, complete as cardinalidades de cada relacionamento de acordo com as regras de negócio, corrija eventuais inconsistências conceituais e aplique as regras de transformação para criar o modelo físico.

CREATE DATABASE BdLocadora;
GO

USE BdLocadora;
GO

CREATE TABLE Funcionario (
    CodFun INT IDENTITY(1, 1),
    Nome VARCHAR(250) NOT NULL,
    CPF CHAR(11),
    Cargo VARCHAR (250),
    Salario MONEY,
    DataAdmissao DATE,
    CodSup INT,

    CONSTRAINT PK_Funcionario_CodFun PRIMARY KEY (CodFun),
    CONSTRAINT FK_Funcionario_CodSup FOREIGN KEY (CodSup) REFERENCES Funcionario(CodFun),
    CONSTRAINT UQ_Funcionario_CPF UNIQUE (CPF),
    CONSTRAINT CK_Funcionario_Cargo CHECK(Cargo IN ('Atendente', 'Gerente', 'Mecanico', 'Supervisor')),
    CONSTRAINT CK_Funcionario_Salario CHECK(Salario >= 2100.00)
);

CREATE TABLE Cliente (
    CodCli INT IDENTITY(1, 1),
    Nome VARCHAR(250) NOT NULL,
    CNH CHAR(11),
    CategoriaCNH CHAR(1),
    Cidade VARCHAR(250),
    Telefone VARCHAR(20),

    CONSTRAINT PK_Cliente_CodCli PRIMARY KEY (CodCli),
    CONSTRAINT UQ_Cliente_CNH UNIQUE (CNH),
    CONSTRAINT CK_Cliente_CategoriaCNH CHECK(CategoriaCNH IN ('B', 'C', 'D', 'E'))
);

CREATE TABLE Veiculo (
    CodVei INT IDENTITY(1, 1),
    Placa CHAR(7) NOT NULL,
    Modelo VARCHAR(250) NOT NULL,
    Categoria VARCHAR(250),
    ValorDiaria MONEY,
    Quilometragem INT,
    StatusVeiculo VARCHAR(250) CONSTRAINT DF_Veiculo_StatusVeiculo DEFAULT 'Disponivel',

    CONSTRAINT PK_Veiculo_CodVei PRIMARY KEY (CodVei),
    CONSTRAINT UQ_Veiculo_Placa UNIQUE (Placa),
    CONSTRAINT CK_Veiculo_StatusVeiculo CHECK(StatusVeiculo IN ('Disponivel', 'Alugado', 'Manutencao'))
);

CREATE TABLE Locacao (
    CodLoc INT IDENTITY(1, 1),
    DataRetirada DATE CONSTRAINT DF_Locacao_DataRetirada DEFAULT GETDATE(),
    DataPrevistaDevolucao DATE,
    DataDevolucaoReal DATE,
    ValorTotal MONEY,
    Situacao VARCHAR(250),
    CodFun INT,
    CodCli INT,
    CodVei INT,

    CONSTRAINT PK_Locacao_CodLoc PRIMARY KEY (CodLoc),
    CONSTRAINT FK_Locacao_Funcionario FOREIGN KEY (CodFun) REFERENCES Funcionario(CodFun),
    CONSTRAINT FK_Locacao_Cliente FOREIGN KEY (CodCli) REFERENCES Cliente(CodCli),
    CONSTRAINT FK_Locacao_Veiculo FOREIGN KEY (CodVei) REFERENCES Veiculo(CodVei),
    CONSTRAINT CK_Locacao_DataPrevistaDevolucaoMaiorDataRetirada CHECK(DataPrevistaDevolucao >= DataRetirada)
);

CREATE TABLE MultaOcorrencia (
    CodMul INT IDENTITY(1, 1),
    Descricao VARCHAR(250),
    ValorMulta MONEY,
    DataRegistro DATE,
    DataVencimento AS DATEADD(DAY, 15, DataRegistro),
    CodLoc INT,

    CONSTRAINT PK_MultaOcorrencia_CodMul PRIMARY KEY (CodMul),
    CONSTRAINT FK_MultaOcorrencia_Locacao FOREIGN KEY (CodLoc) REFERENCES Locacao(CodLoc),
    CONSTRAINT CK_MultaOcorrencia_ValorMultaMaiorZero CHECK(ValorMulta > 0)
);

CREATE TABLE Oficina (
    CodOfi INT IDENTITY(1, 1),
    RazaoSocial VARCHAR(250),
    CNPJ CHAR(14),
    Especialidade VARCHAR(250),

    CONSTRAINT PK_Oficina_CodOfi PRIMARY KEY (CodOfi),
    CONSTRAINT UQ_Oficina_CNPJ UNIQUE (CNPJ)
);

CREATE TABLE Manutencao (
    DataServico DATE NOT NULL,
    DescricaoServico VARCHAR(250),
    Custo MONEY,
    CodVei INT NOT NULL,
    CodOfi INT NOT NULL,

    CONSTRAINT PK_Manutencao_CodVei_CodOfi_DataServico PRIMARY KEY (CodVei, CodOfi, DataServico),
    CONSTRAINT FK_Manutencao_Veiculo FOREIGN KEY (CodVei) REFERENCES Veiculo(CodVei),
    CONSTRAINT FK_Manutencao_Oficina FOREIGN KEY (CodOfi) REFERENCES Oficina(CodOfi)
);

-- 2. Criação do Banco de Dados e Restrições de Integridade
-- Crie o banco de dados BdLocadora e implemente todas as tabelas com as seguintes restrições de integridade:
-- a) Cada tabela principal deve possuir uma chave primária com numeração automática (IDENTITY(1,1)), exceto a tabela associativa Manutencao, que deve utilizar chave primária composta (CodVei, CodOfi, DataServico).
-- b) Crie todas as chaves estrangeiras conforme as cardinalidades definidas na seção 1, incluindo o auto-relacionamento de supervisão na tabela Funcionario (CodSupervisor referenciando CodFun).
-- c) Os campos Nome (em Funcionario e Cliente), Placa e Modelo (em Veiculo) são campos obrigatórios (NOT NULL).
-- d) Não poderão existir dois funcionários cadastrados com o mesmo CPF, dois clientes com a mesma CNH, dois veículos com a mesma Placa nem duas oficinas com o mesmo CNPJ.
-- e) O Cargo do funcionário deverá aceitar apenas os valores: 'Atendente', 'Gerente', 'Mecanico' ou 'Supervisor'.
-- f) O Salario de um funcionário não poderá ser inferior a R$ 2.100,00.
-- g) A CategoriaCNH do cliente deverá aceitar apenas os valores: 'B', 'C', 'D' ou 'E'.
-- h) O Status do veículo deverá aceitar apenas 'Disponivel', 'Alugado' ou 'Manutencao', assumindo 'Disponivel' como valor padrão.
-- i) A DataRetirada da locação deve ter como valor padrão a data atual do sistema (GETDATE()), e a DataPrevistaDevolucao deverá ser obrigatoriamente maior ou igual à DataRetirada.
-- j) Na tabela MultaOcorrencia, o ValorMulta deve ser maior que zero e a coluna DataVencimento deve ser gerada automaticamente para 15 dias após a DataRegistro.


-- INSERÇÕES:
USE BdLocadora;
GO

-- a) 5 funcionários (CodFun 1 é Gerente e CodFun 2 é Supervisor vinculado ao Gerente; os demais reportam ao Supervisor)
INSERT INTO Funcionario (Nome, CPF, Cargo, Salario, DataAdmissao, CodSup) VALUES
('Ricardo Almeida',   '11122233344', 'Gerente',    6500.00, '2022-03-10', NULL),
('Fernanda Costa',    '22233344455', 'Supervisor', 4200.00, '2023-01-15', 1),
('Lucas Martins',     '33344455566', 'Atendente',  2400.00, '2024-05-20', 2),
('Juliana Ferreira',  '44455566677', 'Atendente',  2350.00, '2024-08-12', 2),
('Marcos Oliveira',   '55566677788', 'Mecanico',   3100.00, '2023-11-01', 2);

-- b) 6 clientes (cidades distintas e ao menos 1 cliente sem telefone cadastrado)
INSERT INTO Cliente (Nome, CNH, CategoriaCNH, Cidade, Telefone) VALUES
('Carlos Eduardo Silva', '10203040501', 'B', 'Franca',         '16991112233'),
('Mariana Souza',        '10203040502', 'B', 'Ribeirão Preto', '16992223344'),
('João Pedro Santos',    '10203040503', 'C', 'Campinas',       NULL),
('Beatriz Lima',         '10203040504', 'B', 'Franca',         '16993334455'),
('Rafael Mendes',        '10203040505', 'D', 'São Carlos',     NULL),
('Patrícia Gomes',       '10203040506', 'E', 'Ribeirão Preto', '16994445566');

-- c) 6 veículos (categorias, diárias e status variados; CodVei 6 nunca será alugado)
INSERT INTO Veiculo (Placa, Modelo, Categoria, ValorDiaria, Quilometragem, StatusVeiculo) VALUES
('ABC1D23', 'Chevrolet Onix 1.0',   'Hatch',   120.00, 34500, 'Disponivel'),
('EFG4H56', 'Toyota Corolla XEi',   'Sedan',   230.00, 18200, 'Alugado'),
('IJK7L89', 'Jeep Compass Longitude','SUV',    290.00, 41000, 'Manutencao'),
('MNO0P12', 'Fiat Strada Freedom',  'Utilitario', 180.00, 52300, 'Disponivel'),
('QRS3T45', 'Hyundai HB20S',        'Sedan',   150.00, 27800, 'Alugado'),
('UVW6X78', 'Volkswagen Nivus HL',  'SUV',     250.00,  4100, 'Disponivel');

-- d) 8 locações ('Finalizada', 'Aberta' e 'Cancelada'; CodVei 6 omitido propositalmente)
INSERT INTO Locacao (DataRetirada, DataPrevistaDevolucao, DataDevolucaoReal, ValorTotal, Situacao, CodFun, CodCli, CodVei) VALUES
('2026-09-01', '2026-09-05', '2026-09-05', 480.00,  'Finalizada', 3, 1, 1),
('2026-09-10', '2026-09-14', '2026-09-15', 1150.00, 'Finalizada', 4, 2, 2),
('2026-10-02', '2026-10-06', '2026-10-06', 1160.00, 'Finalizada', 3, 3, 3),
('2026-10-12', '2026-10-15', '2026-10-15', 540.00,  'Finalizada', 4, 4, 4),
('2026-10-20', '2026-10-22', NULL,         300.00,  'Cancelada',  3, 5, 5),
('2026-11-05', '2026-11-10', '2026-11-10', 600.00,  'Finalizada', 4, 6, 1),
('2026-11-20', '2026-11-27', NULL,         1610.00, 'Aberta',     3, 1, 2),
('2026-11-21', '2026-11-26', NULL,         750.00,  'Aberta',     4, 2, 5);

-- e) 4 multas/ocorrências vinculadas a locações distintas (DataVencimento é gerada automaticamente)
INSERT INTO MultaOcorrencia (Descricao, ValorMulta, DataRegistro, CodLoc) VALUES
('Excesso de velocidade até 20%',       130.16, '2026-09-08', 1),
('Atraso de 1 dia na devolução',        230.00, '2026-09-15', 2),
('Estacionamento em local proibido',    195.23, '2026-10-09', 3),
('Avaria leve no para-choque traseiro', 450.00, '2026-10-15', 4);

-- f) 3 oficinas e 5 registros de manutenção
INSERT INTO Oficina (RazaoSocial, CNPJ, Especialidade) VALUES
('Auto Mecânica Franca Ltda',     '12345678000101', 'Mecânica Geral e Suspensão'),
('Centro Automotivo Ribeirão SA', '23456789000102', 'Injeção Eletrônica e Câmbio'),
('Funilaria e Pintura Express',   '34567890000103', 'Funilaria e Estética');

INSERT INTO Manutencao (DataServico, DescricaoServico, Custo, CodVei, CodOfi) VALUES
('2026-09-07', 'Troca de óleo, filtros e pastilhas de freio',  420.00, 1, 1),
('2026-10-16', 'Reparo e pintura do para-choque traseiro',     680.00, 4, 3),
('2026-11-18', 'Revisão do sistema de arrefecimento e câmbio', 950.00, 3, 2),
('2026-11-19', 'Alinhamento, balanceamento e troca de pivôs',  390.00, 3, 1),
('2026-11-12', 'Higienização interna e troca de velas',        310.00, 1, 2);

-- Exercicios de Consultas:
-- a) Liste o nome do cliente em letras maiúsculas, os 4 primeiros caracteres da CNH, a cidade e o telefone. Caso o telefone não esteja preenchido, exiba 'SEM TELEFONE'. Filtre apenas os clientes cujo nome termine com 'Silva' ou contenha 'os' e que residam em 'Franca'.
SELECT 
    UPPER(C.Nome) AS NomeCliente,
    LEFT(C.CNH, 4) AS QuatroPrimeirosCaracteresCNH,
    C.Cidade,
    ISNULL(C.Telefone, 'SEM TELEFONE') AS TelefoneCliente
FROM Cliente C
WHERE (C.Nome LIKE '%Silva' OR C.Nome LIKE '%os%')
  AND C.Cidade = 'Franca';


-- b) Liste o código da locação, a data de retirada, o nome do cliente, o modelo e a placa do veículo, o nome do funcionário que registrou a locação e o nome do seu respectivo supervisor (exibindo 'SEM SUPERVISOR' caso não possua).
SELECT 
    L.CodLoc,
    L.DataRetirada,
    C.Nome AS NomeCliente,
    V.Modelo,
    V.Placa,
    F.Nome AS NomeFuncionario,
    ISNULL(S.Nome, 'SEM SUPERVISOR') AS NomeSupervisor
FROM Locacao L
INNER JOIN Cliente C
    ON L.CodCli = C.CodCli
INNER JOIN Veiculo V
    ON L.CodVei = V.CodVei
INNER JOIN Funcionario F
    ON L.CodFun = F.CodFun
LEFT JOIN Funcionario S
    ON F.CodSup = S.CodFun;



-- Exercicios de Transaction
-- a) Crie uma transação que insira uma nova locação na tabela Locacao com Situacao = 'Aberta' e atualize imediatamente o Status do veículo correspondente na tabela Veiculo para 'Alugado'. Caso o veículo não exista ou já esteja com status diferente de 'Disponivel', garanta que toda a operação seja desfeita.
BEGIN TRANSACTION TRN_InserirLocacaoEAtualizarVeiculo
    BEGIN TRY
        INSERT INTO Locacao (DataRetirada, DataPrevistaDevolucao, ValorTotal, Situacao, CodFun, CodCli, CodVei)
        VALUES ('2026-10-02', '2026-10-07', 500.00, 'Aberta', 1, 2, 1)

        UPDATE Veiculo
        SET StatusVeiculo = 'Alugado'
        WHERE CodVei = 1

        COMMIT TRANSACTION TRN_InserirLocacaoEAtualizarVeiculo
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION TRN_InserirLocacaoEAtualizarVeiculo
    END CATCH

-- b) Crie uma transação que finalize uma locação específica (atualizando DataDevolucaoReal, ValorTotal e Situacao = 'Finalizada'), libere o veículo para 'Disponivel' somando a quilometragem rodada e, na mesma transação, insira uma multa por atraso na tabela MultaOcorrencia vinculada à locação finalizada.
BEGIN TRANSACTION TRN_FinalizarLocacao
    BEGIN TRY
        UPDATE Locacao
        SET DataDevolucaoReal = '2026-11-28', ValorTotal = 1840.00, Situacao = 'Finalizada'
        WHERE CodLoc = 7

        UPDATE Veiculo
        SET StatusVeiculo = 'Disponivel', Quilometragem = Quilometragem + 500
        WHERE CodVei = 2

        INSERT INTO MultaOcorrencia (Descricao, ValorMulta, DataRegistro, CodLoc) 
        VALUES ('Atraso de 1 dia na devolução', 230.00, '2026-11-28', 7)

        COMMIT TRANSACTION TRN_FinalizarLocacao
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION TRN_FinalizarLocacao
    END CATCH
