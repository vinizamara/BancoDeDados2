/* 
==============================================================================
1. Criar uma tabela com o nome TB_CLIENTE. A tabela deverá conter a seguinte estrutura:
   a. Um atributo código do tipo inteiro;
   b. Um atributo nome do tipo cadeia de caracteres de tamanho 50;
   c. Um atributo telefone do tipo cadeia de caracteres de tamanho 20;
   d. Um atributo tipo_cliente do tipo cadeia de caracteres de tamanho 20;
   e. Um atributo dt_cadastro do tipo data e hora;
   f. Um atributo nr_dependentes do tipo inteiro;
   g. Todos os atributos da tabela devem ser obrigatórios.
 
 2. A tabela acima deve conter as seguintes restrições:
   a. O atributo código representa a chave primária da tabela;
   b. O atributo dt_cadastro (data do cadastro) deve ter como valor padrão (default) a data e hora atual do sistema;
   c. O atributo tipo_cliente deve ser “Titular” ou “Dependente”;
   d. O atributo nr_dependentes deve ser um inteiro maior ou igual a 0 e menor ou igual a 3.
==============================================================================
*/

CREATE DATABASE exercicio03_atividade01 ;
GO

USE exercicio03_atividade01;
GO

CREATE TABLE TB_CLIENTE ( 
    cod INT CONSTRAINT PK_TB_CLIENTE PRIMARY KEY,
    nome VARCHAR(50) NOT NULL, 
    telefone VARCHAR(20) NOT NULL, 
    tipo_cliente VARCHAR(20) NOT NULL 
        CONSTRAINT checkTipo CHECK (tipo_cliente IN ('Titular', 'Dependente')),
    dt_cadastro DATETIME DEFAULT GETDATE() NOT NULL,
    nr_dependentes INT NOT NULL 
        CONSTRAINT checkNrDependentes CHECK (nr_dependentes >= 0 AND nr_dependentes <= 3)
);

-- Inserção válida passando todos os campos
INSERT INTO TB_CLIENTE (cod, nome, telefone, tipo_cliente, dt_cadastro, nr_dependentes)
VALUES (1, 'João Silva', '11999998888', 'Titular', GETDATE(), 2);

-- Inserção válida omitindo a data para testar o valor padrão (DEFAULT)
INSERT INTO TB_CLIENTE (cod, nome, telefone, tipo_cliente, nr_dependentes)
VALUES (2, 'Maria Souza', '11888887777', 'Dependente', 0);

-- Inserção com violação da restrição de valor nulo (NOT NULL no nome)
INSERT INTO TB_CLIENTE (cod, nome, telefone, tipo_cliente, nr_dependentes)
VALUES (3, NULL, '11777776666', 'Titular', 1);

-- Inserção com violação da chave primária duplicada (PRIMARY KEY cod)
INSERT INTO TB_CLIENTE (cod, nome, telefone, tipo_cliente, nr_dependentes)
VALUES (1, 'Carlos Lima', '11666665555', 'Titular', 0);

-- Atualização com violação da chave primária duplicada (PRIMARY KEY cod)
UPDATE TB_CLIENTE 
SET cod = 1 
WHERE cod = 2;

-- Inserção com violação da restrição do tipo de cliente (CHECK tipo_cliente)
INSERT INTO TB_CLIENTE (cod, nome, telefone, tipo_cliente, nr_dependentes)
VALUES (4, 'Ana Clara', '11555554444', 'Sócio', 1);

-- Inserção com violação da restrição do número de dependentes abaixo de zero (CHECK nr_dependentes)
INSERT INTO TB_CLIENTE (cod, nome, telefone, tipo_cliente, nr_dependentes)
VALUES (5, 'Pedro Alves', '11444443333', 'Titular', -1);

-- Atualização com violação da restrição do número de dependentes acima de três (CHECK nr_dependentes)
UPDATE TB_CLIENTE 
SET nr_dependentes = 5 
WHERE cod = 1;

