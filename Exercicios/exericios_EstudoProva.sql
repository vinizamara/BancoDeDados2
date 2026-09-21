CREATE DATABASE DB_Hotelaria;
GO

USE DB_Hotelaria;
GO

CREATE TABLE Quarto(
  CodQuarto INT IDENTITY(1, 1),
  Tipo VARCHAR(100) NOT NULL,
  Numero INT NOT NULL UNIQUE,
  Andar INT,
  
  CONSTRAINT PK_Quarto_CodQuarto PRIMARY KEY (CodQuarto), 
  CONSTRAINT CK_Quarto_AndarEntre1e20 CHECK (Andar BETWEEN 1 AND 20)
);

CREATE TABLE Hospede(
  CodHospede INT IDENTITY (1, 1),
  Nome VARCHAR(100) NOT NULL,
  Idade INT,
  Sexo CHAR(1),
  
  CONSTRAINT PK_Hospede_CodHospede PRIMARY KEY (CodHospede), 
  CONSTRAINT CK_Hospede_IdadeEntre18e120 CHECK(Idade BETWEEN 18 AND 120),
  CONSTRAINT CK_Hospede_SexoMouF CHECK(Sexo IN ('M', 'F'))
);

CREATE TABLE Reserva(
  CodReserva INT IDENTITY (100, 1),
  DtEntrada DATE,
  DtSaida DATE,
  CodHospede INT,
  CodQuarto INT,
  
  CONSTRAINT PK_Reserva_CodReserva PRIMARY KEY (CodReserva),
  CONSTRAINT FK_Reserva_Hospede FOREIGN KEY (CodHospede) REFERENCES Hospede(CodHospede),
  CONSTRAINT FK_Reserva_Quarto FOREIGN KEY (CodQuarto) REFERENCES Quarto(CodQuarto), 
  CONSTRAINT CK_Reserva_DtEntradaMenorQueDtSaida CHECK (DtEntrada < DtSaida)
);

CREATE TABLE Refeicao(
  CodConsumo INT IDENTITY(1, 1),
  DescRefeicao VARCHAR(500) DEFAULT 'Sem descrição',
  ValorRefeicao MONEY,
  CodReserva INT, 
  
  CONSTRAINT PK_Refeicao_CodConsumo PRIMARY KEY (CodConsumo), 
  CONSTRAINT FK_Refeicao_Reserva FOREIGN KEY (CodReserva) REFERENCES Reserva(CodReserva), 
  CONSTRAINT CK_Refeicao_ValorRefeicaoMaiorQue0 CHECK (ValorRefeicao > 0)
);

CREATE TABLE Pagamento(
  CodPagto INT IDENTITY (1, 1),
  ValorPagto MONEY,
  DtPagto DATETIME DEFAULT GETDATE(),
  CodReserva INT,
  
  CONSTRAINT PK_Pagamento_CodPagto PRIMARY KEY (CodPagto), 
  CONSTRAINT FK_Pagamento_Reserva FOREIGN KEY (CodReserva) REFERENCES Reserva(CodReserva),
  CONSTRAINT CK_Pagamento_ValorPagtoMaiorQue0 CHECK (ValorPagto > 0)
);

-- 1. Inserção dos 5 Quartos (incluindo o 'Superior Master')
INSERT INTO Quarto (Tipo, Numero, Andar)
VALUES 
('Superior Master', 100, 4),
('Luxo', 101, 1),
('Standard', 102, 1),
('Executivo', 201, 2),
('Superior Master', 401, 4);

-- 2. Inserção dos 8 Hóspedes
INSERT INTO Hospede (Nome, Idade, Sexo)
VALUES 
('Glauber', 27, 'M'),
('João da Silva', 35, 'M'),
('Maria Oliveira', 29, 'F'),
('Ana Souza', 42, 'F'),
('Carlos Pereira', 50, 'M'),
('Fernanda Lima', 23, 'F'),
('Roberto Alves', 61, 'M'),
('Beatriz Costa', 31, 'F');

