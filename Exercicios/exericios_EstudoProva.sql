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
  CodReserva INT,
  DtEntrada DATE,
  DtSaida DATE,
  CodQuarto INT,
  CodHospede INT
);

CREATE TABLE Refeicao(
  CodConsumo INT,
  DescRefeicao VARCHAR(500),
  ValorRefeicao MONEY,
  CodReserva INT
);

CREATE TABLE Pagamento(
  CodPagto INT,
  ValorPagto MONEY,
  DtPagto DATE,
  CodReserva INT
);
  
  
