/*
Em um novo BD, crie as tabelas com as seguintes estruturas:

Func

CodFunc – número inteiro,

PrimeiroNome – texto de tamanho (50),

SegundoNome – texto de tamanho (50),

UltimoNome – texto de tamanho (50),

DataNasci – data e hora,

CPF – texto de tamanho (20),

RG – texto de tamanho (20),

Endereco – texto de tamanho (50),

CEP – texto de tamanho (15),

Cidade – texto de tamanho (50),

Fone – texto de tamanho (50),

CodDepto – número inteiro,

Funcao – texto de tamanho (50),

Salario – Money (SQL) ou Numeric(8.2)

 

Depto

CodDepto – número inteiro,

Nome – texto de tamanho (50),

Localizacao – texto de tamanho (50),

CodigoFuncionarioGerente – número inteiro

 

 

 

1.        Listar todos os campos de funcionários ordenados por cidade.

2.        Obter os nomes dos funcionários nascidos entre as datas 1950-01-01 e 1970-01-01.

3.        Liste os funcionários que têm salário superior a R$ 1.000,00 ordenados pelo nome completo.

4.        Liste a data de nascimento e o primeiro nome dos funcionários ordenados do mais novo para o mais velho.

5.        Liste o total da folha de pagamento.

6.        Liste o nome, o nome do departamento e a função de todos os funcionários.

7.        Liste todos departamentos com seus respectivos gerentes.

8.        Liste o valor da folha de pagamento de cada departamento (nome).

9.        Liste os departamentos dos funcionários que têm a função de supervisor.

10.    Liste a quantidade de funcionários desta empresa.

11.    Liste o salário médio pago pela empresa.

12.    Liste a quantidade de funcionários que trabalham em cada departamento.

13.    Liste o menor salário pago pela empresa em cada departamento.

14.    Liste o nome completo de todos os funcionários que não tenham segundo nome.
*/

CREATE DATABASE exerc04;
GO
USE exerc04;
GO

CREATE TABLE Func (
    CodFunc INT NOT NULL,
    PrimeiroNome VARCHAR(50) NOT NULL,
    SegundoNome VARCHAR(50) NULL,
    UltimoNome VARCHAR(50) NOT NULL,
    DataNasci DATETIME NULL,
    CPF VARCHAR(20) NULL,
    RG VARCHAR(20) NULL,
    Endereco VARCHAR(50) NULL,
    CEP VARCHAR(15) NULL,
    Cidade VARCHAR(50) NULL,
    Fone VARCHAR(50) NULL,
    CodDepto INT NULL,
    Funcao VARCHAR(50) NULL,
    Salario MONEY NULL
);

CREATE TABLE Depto (
    CodDepto INT NOT NULL,
    Nome VARCHAR(50) NOT NULL,
    Localizacao VARCHAR(50) NULL,
    CodigoFuncionarioGerente INT NULL
);

ALTER TABLE Func 
ADD CONSTRAINT pk_func PRIMARY KEY (CodFunc);

ALTER TABLE Depto 
ADD CONSTRAINT pk_depto PRIMARY KEY (CodDepto);

ALTER TABLE Func 
ADD CONSTRAINT fk_func_depto FOREIGN KEY (CodDepto) 
REFERENCES Depto (CodDepto);

ALTER TABLE Depto 
ADD CONSTRAINT fk_depto_gerente FOREIGN KEY (CodigoFuncionarioGerente) 
REFERENCES Func (CodFunc);
GO

INSERT INTO Depto (CodDepto, Nome, Localizacao, CodigoFuncionarioGerente) 
VALUES
    (1, 'RH', 'SUL', NULL),
    (2, 'COMPRAS', 'SUL', NULL),
    (3, 'VENDAS', NULL, NULL),
    (4, 'FINANCEIRO', 'NORTE', NULL),
    (5, 'MARKETING', 'NORTE', NULL),
    (6, 'DESENVOLVIMENTO', NULL, NULL),
    (7, 'CONTABILIDADE', NULL, NULL);

