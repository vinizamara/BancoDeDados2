CREATE DATABASE Exercicio04;
GO

USE Exercicio04;
GO

-- 1. Tabela Departamento
CREATE TABLE Departamento (
    codDepartamento INT IDENTITY(1, 1),
    nomeDepartamento VARCHAR(100) NOT NULL,
    descDepartamento VARCHAR(250),

    CONSTRAINT pkDepartamento PRIMARY KEY (codDepartamento)
);

-- 2. Tabela Funcionario
CREATE TABLE Funcionario (
    codFuncionario INT IDENTITY(1, 1),
    nomeFuncionario VARCHAR(100) NOT NULL,
    cpf VARCHAR(11),
    rg VARCHAR(10),
    sexo CHAR(1),
    categoria VARCHAR(50),
    idade INT,
    codDepartamento INT,

    CONSTRAINT pkFuncionario PRIMARY KEY (codFuncionario),
    CONSTRAINT CPFUnico UNIQUE (cpf),
    CONSTRAINT RGUnico UNIQUE (rg),
    CONSTRAINT listSexo CHECK (sexo IN ('M', 'F')),
    CONSTRAINT listCategoria CHECK (categoria IN ('Auxiliar', 'Supervisor', 'Terceirizado', 'Contratado', 'Coordenador')),
    CONSTRAINT limiteIdade CHECK (idade BETWEEN 16 AND 65),
    CONSTRAINT fkCodDepartamento FOREIGN KEY (codDepartamento) REFERENCES Departamento(codDepartamento)
);

-- 3. Tabela Projeto
CREATE TABLE Projeto (
    codProjeto INT IDENTITY(100, 1),
    nomeProjeto VARCHAR(100) NOT NULL,
    descProjeto VARCHAR(300),

    CONSTRAINT pkProjetos PRIMARY KEY (codProjeto)
);

-- 4. Tabela FuncProjeto
CREATE TABLE FuncProjeto (
    codFuncProjeto INT IDENTITY(1, 1),
    codFuncionario INT NOT NULL,
    codProjeto INT NOT NULL,
    dataInicio DATETIME,
    dataFim DATETIME,

    CONSTRAINT pkFuncProjeto PRIMARY KEY (codFuncProjeto),
    CONSTRAINT fkFunc FOREIGN KEY (codFuncionario) REFERENCES Funcionario(codFuncionario),
    CONSTRAINT fkProj FOREIGN KEY (codProjeto) REFERENCES Projeto(codProjeto),
    CONSTRAINT datas CHECK (dataInicio <= dataFim)
);

-- Inserts Iniciais: Departamento
INSERT INTO Departamento (nomeDepartamento, descDepartamento)
VALUES
('CONTAS A PAGAR', 'Responsável pelo controle e pagamento das obrigações da empresa'),
('CONTAS A RECEBER', 'Responsável pelo controle dos recebimentos da empresa'),
('FATURAMENTO', 'Responsável pela emissão e controle de notas fiscais'),
('VENDAS', 'Responsável pelas vendas e relacionamento com clientes'),
('COMPRAS', 'Responsável pela aquisição de produtos e materiais');

-- Inserts Iniciais: Funcionario
INSERT INTO Funcionario (nomeFuncionario, cpf, rg, sexo, categoria, idade, codDepartamento)
VALUES
('Carlos Eduardo Silva', '12345678901', 'MG1234567', 'M', 'Supervisor', 35, 1),
('Ana Beatriz Souza', '23456789012', 'MG2345678', 'F', 'Coordenador', 42, 1),
('João Pedro Oliveira', '34567890123', 'MG3456789', 'M', 'Contratado', 28, 2),
('Mariana Costa Santos', '45678901234', 'MG4567890', 'F', 'Auxiliar', 23, 2),
('Rafael Almeida Lima', '56789012345', 'MG5678901', 'M', 'Supervisor', 39, 3),
('Juliana Ferreira Alves', '67890123456', 'MG6789012', 'F', 'Contratado', 31, 3),
('Lucas Henrique Martins', '78901234567', 'MG7890123', 'M', 'Auxiliar', 20, 4),
('Camila Rodrigues Dias', '89012345678', 'MG8901234', 'F', 'Coordenador', 45, 4),
('Felipe Augusto Pereira', '90123456789', 'MG9012345', 'M', 'Terceirizado', 37, 5),
('Beatriz Martins Rocha', '01234567890', 'MG0123456', 'F', 'Auxiliar', 19, 5);

-- Relacionamento do Gerente em Departamento
ALTER TABLE Departamento
ADD codGerente INT CONSTRAINT fkCodGerente FOREIGN KEY (codGerente) REFERENCES Funcionario(codFuncionario);

SELECT * FROM Departamento;

