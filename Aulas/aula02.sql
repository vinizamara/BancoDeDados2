CREATE DATABASE Escola;
GO

USE Escola;
GO

CREATE TABLE Professores(
        codProf int CONSTRAINT pkCodProf PRIMARY KEY IDENTITY(1, 1),
        nome varchar(80) NOT NULL,
        RG numeric(12) UNIQUE,
        sexo char(1) CHECK(sexo in ('M', 'F')),
        idade int check(idade between 21 and 80),
        cidade varchar(50) CONSTRAINT defaultCidadeProf DEFAULT('FRANCA'),
        titulacao varchar(15) CONSTRAINT checkTit check(
                titulacao in ('graduado', 'especialista','mestre', 'doutor')
        ),
        categoria varchar(15) check(
                categoria in ('auxiliar', 'assistente', 'adjunto', 'titular')
        ),
        salario money check (salario >= 1000)
)

SELECT * FROM Professores;

INSERT INTO Professores(nome, RG, sexo, idade, titulacao, categoria)
        VALUES
        ('Peter', 123456, 'M', 25, 'GRADUADO', 'ADJUNTO')

UPDATE Professores set salario = 1500
        WHERE RG = 123456
