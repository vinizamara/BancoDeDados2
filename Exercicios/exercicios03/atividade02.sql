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

CREATE DATABASE exercicio03 ;
GO

USE exercicio03;
GO

CREATE TABLE Marca(
  id_marca INT PRIMARY KEY,
  nome VARCHAR(100) UNIQUE
);

CREATE TABLE Produto( 
  id_pro INT PRIMARY KEY CONSTRAINT id_4digitos CHECK(id_pro >= 1 and id_pro <= 9999),
  nome_produto VARCHAR(100) NOT NULL, 
  id_marca INT FOREIGN KEY REFERENCES Marca(id_marca), 
  estoque INT CONSTRAINT quantidade_estoque CHECK(estoque >= 0), 
  preco MONEY
);

CREATE TABLE Pedido( 
  id_pedido INT PRIMARY KEY,
  data DATE,
  valor_desc MONEY,
  valor_total MONEY
);

CREATE TABLE ItemPedido(
  id_pedido INT FOREIGN KEY REFERENCES Pedido(id_pedido),
  id_pro INT FOREIGN KEY REFERENCES Produto(id_pro),
  qtde INT, 
  vl_unit MONEY
);