-- Inserts Iniciais: Projeto
INSERT INTO Projeto (nomeProjeto, descProjeto)
VALUES
('Implantação do Sistema Financeiro', 'Desenvolvimento e implantação de um sistema para controle financeiro'),
('Automação do Faturamento', 'Automatização dos processos de emissão e controle de notas fiscais'),
('Expansão Comercial', 'Projeto voltado para expansão das vendas e conquista de novos clientes'),
('Gestão de Compras', 'Desenvolvimento de processos para controle e gerenciamento de compras'),
('Integração de Sistemas', 'Integração dos sistemas internos para centralização das informações');

-- Inserts Iniciais: FuncProjeto
INSERT INTO FuncProjeto (codFuncionario, codProjeto, dataInicio, dataFim)
VALUES
(2, 103, '2025-08-01', '2025-09-12'),
(5, 101, '2025-05-07', '2025-11-12'),
(3, 100, '2025-02-07', '2025-03-12');

SELECT * FROM Funcionario;
SELECT * FROM Projeto;
SELECT * FROM Departamento;

UPDATE Departamento SET codGerente = 2;

-- Alteração na tabela Funcionario para inclusão de Cidade
ALTER TABLE Funcionario
ADD cidade VARCHAR(100) CONSTRAINT defaultCidade DEFAULT ('Franca');

INSERT INTO Funcionario (nomeFuncionario, cpf, rg, sexo, categoria, idade, codDepartamento)
VALUES
('Carlos Eduardo Souza', '12345677852', 'PK1234567', 'M', 'Supervisor', 29, 1);

INSERT INTO Funcionario (nomeFuncionario, cpf, rg, sexo, categoria, idade)
VALUES
('Pedrão', '12342077852', 'PK8354567', 'M', 'Supervisor', 18);

INSERT INTO Projeto (nomeProjeto, descProjeto)
VALUES
('Implantação de um novo sistema de vendas', 'Desenvolvimento e implantação de um sistema para os supervisores de venda utilizarem');

SELECT * FROM Projeto;

INSERT INTO FuncProjeto (codFuncionario, codProjeto, dataInicio, dataFim)
VALUES
(4, 104, '2026-09-03', '2026-09-07'),
(3, 104, '2026-09-03', '2026-09-07'),
(6, 104, '2026-09-03', '2026-09-07');

SELECT * FROM FuncProjeto;
SELECT * FROM Funcionario;

UPDATE Funcionario 
SET codDepartamento = 3
WHERE codDepartamento IS NULL;

-- Adicionando Defaults para Descrições
ALTER TABLE Departamento
ADD CONSTRAINT defaultDescDepartamento DEFAULT ('Sem descrição') FOR descDepartamento;

ALTER TABLE Projeto
ADD CONSTRAINT defaultDescProjeto DEFAULT ('Sem descrição') FOR descProjeto;

-- ================================================================

/*
Exercícios de Fixação: Consultas com JOINs
Usando o banco de dados criado no exercício anterior (Exercícios CONSTRAINTS 02), 
anote o código SQL para fazer as consultas.
*/

-- 1. Selecione os nomes e CPFs dos funcionários, junto com os nomes dos departamentos onde eles trabalham.
SELECT 
    Funcionario.nomeFuncionario, 
    Funcionario.cpf, 
    Departamento.nomeDepartamento
FROM Funcionario 
INNER JOIN Departamento
    ON Funcionario.codDepartamento = Departamento.codDepartamento;

-- 2. Selecione os nomes dos funcionários que não gerenciam departamentos.
SELECT
    Funcionario.nomeFuncionario
FROM Funcionario
LEFT JOIN Departamento
    ON Funcionario.codFuncionario = Departamento.codGerente
    WHERE Departamento.codGerente IS NULL;

-- 3. Quantos funcionários da categoria Auxiliar existem no departamento de Compras? / FALATA COUNT
SELECT
    Funcionario.nomeFuncionario,
    Funcionario.categoria
FROM Funcionario
INNER JOIN Departamento
    ON Funcionario.codDepartamento = Departamento.codDepartamento
    WHERE Funcionario.categoria = 'Auxiliar' and Departamento.nomeDepartamento = 'Compras';

-- 4. Quais os nomes e CPFs dos funcionários que foram inseridos em novos projetos no mês de Agosto?

-- 5. Qual o nome de cada departamento e os nomes dos seus gerentes?

-- 6. Qual a maior idade e idade média dos funcionários dos departamentos FATURAMENTO, VENDAS ou COMPRAS?

-- 7. Liste os nomes dos funcionários, nomes e descrição de cada projeto que trabalham.

-- 8. Liste os nomes dos funcionários, nomes dos departamentos em que trabalham e nomes dos gerentes de cada departamento. Liste em ordem alfabética do nome do departamento e depois do nome do funcionário.
