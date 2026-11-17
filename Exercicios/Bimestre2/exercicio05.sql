CREATE DATABASE BdVendas;
GO

USE BdVendas;
GO

-- 1. Tabela CLIENTE
CREATE TABLE Cliente (
    idCliente INT IDENTITY(1, 1),
    nome VARCHAR(250) NOT NULL, -- a)
    fone VARCHAR(20),
    limiteCredito MONEY,

    CONSTRAINT PK_Cliente PRIMARY KEY (idCliente)
);
GO

-- 2. Tabela ENDERECO
CREATE TABLE Endereco (
    idEndereco INT IDENTITY(1, 1),
    rua VARCHAR(250) NOT NULL,
    numero VARCHAR(20),
    bairro VARCHAR(100),
    cep CHAR(8),
    idCliente INT NOT NULL,

    CONSTRAINT PK_Endereco PRIMARY KEY (idEndereco),
    CONSTRAINT FK_Endereco_Cliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
);
GO

-- 3. Tabela VENDEDOR
CREATE TABLE Vendedor (
    idVendedor INT IDENTITY(1, 1),
    nome VARCHAR(250) NOT NULL,
    fone VARCHAR(20),
    funcao VARCHAR(100),
    salarioFixo MONEY,

    CONSTRAINT PK_Vendedor PRIMARY KEY (idVendedor),
    CONSTRAINT CK_Vendedor_Funcao CHECK (funcao IN ('Balcão', 'Externo', 'Aprendiz', 'Supervisor')) -- d)
);
GO

-- Função necessário para pegar o valor do slario do vendedor e passar para comissão
CREATE FUNCTION dbo.fn_ObterSalarioVendedor(@idVendedor INT)
RETURNS MONEY
AS
BEGIN
    DECLARE @salario MONEY;
    SELECT @salario = salarioFixo FROM Vendedor WHERE idVendedor = @idVendedor;
    RETURN ISNULL(@salario, 0);
END;
GO

-- 4. Tabela PRODUTO
CREATE TABLE Produto (
    idProduto INT IDENTITY(1, 1),
    nome VARCHAR(250) NOT NULL,
    unidade VARCHAR(20) NOT NULL,
    estoque INT,

    CONSTRAINT PK_Produto PRIMARY KEY (idProduto),
    CONSTRAINT CK_Produto_EstoquePC CHECK (unidade <> 'PC' OR estoque >= 0) -- e)
);
GO

-- 5. Tabela VENDA
CREATE TABLE Venda (
    idVenda INT IDENTITY(1, 1),
    dataVenda DATE DEFAULT GETDATE(), -- b)
    valorFrete MONEY,
    idCliente INT NOT NULL,
    idVendedor INT NOT NULL,

    CONSTRAINT PK_Venda PRIMARY KEY (idVenda),
    CONSTRAINT FK_Venda_Cliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente),
    CONSTRAINT FK_Venda_Vendedor FOREIGN KEY (idVendedor) REFERENCES Vendedor(idVendedor)
);
GO

-- 6. Tabela ITEM_VENDA
CREATE TABLE ItemVenda (
    idVenda INT NOT NULL,
    idProduto INT NOT NULL,
    quantidade INT NOT NULL,
    valorUnitario MONEY NOT NULL,

    CONSTRAINT PK_ItemVenda PRIMARY KEY (idVenda, idProduto),
    CONSTRAINT FK_ItemVenda_Venda FOREIGN KEY (idVenda) REFERENCES Venda(idVenda),
    CONSTRAINT FK_ItemVenda_Produto FOREIGN KEY (idProduto) REFERENCES Produto(idProduto)
);
GO

-- 7. Tabela FINANCEIRO
CREATE TABLE Financeiro (
    idFinanceiro INT IDENTITY(1, 1),
    dataLancamento DATE,
    valor MONEY NOT NULL,
    dataVencimento DATE NOT NULL,
    dataLiquidacao DATE,
    idVenda INT NOT NULL,

    CONSTRAINT PK_Financeiro PRIMARY KEY (idFinanceiro),
    CONSTRAINT FK_Financeiro_Venda FOREIGN KEY (idVenda) REFERENCES Venda(idVenda),
    CONSTRAINT CK_Financeiro_Vencimento CHECK (dataVencimento >= dataLancamento) -- g)
);
GO

-- 8. Tabela COMISSAO
CREATE TABLE Comissao (
    idComissao INT IDENTITY(1, 1),
    valor MONEY NOT NULL,
    idVenda INT NOT NULL,
    idVendedor INT NOT NULL,

    CONSTRAINT PK_Comissao PRIMARY KEY (idComissao),
    CONSTRAINT FK_Comissao_Venda FOREIGN KEY (idVenda) REFERENCES Venda(idVenda),
    CONSTRAINT FK_Comissao_Vendedor FOREIGN KEY (idVendedor) REFERENCES Vendedor(idVendedor),
    CONSTRAINT CK_Comissao_ValorPositivo CHECK (valor > 0), -- c)
    CONSTRAINT CK_Comissao_LimiteSalario CHECK (dbo.fn_ObterSalarioVendedor(idVendedor) <= 2000 OR valor <= 1800) -- f)
);
GO

-- 6 a.	Os registros de financeiro só poderão ser inseridos no momento em que um registro de venda for atualizado para ‘REGISTRADO’ (um campo venda.situacao for atualizado para ‘REGISTRADO’, por exemplo).
ALTER TABLE Venda 
ADD situacao VARCHAR(20) NOT NULL DEFAULT 'PENDENTE';
GO

BEGIN TRANSACTION TRN_RealizarRegistroFinanceiro
    BEGIN TRY
        UPDATE Venda
        SET situacao = 'REGISTRADO'
        WHERE idVenda = 10

        INSERT INTO Financeiro (dataLancamento, valor, dataVencimento, idVenda)
        VALUES (GETDATE(), 250.00, GETDATE() + 30, 10)

        COMMIT TRANSACTION TRN_RealizarRegistroFinanceiro
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION TRN_RealizarRegistroFinanceiro
    END CATCH

-- 6 b.	Após a inserção de cada item da venda, os estoques dos produtos deverão ser atualizados.
BEGIN TRANSACTION TRN_AtualizarEstoqueProdutos
    BEGIN TRY
        INSERT INTO ItemVenda (idVenda, idProduto, quantidade, valorUnitario)
        VALUES (100, 25, 3, 4.98)

        UPDATE Produto
        SET estoque = estoque - 3
        WHERE idProduto = 25

        COMMIT TRANSACTION TRN_AtualizarEstoqueProdutos
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION TRN_AtualizarEstoqueProdutos
    END CATCH

-- 6 c.	Quando uma venda for inserida, sua comissão pode ser inserida.
BEGIN TRANSACTION TRN_InserirVendaEComissao
    BEGIN TRY
        DECLARE @idVendaGerado INT

        INSERT INTO Venda (dataVenda, valorFrete, idCliente, idVendedor)
        VALUES (GETDATE(), 15.00, 1, 1)

        SET @idVendaGerado = SCOPE_IDENTITY()

        INSERT INTO Comissao (valor, idVenda, idVendedor)
        VALUES (50.00, @idVendaGerado, 1)

        COMMIT TRANSACTION TRN_InserirVendaEComissao
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION TRN_InserirVendaEComissao
    END CATCH