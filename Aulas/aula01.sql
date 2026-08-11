CREATE DATABASE REVISAO2026;
GO

USE REVISAO2026;
GO

-- Tabela categoria

CREATE TABLE categoria (
    codCat INT PRIMARY KEY IDENTITY(1,1),
    nomeCat VARCHAR(50)
);

-- Tabela produto

CREATE TABLE produto (
    codPro INT PRIMARY KEY IDENTITY(1,1),
    descricao VARCHAR(100),
    codBarras VARCHAR(30),
    estoque INT,
    preco DECIMAL(10,2),
    codCat INT FOREIGN KEY REFERENCES categoria(codCat)
);

-- Populando a tabela categoria

INSERT INTO categoria (nomeCat)
VALUES
('Informática'),
('Eletrônicos'),
('Celulares'),
('Acessórios'),
('Periféricos');

-- Populando a tabela produto

INSERT INTO produto (descricao, codBarras, estoque, preco, codCat)
VALUES
('Notebook Lenovo', '789100000001', 15, 3500.00, 1),
('Notebook Dell', '789100000002', 8, 4200.00, 1),
('Monitor LG 24"', '789100000003', 20, 950.00, 2),
('Smart TV Samsung 50"', '789100000004', 10, 2800.00, 2),
('Celular Samsung Galaxy', '789100000005', 25, 1800.00, 3),
('iPhone 15', '789100000006', 12, 4500.00, 3),
('Teclado Mecânico', '789100000007', 30, 250.00, 4),
('Mouse Gamer', '789100000008', 40, 180.00, 4),
('Fone de Ouvido Bluetooth', '789100000009', 35, 220.00, 4),
('Mousepad Gamer', '789100000010', 50, 90.00, 5),
('Teclado USB', '789100000011', 18, 120.00, 5),
('Webcam Full HD', '789100000012', 22, 300.00, 5);

-- Funções de agregação

-- MAX = retorna o maior estoque

SELECT MAX(estoque) AS maiorEstoque
FROM produto;

-- MIN = retorna o menor estoque

SELECT MIN(estoque) AS menorEstoque
FROM produto;

-- SUM = retorna a soma

SELECT SUM(preco) AS precoTotal
FROM produto;

-- CAMPO CALCULADO
SELECT descricao, estoque, preco, estoque * preco AS valorEstoque
FROM produto;

-- SUM
SELECT SUM(estoque * preco) AS valorTotalEstoque
FROM produto;

-- AVG = calcula a média
SELECT AVG(preco) AS PrecoMedio
FROM produto;

-- ROUND = função para arredondamentos
SELECT ROUND(12345.25, 1); -- A instrução SELECT ROUND(12345.25, 1) arredonda o número 12345.25 para possuir apenas 1 casa decimal, resultando em 12345.3 

SELECT ROUND(AVG(preco), 2) AS precoMedio 
FROM produto;
             
-- COUNT = conta o número de ocorrências
SELECT COUNT(descricao)
FROM produto;

SELECT COUNT(*) AS contagem
FROM produto;

-- SUBTRAÇÃO NO SELECT:
SELECT COUNT(*) - COUNT(codCat) AS totalSemCategoria
FROM produto

-- Multiplicação para criar um campo calculado:
-- Qual seria o novo preço dos produtos se aplicasse 10% de acréscimo?
SELECT descricao, preco, preco * 1.10 AS precoReajustado
FROM produto;

-- Outras funções importantes:
-- DISTINCT: selecionar linhas exclusivas
SELECT DISTINCT codCat AS categoriaProdutos
FROM produto;