INSERT INTO Func (CodFunc, PrimeiroNome, SegundoNome, UltimoNome, DataNasci, CPF, RG, Endereco, CEP, Cidade, Fone, CodDepto, Funcao, Salario) 
VALUES 
    (1, 'JOSE', 'MANOEL', 'DA SILVA', '1965-03-15', '000.111.222-33', '10.111.222-3', 'RUA X, 10', '14400-000', 'FRANCA', '(16) 99999-0000', 7, 'CONTADOR', 1700.00),
    (2, 'MARIA', 'FERNANDA', 'SANTOS', '1992-05-15', '111.222.333-44', '12.345.678-9', 'RUA A, 100', '14400-000', 'FRANCA', '(16) 99999-1111', 1, 'GERENTE DE RH', 5500.00),
    (3, 'CARLOS', 'EDUARDO', 'OLIVEIRA', '1988-10-20', '222.333.444-55', '23.456.789-0', 'AV B, 250', '14401-111', 'RIBEIRAO PRETO', '(16) 99999-2222', 2, 'COMPRADOR', 3800.00),
    (4, 'ANA', NULL, 'SOUZA', '1958-03-12', '333.444.555-66', '34.567.890-1', 'RUA C, 45', '14402-222', 'FRANCA', '(16) 99999-3333', 3, 'VENDEDORA', 2900.00),
    (5, 'ROBERTO', 'ALVES', 'PEREIRA', '1985-07-08', '444.555.666-77', '45.678.901-2', 'AV D, 1200', '14403-333', 'BATATAIS', '(16) 99999-4444', 4, 'GERENTE FINANCEIRO', 6200.00),
    (6, 'JULIANA', 'CRISTINA', 'LIMA', '1990-12-01', '555.666.777-88', '56.789.012-3', 'RUA E, 88', '14404-444', 'FRANCA', '(16) 99999-5555', 5, 'ANALISTA DE MARKETING', 4100.00),
    (7, 'LUCAS', NULL, 'RODRIGUES', '1998-09-18', '666.777.888-99', '67.890.123-4', 'RUA F, 500', '14405-555', 'FRANCA', '(16) 99999-6666', 6, 'DESENVOLVEDOR', 4800.00),
    (8, 'FERNANDO', 'RICARDO', 'ALMEIDA', '1987-03-22', '777.888.999-00', '78.901.234-5', 'RUA G, 300', '14406-666', 'FRANCA', '(16) 99999-7777', 3, 'SUPERVISOR', 5200.00),
    (9, 'CAMILA', 'BEATRIZ', 'CASTRO', '1991-08-14', '888.999.000-11', '89.012.345-6', 'AV H, 750', '14407-777', 'FRANCA', '(16) 99999-8888', 2, 'SUPERVISOR', 5100.00),
    (10, 'MARCOS', NULL, 'ROCHA', '1969-11-05', '999.000.111-22', '90.123.456-7', 'RUA I, 120', '14408-888', 'BATATAIS', '(16) 99999-9999', 4, 'SUPERVISOR', 5300.00);

UPDATE Depto SET CodigoFuncionarioGerente = 2 WHERE CodDepto = 1;
UPDATE Depto SET CodigoFuncionarioGerente = 5 WHERE CodDepto = 4;
UPDATE Depto SET CodigoFuncionarioGerente = 1 WHERE CodDepto = 7;
GO

-- 1.
SELECT *
FROM Func
ORDER BY Cidade;

-- 2.
SELECT 
    PrimeiroNome, 
    SegundoNome, 
    UltimoNome, 
    DataNasci
FROM Func
WHERE DataNasci BETWEEN '1950-01-01' AND '1970-01-01';

-- 3.
SELECT 
    PrimeiroNome + ' ' + ISNULL(SegundoNome + ' ', '') + UltimoNome AS NomeCompleto,
    Salario
FROM Func
WHERE Salario > 1000.00
ORDER BY PrimeiroNome, SegundoNome, UltimoNome;

-- 4.
SELECT 
    DataNasci, 
    PrimeiroNome
FROM Func
ORDER BY DataNasci DESC;

-- 5.
SELECT 
    SUM(Salario) AS TotalFolhaPagamento
FROM Func;

-- 6.
SELECT 
    f.PrimeiroNome,
    d.Nome AS NomeDepartamento,
    f.Funcao
FROM Func f
INNER JOIN Depto d 
    ON f.CodDepto = d.CodDepto;

-- 7.
SELECT 
    d.Nome AS NomeDepartamento,
    f.PrimeiroNome + ' ' + ISNULL(f.SegundoNome + ' ', '') + f.UltimoNome AS NomeGerente
FROM Depto d
INNER JOIN Func f 
    ON d.CodigoFuncionarioGerente = f.CodFunc;

-- 8.
SELECT 
    d.Nome AS NomeDepartamento,
    SUM(f.Salario) AS TotalFolhaPagamento
FROM Depto d
INNER JOIN Func f 
    ON d.CodDepto = f.CodDepto
GROUP BY d.Nome;

-- 9.
SELECT DISTINCT 
    d.Nome AS NomeDepartamento
FROM Depto d
INNER JOIN Func f 
    ON d.CodDepto = f.CodDepto
WHERE f.Funcao = 'SUPERVISOR';

-- 10.
SELECT 
    COUNT(*) AS QuantidadeTotalFuncionarios
FROM Func;

-- 11.
SELECT 
    AVG(Salario) AS SalarioMedio
FROM Func;

-- 12.
SELECT 
    d.Nome AS NomeDepartamento,
    COUNT(f.CodFunc) AS QuantidadeFuncionarios
FROM Depto d
INNER JOIN Func f 
    ON d.CodDepto = f.CodDepto
GROUP BY d.Nome;

-- 13.
SELECT 
    d.Nome AS NomeDepartamento,
    MIN(f.Salario) AS MenorSalario
FROM Depto d
INNER JOIN Func f 
    ON d.CodDepto = f.CodDepto
GROUP BY d.Nome;

-- 14.
SELECT 
    PrimeiroNome + ' ' + UltimoNome AS NomeCompleto
FROM Func
WHERE SegundoNome IS NULL OR TRIM(SegundoNome) = '';