-- 3. Inserção das 4 Reservas 
-- (CodReserva iniciará em 100 conforme o IDENTITY(100,1))
INSERT INTO Reserva (DtEntrada, DtSaida, CodHospede, CodQuarto)
VALUES 
('2026-01-10', '2026-01-15', 1, 1), -- Glauber no Quarto 100
('2026-02-01', '2026-02-08', 2, 5), -- João da Silva no Quarto 401
('2026-02-10', '2026-02-14', 3, 2), -- Maria Oliveira no Quarto 101
('2026-03-05', '2026-03-10', 4, 3); -- Ana Souza no Quarto 102

-- 4. Inserção das 6 Refeições
INSERT INTO Refeicao (DescRefeicao, ValorRefeicao, CodReserva)
VALUES 
('Café da Manhã Especial', 35.00, 100),
('Almoço Executivo', 45.50, 100),
('Jantar À la Carte', 85.00, 101),
('Café da Manhã Simples', 18.00, 101),
('Lanche da Tarde', 15.00, 102),
('Jantar Tropical', 62.00, 103);

-- 7:
ALTER TABLE Hospede
ADD Cidade VARCHAR(100) DEFAULT 'Franca';

INSERT INTO Hospede (Nome, Idade, Sexo)
VALUES ('Lucas Mendes', 30, 'M');

SELECT * FROM Hospede WHERE Cidade = 'Franca';

-- 8:
SELECT * FROM Refeicao;

UPDATE Refeicao 
SET ValorRefeicao = ValorRefeicao * 1.10
WHERE ValorRefeicao < 20

SELECT * FROM Refeicao;

-- 9:
SELECT * FROM Hospede;

ALTER TABLE Hospede
DROP CONSTRAINT CK_Hospede_IdadeEntre18e120

ALTER TABLE Hospede
DROP COLUMN Idade;

ALTER TABLE Hospede
ADD DataNascimento DATE;

SELECT * FROM Hospede;

-- 10:
SELECT COUNT(*) AS QuantidadeQuartosSuperiorMaster 
FROM Quarto
WHERE Tipo = 'Superior Master';

-- 11:
SELECT 
AVG(ValorRefeicao) AS ValorMedioRefeicao,
MAX(ValorRefeicao) AS ValorMaiorRefeicao,
MIN(ValorRefeicao) AS ValorMenorRefeicao
FROM Refeicao;

-- 12:
SELECT DISTINCT Tipo AS TiposQuartosCadastrados
FROM Quarto
ORDER BY Tipo;

-- 13:
SELECT
CodReserva, DtEntrada, DtSaida
FROM Reserva
WHERE DtEntrada BETWEEN '2026-01-01' AND '2026-02-28'; 

--14:
SELECT 
CodConsumo, DescRefeicao, ValorRefeicao, 
(ValorRefeicao * 0.85) AS ValorRefeicaoDesconto15Porcento
FROM Refeicao;

--15:
SELECT
Nome, DtEntrada
FROM Hospede AS H
INNER JOIN Reserva AS R
ON H.CodHospede = R.CodHospede;

--16:
SELECT
Numero, tipo
FROM Quarto AS Q
LEFT JOIN Reserva AS R
ON Q.CodQuarto = R.CodQuarto
WHERE R.CodQuarto IS NULL;

--17:
SELECT
SUM(ValorRefeicao) AS TotalGastoRefeicao
FROM Refeicao
INNER JOIN Reserva
ON Refeicao.CodReserva = Reserva.CodReserva
INNER JOIN Hospede
ON Hospede.CodHospede = Reserva.CodHospede
WHERE Nome = 'João da Silva';

--18:
SELECT 
Nome AS MulheresHospedaram4Andar
FROM Hospede
INNER JOIN Reserva
ON Hospede.CodHospede = Reserva.CodHospede
INNER JOIN Quarto
ON Quarto.CodQuarto = Reserva.CodQuarto
WHERE Sexo = 'F' AND Andar = 4
ORDER BY Nome;
