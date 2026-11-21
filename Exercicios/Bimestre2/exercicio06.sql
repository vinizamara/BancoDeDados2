CREATE DATABASE HotelDB;
GO

USE HotelDB;
GO

-- TABELA EMPREGADO
CREATE TABLE Empregado (
    CodEmp INT IDENTITY (1, 1),
    Nome VARCHAR(100),
    Salario money,
    Funcao VARCHAR(50),

    CONSTRAINT PK_Empregado_CodEmp PRIMARY KEY (CodEmp),
    CONSTRAINT CK_Empregado_SalarioMenor1800 CHECK(Salario >= 1800), -- c)
    CONSTRAINT CK_Empregado_FuncaoValoresDefinidos CHECK(Funcao IN ('Gerente', 'Recepcionista', 'Camareira', 'Supervisor')) -- d)
);

-- TABELA HOSPEDE
CREATE TABLE Hospede (
    CodHos INT IDENTITY (1, 1),
    Nome VARCHAR(100),
    Profissao VARCHAR(100),
    Cidade VARCHAR(100),

    CONSTRAINT PK_Hospede_CodHos PRIMARY KEY (CodHos)
);

-- TABELA QUARTO
CREATE TABLE Quarto (
    CodQua INT IDENTITY(1, 1),
    Numero INT,
    Capacidade INT,
    Preco money,

    CONSTRAINT PK_Quarto_CodQua PRIMARY KEY (CodQua),
    CONSTRAINT CK_Quarto_CapacidadeMinMax CHECK (Capacidade BETWEEN 1 AND 5), -- e)
    CONSTRAINT UQ_Quarto_Numero UNIQUE (Numero), -- f)
);

-- TABELA RESERVA
CREATE TABLE Reserva (
    CodRes INT IDENTITY(1, 1),
    DtEntrada DATE,
    DtSaida DATE,
    TotalGasto DECIMAL(10,2),
    CodEmp INT,
    CodHos INT,
    CodQua INT,

    CONSTRAINT PK_Reserva_CodRes PRIMARY KEY (CodRes),
    CONSTRAINT FK_Reserva_Empregado FOREIGN KEY (CodEmp) REFERENCES Empregado(CodEmp),
    CONSTRAINT FK_Reserva_Hospede FOREIGN KEY (CodHos) REFERENCES Hospede(CodHos),
    CONSTRAINT FK_Reserva_Quarto FOREIGN KEY (CodQua) REFERENCES Quarto(CodQua),
    CONSTRAINT CK_Reserva_DtSaidaPosteriorDtEntrada CHECK(DtSaida > DtEntrada) -- g)
);

-- Exercícios de revisão geral
-- 1. Crie o BD representado acima, inclusive com as seguintes restrições de integridade:
-- a) Cada tabela deve ter uma chave primária com numeração automática.
-- b) Analise os relacionamentos e crie as chaves estrangeiras necessárias.
-- c) O salário de um empregado não poderá ser inferior a R$ 1.800,00.
-- d) A função deverá aceitar apenas os valores: Gerente, Recepcionista, Camareira ou Supervisor.
-- e) Cada quarto deverá acomodar, no mínimo, 1 pessoa e, no máximo, 5 pessoas.
-- f) Não poderão existir dois quartos cadastrados com o mesmo número.
-- g) A data de saída de uma reserva deverá ser obrigatoriamente posterior à data de entrada.

-- INSERÇÕES:

INSERT INTO Empregado (Nome, Salario, Funcao)
VALUES
('Carlos Eduardo Silva', 4500.00, 'Gerente'),
('Mariana Souza', 2400.00, 'Recepcionista'),
('Fernanda Lima', 2200.00, 'Recepcionista'),
('Juliana Costa', 1950.00, 'Camareira'),
('Roberto Almeida', 3200.00, 'Supervisor');

INSERT INTO Hospede (Nome, Profissao, Cidade)
VALUES
('Ana Paula Mendes', 'Engenheira', 'Franca'),
('Lucas Ferreira', 'Advogado', 'Ribeirão Preto'),
('Beatriz Santos', 'Médica', 'São Paulo'),
('Rafael Oliveira', 'Analista de Sistemas', 'Franca'),
('Camila Rocha', 'Arquiteta', 'Campinas');

