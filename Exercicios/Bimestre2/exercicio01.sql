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
USE exerc04
GO

-- 1. Inserção de novos funcionários na tabela Func
INSERT INTO Func (CodFunc, PrimeiroNome, SegundoNome, UltimoNome, DataNasci, CPF, RG, Endereco, CEP, Cidade, Fone, CodDepto, Funcao, Salario)
VALUES 
    (2, 'MARIA', 'FERNANDA', 'SANTOS', '1992-05-15', '111.222.333-44', '12.345.678-9', 'RUA A, 100', '14400-000', 'FRANCA', '(16) 99999-1111', 1, 'GERENTE DE RH', 5500.00),
    (3, 'CARLOS', 'EDUARDO', 'OLIVEIRA', '1988-10-20', '222.333.444-55', '23.456.789-0', 'AV B, 250', '14401-111', 'RIBEIRAO PRETO', '(16) 99999-2222', 2, 'COMPRADOR', 3800.00),
    (4, 'ANA', 'PAULA', 'SOUZA', '1995-03-12', '333.444.555-66', '34.567.890-1', 'RUA C, 45', '14402-222', 'FRANCA', '(16) 99999-3333', 3, 'VENDEDORA', 2900.00),
    (5, 'ROBERTO', 'ALVES', 'PEREIRA', '1985-07-08', '444.555.666-77', '45.678.901-2', 'AV D, 1200', '14403-333', 'BATATAIS', '(16) 99999-4444', 4, 'GERENTE FINANCEIRO', 6200.00),
    (6, 'JULIANA', 'CRISTINA', 'LIMA', '1990-12-01', '555.666.777-88', '56.789.012-3', 'RUA E, 88', '14404-444', 'FRANCA', '(16) 99999-5555', 5, 'ANALISTA DE MARKETING', 4100.00),
    (7, 'LUCAS', 'GABRIEL', 'RODRIGUES', '1998-09-18', '666.777.888-99', '67.890.123-4', 'RUA F, 500', '14405-555', 'FRANCA', '(16) 99999-6666', 6, 'DESENVOLVEDOR', 4800.00);

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
 
