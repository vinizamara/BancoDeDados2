/*
==============================================================================
Exercício 02:
 
Dado o seguinte esquema relacional:
 
Marca (id_marca, nome) 
Produto (id_pro, nome_produto, id_marca, estoque, preço) 
Pedido(id_pedido, data, valor_desc, valor_total)
ItemPedido (id_pedido, id_pro, qtde, vl_unit)
 
em que:
 
id_marca – identificador único da marca
nome – nome completo da marca, também único 
id_pro- inteiro identificador de produto
nome_produto – não necessariamente único, descreve o produto, p.ex. “borracha” 
estoque – inteiro que define a quantidade em estoque (sempre positivo)
preço – preço de venda do produto
id_pedido – inteiro identificador do pedido
data – data do pedido
 
Defina em SQL as seguintes restrições de integridade:
 
1. O nome_produto é de preenchimento obrigatório. 
2. Todos os valores da marca na relação Produto existem na relação Marca em id_marca. 
3. O id_pro é um inteiro com 4 dígitos. 
4. A data do pedido é por padrão a data atual. 
5. No mesmo pedido, não pode haver mais de uma venda do mesmo produto.
6. Se o preço de um item vendido é superior a 1000 então a quantidade vendida tem de ser menor que 100. 
7. O valor total do Estoque de cada Produto não pode exceder os 250.000 (considerando o preço de venda).
==============================================================================
*/

CREATE DATABASE exercicio03_atividade02;
GO

USE exercicio03_atividade02;
GO

CREATE TABLE Marca (
  id_marca INT,
  nome VARCHAR(100),

  CONSTRAINT PK_Marca PRIMARY KEY (id_marca),
  CONSTRAINT UQ_Marca_Nome UNIQUE (nome)
);

CREATE TABLE Produto ( 
  id_pro INT,
  nome_produto VARCHAR(100) NOT NULL, 
  id_marca INT NOT NULL, 
  estoque INT, 
  preco MONEY,

  CONSTRAINT PK_Produto PRIMARY KEY (id_pro),
  CONSTRAINT CK_Produto_Estoque CHECK (estoque >= 0),
  CONSTRAINT FK_Produto_Marca FOREIGN KEY (id_marca) REFERENCES Marca(id_marca),
  CONSTRAINT CK_Produto_idProduto4digitos CHECK (id_pro >= 1000 AND id_pro <= 9999),
  CONSTRAINT CK_Produto_preco_estoque_valorTotalmaior250 CHECK (preco * estoque <= 250000)
);

CREATE TABLE Pedido ( 
  id_pedido INT,
  data DATE CONSTRAINT DF_Pedido_Data DEFAULT (GETDATE()),
  valor_desc MONEY,
  valor_total MONEY,

  CONSTRAINT PK_Pedido PRIMARY KEY (id_pedido)
);

CREATE TABLE ItemPedido (
  id_pedido INT NOT NULL,
  id_pro INT NOT NULL,
  qtde INT, 
  vl_unit MONEY,

  CONSTRAINT PK_ItemPedido PRIMARY KEY (id_pedido, id_pro),
  CONSTRAINT FK_ItemPedido_Pedido FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
  CONSTRAINT FK_ItemPedido_Produto FOREIGN KEY (id_pro) REFERENCES Produto(id_pro),
  CONSTRAINT CK_ItemPedido_vlUnitMaior1000_AND_qtdeMenor100 CHECK (
    vl_unit <= 1000 
    OR
    (vl_unit > 1000 AND qtde < 100)
  )
);