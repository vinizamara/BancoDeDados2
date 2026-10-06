create database exerc04
go
use exerc04

create table Func (
         CodFunc int constraint pk_func primary key, 
         PrimeiroNome varchar(50), 
         SegundoNome varchar(50), 
         UltimoNome varchar(50), 
         DataNasci datetime, 
         CPF   varchar(20), 
         RG varchar(20), 
         Endereco varchar(50), 
         CEP varchar(15), 
         Cidade varchar(50), 
         Fone varchar(20), 
         CodDepto int, 
         Funcao varchar(50), 
         Salario money
)

create table Depto (
          CodDepto int constraint pk_deto primary key, 
          Nome varchar(50), 
          Localizacao varchar(50), 
          CodigoFuncionarioGerente int
)

alter table Func
add constraint fk_depto_func foreign key (CodDepto) references Depto(CodDepto)

alter table Depto
add constraint fk_func_gerente foreign key (CodigoFuncionarioGerente) 
      references Func(CodFunc)


INSERT INTO DEPTO 
values
      (1,         'RH',            'SUL',      NULL),
      (2,         'COMPRAS',         'SUL',      NULL),
      (3,         'VENDAS',         NULL,      NULL),
      (4,         'FINANCEIRO',      'NORTE',   NULL),
      (5,         'MARKETING',      'NORTE',   NULL),
      (6,         'DESENVOLVIMENTO',   NULL,      NULL),
      (7,         'CONTABILIDADE',   NULL,      NULL)


INSERT INTO Func (CodFunc, PrimeiroNome, SegundoNome, 
               UltimoNome, DataNasci, Cidade, 
               Funcao, Salario)
values (1, 'JOSE', 'MANOEL', 'DA SILVA', 
            '1980/01/01','FRANCA',
            'CONTADOR', 1200.00)

update func set salario = 1700
where codFunc = 5

-- INSERTS ADICIONAIS:

-- 1. Inserção de novos funcionários na tabela Func
INSERT INTO Func (CodFunc, PrimeiroNome, SegundoNome, UltimoNome, DataNasci, CPF, RG, Endereco, CEP, Cidade, Fone, CodDepto, Funcao, Salario)
VALUES 
    (2, 'MARIA', 'FERNANDA', 'SANTOS', '1992-05-15', '111.222.333-44', '12.345.678-9', 'RUA A, 100', '14400-000', 'FRANCA', '(16) 99999-1111', 1, 'GERENTE DE RH', 5500.00),
    (3, 'CARLOS', 'EDUARDO', 'OLIVEIRA', '1988-10-20', '222.333.444-55', '23.456.789-0', 'AV B, 250', '14401-111', 'RIBEIRAO PRETO', '(16) 99999-2222', 2, 'COMPRADOR', 3800.00),
    (4, 'ANA', 'PAULA', 'SOUZA', '1995-03-12', '333.444.555-66', '34.567.890-1', 'RUA C, 45', '14402-222', 'FRANCA', '(16) 99999-3333', 3, 'VENDEDORA', 2900.00),
    (5, 'ROBERTO', 'ALVES', 'PEREIRA', '1985-07-08', '444.555.666-77', '45.678.901-2', 'AV D, 1200', '14403-333', 'BATATAIS', '(16) 99999-4444', 4, 'GERENTE FINANCEIRO', 6200.00),
    (6, 'JULIANA', 'CRISTINA', 'LIMA', '1990-12-01', '555.666.777-88', '56.789.012-3', 'RUA E, 88', '14404-444', 'FRANCA', '(16) 99999-5555', 5, 'ANALISTA DE MARKETING', 4100.00),
    (7, 'LUCAS', 'GABRIEL', 'RODRIGUES', '1998-09-18', '666.777.888-99', '67.890.123-4', 'RUA F, 500', '14405-555', 'FRANCA', '(16) 99999-6666', 6, 'DESENVOLVEDOR', 4800.00),
    (8, 'FERNANDO', 'RICARDO', 'ALMEIDA', '1987-03-22', '777.888.999-00', '78.901.234-5', 'RUA G, 300', '14406-666', 'FRANCA', '(16) 99999-7777', 3, 'SUPERVISOR', 5200.00),
    (9, 'CAMILA', 'BEATRIZ', 'CASTRO', '1991-08-14', '888.999.000-11', '89.012.345-6', 'AV H, 750', '14407-777', 'FRANCA', '(16) 99999-8888', 2, 'SUPERVISOR', 5100.00),
    (10, 'MARCOS', 'VINICIUS', 'ROCHA', '1989-11-05', '999.000.111-22', '90.123.456-7', 'RUA I, 120', '14408-888', 'FRANCA', '(16) 99999-9999', 4, 'SUPERVISOR', 5300.00);

-- 2. Atualização do departamento do funcionário inserido anteriormente (José)
UPDATE Func 
SET CodDepto = 7 
WHERE CodFunc = 1;

