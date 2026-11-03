CREATE DATABASE Exercicio05
GO

USE Exercicio05
GO

CREATE TABLE Cliente(
  idCliente INT IDENTITY(1, 1),
  nome VARCHAR(250),
  fone VARCHAR(12),
  limiteCredito MONEY
  
  CONSTRAINT PK_Cliente_idCliente PRIMARY KEY (idCliente),
);

CREATE TABLE Endereco(
  idEndereco INT IDENTITY(1, 1),
  rua VARCHAR(250),
  numero VARCHAR(10), 
  bairro VARCHAR(250), 
  CEP CHAR(8),
  idCliente INT,
  
  CONSTRAINT PK_Endereco_idEndereco PRIMARY KEY (idEndereco),
  CONSTRAINT FK_Endereco_Cliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
);

-- CREATE TABLE Financeiro(
--     idFinanceiro INT IDENTITY(1, 1),
--     dataLancamento DATE DEFAULT GETDATE(),
--     valorFinanceiro MONEY,
--     dataVencimento DATE,
--     dataLiquidacao DATE
-- )
