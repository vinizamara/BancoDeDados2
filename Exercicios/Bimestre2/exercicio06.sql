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

    CONSTRAINT PK_Quarto_CodQua PRIMARY KEY (CodQua)
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
    CONSTRAINT FK_Reserva_Quarto FOREIGN KEY (CodQua) REFERENCES Quarto(CodQua) 
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
