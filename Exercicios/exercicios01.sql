CREATE DATABASE ClinicaVeterinaria;
GO

USE ClinicaVeterinaria;
GO

CREATE TABLE Veterinario (
    CodMed INT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    DataNasc DATE NOT NULL
);

CREATE TABLE Animal (
    CodPac INT PRIMARY KEY,
    NomeAnimal VARCHAR(100) NOT NULL,
    Especie VARCHAR(50) NOT NULL
);

CREATE TABLE Consulta (
    CodCons INT PRIMARY KEY,
    DataCons DATE NOT NULL,
    Valor DECIMAL(10,2) NOT NULL,
    CodMed INT NOT NULL,
    CodPac INT NOT NULL,

    CONSTRAINT FK_Consulta_Veterinario
        FOREIGN KEY (CodMed)
        REFERENCES Veterinario(CodMed),

    CONSTRAINT FK_Consulta_Animal
        FOREIGN KEY (CodPac)
        REFERENCES Animal(CodPac)
);

-- EXERCICIOS

-- 1. Cadastrar 5 médicos (veterinários) para esta clínica

INSERT INTO Veterinario (CodMed, Nome, DataNasc)
VALUES
    (1, 'Carlos Almeida', '1985-03-15'),
    (2, 'Mariana Santos', '1990-07-22'),
    (3, 'Vinicius Zamara', '2003-05-10'),
    (4, 'Fernanda Oliveira', '1988-11-30'),
    (5, 'Ricardo Mendes', '1982-01-18');


-- 2. Cadastrar 10 pacientes (animais) para a clínica de pelo menos 3 espécies diferentes

INSERT INTO Animal (CodPac, NomeAnimal, Especie)
VALUES
    (1, 'Rex', 'Cachorro'),
    (2, 'Mel', 'Cachorro'),
    (3, 'Thor', 'Cachorro'),
    (4, 'Luna', 'Gato'),
    (5, 'Mia', 'Gato'),
    (6, 'Nina', 'Gato'),
    (7, 'Paco', 'Papagaio'),
    (8, 'Loro', 'Papagaio'),
    (9, 'Bidu', 'Coelho'),
    (10, 'Floquinho', 'Coelho');


-- 3. Cadastrar 20 consultas para estes médicos e pacientes com datas e valores diferentes

INSERT INTO Consulta (CodCons, DataCons, Valor, CodMed, CodPac)
VALUES
    (1,  '2026-01-05', 120.00, 1, 1),
    (2,  '2026-01-12', 150.00, 2, 2),
    (3,  '2026-01-20', 100.00, 3, 3),
    (4,  '2026-02-03', 180.00, 4, 4),
    (5,  '2026-02-15', 130.00, 5, 5),
    (6,  '2026-03-02', 200.00, 3, 6),
    (7,  '2026-03-10', 110.00, 1, 7),
    (8,  '2026-03-25', 175.00, 2, 8),
    (9,  '2026-04-07', 140.00, 3, 9),
    (10, '2026-04-18', 220.00, 4, 10),
    (11, '2026-05-04', 160.00, 5, 1),
    (12, '2026-05-17', 190.00, 3, 2),
    (13, '2026-06-01', 125.00, 1, 3),
    (14, '2026-06-15', 210.00, 2, 4),
    (15, '2026-06-28', 145.00, 3, 5),
    (16, '2026-07-03', 230.00, 4, 6),
    (17, '2026-07-10', 155.00, 3, 7),
    (18, '2026-07-17', 195.00, 5, 8),
    (19, '2026-07-24', 170.00, 3, 9),
    (20, '2026-07-31', 250.00, 1, 10);

-- 1. Selecione o maior valor pago por uma consulta

SELECT MAX(Valor) AS MaiorValor
FROM Consulta;


-- 2. Selecione o valor médio, maior valor e menor valor das consultas realizadas no mês passado

SELECT
    AVG(Valor) AS ValorMedio,
    MAX(Valor) AS MaiorValor,
    MIN(Valor) AS MenorValor
FROM Consulta
WHERE DataCons >= DATEFROMPARTS(
                    YEAR(DATEADD(MONTH, -1, GETDATE())),
                    MONTH(DATEADD(MONTH, -1, GETDATE())),
                    1
                  )
  AND DataCons < DATEFROMPARTS(
                    YEAR(GETDATE()),
                    MONTH(GETDATE()),
                    1
                  );


-- 3. Cadastre uma nova consulta para um paciente
--    que já está cadastrado

INSERT INTO Consulta (CodCons, DataCons, Valor, CodMed, CodPac)
VALUES
    (21, '2026-08-14', 185.00, 3, 1);


-- 4. Atualize o nome do médico cujo código é 3 para o seu nome

UPDATE Veterinario
SET Nome = 'Vinicius'
WHERE CodMed = 3;


-- 5. Selecione as espécies de pacientes que estão cadastrados

SELECT Especie
FROM Animal;


-- 6. Quantas consultas você já realizou nesta clínica?

SELECT COUNT(*) AS QuantidadeConsultas
FROM Consulta
WHERE CodMed = 3;


-- 7. Quantas consultas foram feitas por todos os médicos?

SELECT COUNT(*) AS TotalConsultas
FROM Consulta;


-- 8. Selecione, de forma exclusiva, as espécies de pacientes que estão cadastrados

SELECT DISTINCT Especie
FROM Animal;


-- 9. Liste os nomes dos pacientes em ordem alfabética

SELECT NomeAnimal
FROM Animal
ORDER BY NomeAnimal ASC;


-- 10. Qual o valor total de todas as consultas feitas por você?

SELECT SUM(Valor) AS ValorTotal
FROM Consulta
WHERE CodMed = 3;


-- 11. Qual a quantidade de médicos que esta clínica possui?

SELECT COUNT(*) AS QuantidadeMedicos
FROM Veterinario;


-- 12. Quanto seria o total das consultas que você realizou se estas consultas tivessem um aumento de 10%?

SELECT SUM(Valor) * 1.10 AS TotalComAumento
FROM Consulta
WHERE CodMed = 3;


-- 13. Quantas consultas foram feitas por você entre os dias 01/01/2026 e 31/03/2026?

SELECT COUNT(*) AS QuantidadeConsultas
FROM Consulta
WHERE CodMed = 3
  AND DataCons BETWEEN '2026-01-01' AND '2026-03-31';