INSERT INTO Quarto (Numero, Capacidade, Preco)
VALUES
(101, 2, 250.00),
(102, 1, 180.00),
(201, 4, 420.00),
(202, 5, 550.00),
(301, 2, 300.00); -- Quarto sem reservas para testar LEFT JOIN na questão 3

INSERT INTO Reserva (DtEntrada, DtSaida, TotalGasto, CodEmp, CodHos, CodQua)
VALUES
('2026-10-01', '2026-10-04', 750.00, 2, 1, 1),
('2026-10-05', '2026-10-07', 360.00, 3, 2, 2),
('2026-10-10', '2026-10-15', 2100.00, 2, 3, 3),
('2026-10-12', '2026-10-14', 500.00, 3, 4, 1),
('2026-10-20', '2026-10-23', 1650.00, 1, 1, 4);

-- 2 - Crie uma view que apresente o código da reserva, nome do hóspede, número do quarto, nome do empregado, datas de entrada e saída e valor total gasto.

GO
CREATE VIEW VW_MostrarReserva AS
SELECT R.CodRes, H.Nome AS NomeHospede, Q.Numero, E.Nome AS NomeEmpregado, R.DtEntrada, R.DtSaida, R.TotalGasto
FROM Reserva R
INNER JOIN Hospede H 
ON H.CodHos = R.CodHos
INNER JOIN Quarto Q
ON Q.CodQua = R.CodQua
INNER JOIN Empregado E
ON E.CodEmp = R.CodEmp;
GO

SELECT * FROM VW_MostrarReserva;

-- 3 - Crie uma view que apresente o número do quarto, preço da diária, quantidade de reservas e valor total arrecadado por quarto, incluindo os quartos sem reservas.
GO
CREATE VIEW VW_DadosQuartos AS
SELECT Q.Numero, Q.Preco, COUNT(R.CodRes) AS QuantidadeReservaQuarto, ISNULL(SUM(R.TotalGasto), 0.00) AS TotalGastoReserva
FROM Quarto Q
LEFT JOIN Reserva R
ON Q.CodQua = R.CodQua
GROUP BY Q.Numero, Q.Preco;
GO

SELECT * FROM VW_DadosQuartos;

-- 4 - Crie uma transação que cadastre uma nova reserva e atualize o salário do empregado responsável, aumentando-o em 5%. 
BEGIN TRANSACTION TRAN_NovaReserva
    BEGIN TRY
        INSERT INTO Reserva (DtEntrada, DtSaida, TotalGasto, CodEmp, CodHos, CodQua)
        VALUES ('2026-10-10', '2026-10-11', 20.00, 1, 1, 1)

        UPDATE Empregado 
        SET salario = salario * 1.05
        WHERE CodEmp = 1

        COMMIT TRANSACTION TRAN_NovaReserva
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION TRAN_NovaReserva
    END CATCH

-- 5 - Crie uma transação que exclua uma reserva e reduza em 10% o preço da diária do quarto associado.
BEGIN TRANSACTION TRAN_ExcluirReserva
    BEGIN TRY
        UPDATE Quarto SET preco = preco * 0.90 WHERE CodQua = (SELECT CodQua FROM Reserva WHERE CodRes = 1);

        DELETE FROM Reserva WHERE CodRes = 1;

        COMMIT TRANSACTION TRAN_ExcluirReserva
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION TRAN_ExcluirReserva
    END CATCH

-- 6 - Crie uma consulta que apresente a quantidade de reservas e o valor total gasto pelos hóspedes de cada cidade.
SELECT H.Cidade AS CidadeHospede, H.Nome, COUNT(R.CodRes) AS QuantidadeReservas, SUM(R.TotalGasto) AS TotalGastoReservas
FROM Reserva R
INNER JOIN Hospede H
ON R.CodHos = H.CodHos
GROUP BY H.Cidade;

-- 7 - Crie uma consulta que apresente a função dos empregados, a quantidade de empregados por função e a média salarial de cada função.
SELECT E.Funcao, COUNT(E.CodEmp) AS QuantidadeEmpregados, AVG(E.Salario) AS MediaSalarial
FROM Empregado E
GROUP BY E.Funcao;

