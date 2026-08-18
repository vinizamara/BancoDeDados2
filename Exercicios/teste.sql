-- Criação do banco de dados

CREATE DATABASE exercicios01;

GO

-- Seleciona o banco de dados

USE exercicios01;

GO

-- Criação da tabela Veterinario

CREATE TABLE Veterinario (
    CodMed INT PRIMARY KEY IDENTITY(1,1),
    Nome VARCHAR(100) NOT NULL,
    DataNasc DATE NOT NULL
);

GO

-- Criação da tabela Animal

CREATE TABLE Animal (
    CodPac INT PRIMARY KEY IDENTITY(1,1),
    NomeAnimal VARCHAR(100) NOT NULL,
    Especie VARCHAR(50) NOT NULL
);

GO

-- Criação da tabela Consulta

CREATE TABLE Consulta (
    CodCons INT PRIMARY KEY IDENTITY(1,1),
    DataCons DATE NOT NULL,
    Valor DECIMAL(10,2) NOT NULL,
    CodMed INT NOT NULL FOREIGN KEY REFERENCES Veterinario(CodMed),
    CodPac INT NOT NULL FOREIGN KEY REFERENCES Animal(CodPac)
);

GO


-- EXERCÍCIOS

-- 1. Cadastrar 5 médicos (veterinários) para esta clínica

INSERT INTO Veterinario (Nome, DataNasc)
VALUES
('Carlos Almeida', '1985-03-15'),
('Mariana Santos', '1990-07-22'),
('Vinicius Zamara', '2003-05-10'),
('Fernanda Oliveira', '1988-11-30'),
('Ricardo Mendes', '1982-01-18');


-- 2. Cadastrar 10 pacientes (animais) para a clínica
-- de pelo menos 3 espécies diferentes

INSERT INTO Animal (NomeAnimal, Especie)
VALUES
('Rex', 'Cachorro'),
('Mel', 'Cachorro'),
('Thor', 'Cachorro'),
('Luna', 'Gato'),
('Mia', 'Gato'),
('Nina', 'Gato'),
('Paco', 'Papagaio'),
('Loro', 'Papagaio'),
('Bidu', 'Coelho'),
('Floquinho', 'Coelho');


-- 3. Cadastrar 20 consultas para estes médicos e pacientes
-- com datas e valores diferentes

INSERT INTO Consulta (DataCons, Valor, CodMed, CodPac)
VALUES
('2026-01-05', 120.00, 1, 1),
('2026-01-12', 150.00, 2, 2),
('2026-01-20', 100.00, 3, 3),
('2026-02-03', 180.00, 4, 4),
('2026-02-15', 130.00, 5, 5),
('2026-03-02', 200.00, 3, 6),
('2026-03-10', 110.00, 1, 7),
('2026-03-25', 175.00, 2, 8),
('2026-04-07', 140.00, 3, 9),
('2026-04-18', 220.00, 4, 10),
('2026-05-04', 160.00, 5, 1),
('2026-05-17', 190.00, 3, 2),
('2026-06-01', 125.00, 1, 3),
('2026-06-15', 210.00, 2, 4),
('2026-06-28', 145.00, 3, 5),
('2026-07-03', 230.00, 4, 6),
('2026-07-10', 155.00, 3, 7),
('2026-07-17', 195.00, 5, 8),
('2026-07-24', 170.00, 3, 9),
('2026-07-31', 250.00, 1, 10);

-- 1. Selecione o maior valor pago por uma consulta

SELECT MAX(Valor) as maiorValor FROM Consulta;


-- 2. Selecione o valor médio, maior valor e menor valor das consultas realizadas no mês passado




-- 3. Cadastre uma nova consulta para um paciente
--    que já está cadastrado




-- 4. Atualize o nome do médico cujo código é 3 para o seu nome


-- 5. Selecione as espécies de pacientes que estão cadastrados




-- 6. Quantas consultas você já realizou nesta clínica?




-- 7. Quantas consultas foram feitas por todos os médicos?




-- 8. Selecione, de forma exclusiva, as espécies de pacientes que estão cadastrados




-- 9. Liste os nomes dos pacientes em ordem alfabética




-- 10. Qual o valor total de todas as consultas feitas por você?




-- 11. Qual a quantidade de médicos que esta clínica possui?




-- 12. Quanto seria o total das consultas que você realizou se estas consultas tivessem um aumento de 10%?




-- 13. Quantas consultas foram feitas por você entre os dias 01/01/2026 e 31/03/2026?