-- 3. Definição dos gerentes na tabela Depto (resolvendo o relacionamento circular)
UPDATE Depto SET CodigoFuncionarioGerente = 2 WHERE CodDepto = 1; -- RH (Maria)
UPDATE Depto SET CodigoFuncionarioGerente = 5 WHERE CodDepto = 4; -- Financeiro (Roberto)
UPDATE Depto SET CodigoFuncionarioGerente = 1 WHERE CodDepto = 7; -- Contabilidade (José)


-- EXERCICIOS:


-- 1. Listar todos os campos de funcionarios ordenados por cidade
SELECT * 
FROM Func
ORDER BY Cidade;

-- 2. Obter os nomes dos funcionários nascidos entre as datas 1950-01-01 e 1970-01-01
SELECT PrimeiroNome
FROM Func
WHERE DataNasci BETWEEN '1950-01-01' AND '1970-01-01';

-- 3. Liste os funcionários que têm salário superior a R$1000,00 ordenados pelo nome completo
SELECT PrimeiroNome
FROM Func
WHERE salario > 1000
ORDER BY PrimeiroNome, SegundoNome, UltimoNome

-- 4. Liste a data de nascimento e o primeiro nome dos funcionários ordenados mais novo para o mais velho.
SELECT
DataNasci, PrimeiroNome
FROM Func
ORDER BY DataNasci DESC;

-- 5. Liste o total da folha de pagamento
SELECT SUM(Salario) AS TotalFolhaPagamento
FROM Func;

-- 6. Liste o nome, o nome do departamento, e a função de todos os funcionários
SELECT f.PrimeiroNome, d.Nome as Depto, f.funcao
FROM func f 
INNER JOIN depto d ON f.codDepto = d.codDepto;

-- 7. Liste todos os departamentos com seus respectivos gerentes.
SELECT d.nome, f.PrimeiroNome, f.SegundoNome, f.UltimoNome
FROM Depto d
INNER JOIN Func f
ON f.CodFunc = d.CodigoFuncionarioGerente;

-- 8. Liste o valor da folha de pagamento de cada departamento (nome).
SELECT Depto.nome as NomeDepartamento, SUM(Salario) AS TotalFolhaPagamentoDepartamento
FROM Func
INNER JOIN Depto
ON Depto.CodDepto = Func.CodDepto
GROUP BY Depto.nome;

-- 9. Liste os departamentos dos funcionários que têm a função de supervisor.
SELECT Depto.nome AS nomeDepartamento, Func.primeiroNome, Func.Funcao
FROM Depto
INNER JOIN Func
ON Depto.CodDepto = Func.CodDepto
WHERE Func.Funcao = 'SUPERVISOR';

-- Com subselect:

SELECT nome
FROM Depto
WHERE CodDepto IN
(
SELECT CodDepto
FROM Func
WHERE Func.Funcao = 'SUPERVISOR'
);

-- 10. Liste a quantidade de funcionários desta empresa.
SELECT count(*) AS QtdeFunc
FROM Func;

-- 11. Liste o salário médio pago pela empresa.
SELECT AVG(salario) AS salarioMedio
FROM Func;

-- 12. Liste a quantidade de funcionários que trabalham em cada departamento.
SELECT COUNT(*) AS quantidadeFuncionarios, Depto.nome
FROM Func
INNER JOIN Depto
ON Depto.CodDepto = Func.CodDepto
GROUP BY Depto.nome;

-- 13. Liste o menor salário pago pela empresa em cada departamento.
SELECT MIN(salario) AS menorSalario, Depto.nome
FROM Func
INNER JOIN Depto
ON Depto.CodDepto = Func.CodDepto
GROUP BY Depto.nome;

-- 14. Liste o nome completo de todos os funcionários que não tenham segundo nome.
SELECT f.PrimeiroNome + ' ' + f.UltimoNome
FROM Func f
WHERE f.SegundoNome IS NULL;

-- usando ISNULL:

SELECT f.PrimeiroNome + f.UltimoNome
FROM Func f
WHERE ISNULL(SegundoNome, ' ') = ' ';

-- 14 b). Consulta que liste nome de funcionário e nome de seu gerente
SELECT 
f.PrimeiroNome + ' ' + ISNULL(f.UltimoNome, '') AS NomeFuncionario,
g.PrimeiroNome + ' ' + ISNULL(g.UltimoNome, '') AS NomeGerente
FROM Func f
INNER JOIN Depto d
ON f.CodDepto = d.CodDepto
INNER JOIN Func g
ON d.CodigoFuncionarioGerente = g.CodFunc;

-- 15. Liste os departamentos que possuem mais de 3 funcionários
SELECT Depto.nome AS departamentoMaisDe3Funcionarios, COUNT(Func.CodFunc) AS QuantidadeFunc
FROM Depto
INNER JOIN Func
ON Func.CodDepto = Depto.CodDepto
WHERE QuantidadeFunc > 3;

-- 16. Liste o nome do departamento e funcionário ordenados por departamento e funcionário

-- 17. Liste os nomes dos funcionários que moram em Recife e que exerçam a função de Telefonista

-- 18. Liste a localização do departamento e os nomes dos funcionários que trabalham no Departamento Pessoal
