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
