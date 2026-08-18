-- Criação do banco de dados

CREATE DATABASE exercicios02;
GO

-- Seleciona o banco de dados

USE exercicios02;
GO

-- Criação da tabela Hospede

CREATE TABLE Hospede (
    CodHospede INT PRIMARY KEY IDENTITY(1,1),
    Nome VARCHAR(100) NOT NULL,
    Idade INT NOT NULL,
    Sexo CHAR(1) NOT NULL
);
GO


-- Criação da tabela Quarto

CREATE TABLE Quarto (
    CodQuarto INT PRIMARY KEY IDENTITY(1,1),
    Tipo VARCHAR(50) NOT NULL,
    Numero INT NOT NULL,
    Andar INT NOT NULL
);
GO


-- Criação da tabela Reserva

CREATE TABLE Reserva (
    CodReserva INT PRIMARY KEY IDENTITY(1,1),
    DtEntrada DATE NOT NULL,
    DtSaida DATE NOT NULL,
    CodHospede INT NOT NULL FOREIGN KEY REFERENCES Hospede(CodHospede),
    CodQuarto INT NOT NULL FOREIGN KEY REFERENCES Quarto(CodQuarto)
);
GO


-- Criação da tabela Pagamento

CREATE TABLE Pagamento (
    CodPagto INT PRIMARY KEY IDENTITY(1,1),
    Valor DECIMAL(10,2) NOT NULL,
    DtPagto DATE NOT NULL,
    CodReserva INT NOT NULL FOREIGN KEY REFERENCES Reserva(CodReserva)
);
GO


-- Criação da tabela Refeicao

CREATE TABLE Refeicao (
    CodConsumo INT PRIMARY KEY IDENTITY(1,1),
    DescRefeicao VARCHAR(100) NOT NULL,
    Valor DECIMAL(10,2) NOT NULL,
    CodReserva INT NOT NULL FOREIGN KEY REFERENCES Reserva(CodReserva)
);
GO

-- EXERCICIOS 02:

-- 1. Observe o DER apresentado e crie o banco de dados correspondente. 
-- As chaves primárias de todas as tabelas deverão ter numeração automática.

-- 2. Cadastre 5 quartos, 8 hóspedes, 4 reservas e 6 refeições.
-- 5 Quartos
INSERT INTO Quarto (Tipo, Numero, Andar)
VALUES
('Standard', 101, 1),
('Standard', 102, 1),
('Superior', 201, 2),
('Superior Master', 202, 2),
('Superior Master', 301, 3);

-- 8 Hóspedes
INSERT INTO Hospede (Nome, Idade, Sexo)
VALUES
('João Silva', 25, 'M'),
('Maria Santos', 32, 'F'),
('Carlos Oliveira', 41, 'M'),
('Ana Souza', 28, 'F'),
('Pedro Costa', 35, 'M'),
('Juliana Lima', 24, 'F'),
('Rafael Almeida', 45, 'M'),
('Beatriz Ferreira', 30, 'F');

-- 4 Reservas
INSERT INTO Reserva (DtEntrada, DtSaida, CodHospede, CodQuarto)
VALUES
('2026-08-01', '2026-08-05', 1, 1),
('2026-08-03', '2026-08-07', 2, 2),
('2026-08-10', '2026-08-15', 3, 3),
('2026-08-12', '2026-08-18', 4, 4);

-- 6 Refeições
INSERT INTO Refeicao (DescRefeicao, Valor, CodReserva)
VALUES
('Café da manhã', 25.00, 1),
('Almoço', 45.00, 1),
('Jantar', 50.00, 2),
('Café da manhã', 25.00, 2),
('Almoço', 45.00, 3),
('Jantar', 50.00, 4);

-- 3. Qual a quantidade de quartos do tipo 'Superior Master' existe neste hotel?
SELECT COUNT(CodQuarto) AS Quantidade FROM Quarto WHERE Tipo = 'Superior Master';

-- 4. Qual o valor médio pago por uma refeição?
SELECT AVG(Valor) AS valorMedio FROM Refeicao;

-- 5. Exclua o campo Idade e crie um campo para guardar a data de nascimento dos hóspedes.

ALTER TABLE Hospede
DROP COLUMN Idade;

ALTER TABLE Hospede
ADD DtNascimento DATE;


-- 6. Quantos hóspedes fizeram reserva neste hotel?

SELECT COUNT(DISTINCT CodHospede) AS Quantidade
FROM Reserva;


-- 7. Selecione os nomes dos hóspedes e as datas de entradas das suas reservas.

SELECT H.Nome, R.DtEntrada
FROM Hospede H
INNER JOIN Reserva R
ON H.CodHospede = R.CodHospede;


-- 8. Atualize as datas de nascimentos de cada hóspede.

UPDATE Hospede
SET DtNascimento = '2001-05-10'
WHERE CodHospede = 1;

UPDATE Hospede
SET DtNascimento = '1994-08-15'
WHERE CodHospede = 2;

UPDATE Hospede
SET DtNascimento = '1985-03-20'
WHERE CodHospede = 3;

UPDATE Hospede
SET DtNascimento = '1998-11-05'
WHERE CodHospede = 4;

UPDATE Hospede
SET DtNascimento = '1991-07-12'
WHERE CodHospede = 5;

UPDATE Hospede
SET DtNascimento = '2002-02-28'
WHERE CodHospede = 6;

UPDATE Hospede
SET DtNascimento = '1981-09-18'
WHERE CodHospede = 7;

UPDATE Hospede
SET DtNascimento = '1996-12-03'
WHERE CodHospede = 8;


-- 9. Selecione os nomes dos hóspedes, juntamente com as datas de entrada
-- das hospedagens que aconteceram antes do dia 01/01/2025.
-- Faça esta lista mostrando os hóspedes em ordem alfabética.

SELECT H.Nome, R.DtEntrada
FROM Hospede H
INNER JOIN Reserva R
ON H.CodHospede = R.CodHospede
WHERE R.DtEntrada < '2025-01-01'
ORDER BY H.Nome;


-- 10. Selecione os nomes das mulheres que já se hospedaram no 4º andar.

SELECT H.Nome
FROM Hospede H
INNER JOIN Reserva R
ON H.CodHospede = R.CodHospede
INNER JOIN Quarto Q
ON R.CodQuarto = Q.CodQuarto
WHERE H.Sexo = 'F'
AND Q.Andar = 4;


-- 11. Selecione os números e tipos dos quartos que ainda não tiveram reservas.

SELECT Q.Numero, Q.Tipo
FROM Quarto Q
LEFT JOIN Reserva R
ON Q.CodQuarto = R.CodQuarto
WHERE R.CodReserva IS NULL;


-- 12. O hóspede 'João da Silva' pagou quanto por suas hospedagens?

SELECT H.Nome, SUM(P.Valor) AS TotalPago
FROM Hospede H
INNER JOIN Reserva R
ON H.CodHospede = R.CodHospede
INNER JOIN Pagamento P
ON R.CodReserva = P.CodReserva
WHERE H.Nome = 'João Silva'
GROUP BY H.Nome;


-- 13. Quantos hóspedes ficaram hospedados mais de 5 dias durante o mês de fevereiro deste ano?

SELECT COUNT(DISTINCT CodHospede) AS Quantidade
FROM Reserva
WHERE DATEDIFF(DAY, DtEntrada, DtSaida) > 5
AND MONTH(DtEntrada) = 2
AND YEAR(DtEntrada) = YEAR(GETDATE());
