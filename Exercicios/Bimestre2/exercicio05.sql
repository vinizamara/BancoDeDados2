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

-- Ciração das variaveis para teste na transação
DECLARE @idVendaTarget INT = 1;
DECLARE @valorFinanceiro MONEY = 150.00;
DECLARE @vencimento DATE = DATEADD(DAY, 30, GETDATE());

BEGIN TRY
    BEGIN TRANSACTION TRN_RealizarRegistroFinanceiro;

    -- 1. Atualiza a situação da venda para 'REGISTRADO'
    UPDATE Venda
    SET situacao = 'REGISTRADO'
    WHERE idVenda = @idVendaTarget 
      AND situacao <> 'REGISTRADO';
    
    -- Se nenhuma linha foi alterada, força desvio imediato para o CATCH
    IF @@ROWCOUNT = 0
    BEGIN
        THROW 50001, 'Venda inválida ou já registrada.', 1;
    END;

    -- 2. Insere o registro na tabela Financeiro
    INSERT INTO Financeiro (dataLancamento, valor, dataVencimento, idVenda)
    VALUES (GETDATE(), @valorFinanceiro, @vencimento, @idVendaTarget);

    COMMIT TRANSACTION TRN_RealizarRegistroFinanceiro;
    PRINT 'Situação da venda alterada para REGISTRADO e título financeiro gerado com sucesso.';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
    BEGIN
        ROLLBACK TRANSACTION TRN_RealizarRegistroFinanceiro;
    END;

    SELECT 
        ERROR_NUMBER() AS NumeroErro,
        ERROR_LINE() AS LinhaComErro,
        ERROR_MESSAGE() AS MensagemErro;
END CATCH;
GO

-- 6 b.	Após a inserção de cada item da venda, os estoques dos produtos deverão ser atualizados.
-- Declaração das variáveis para teste da transação
DECLARE @idVenda INT = 1;
DECLARE @idProduto INT = 1;
DECLARE @quantidade INT = 2;
DECLARE @valorUnitario MONEY = 50.00;

BEGIN TRY
    BEGIN TRANSACTION TRN_AtualizarEstoqueProdutos;

    -- 1. Insere o item da venda
    INSERT INTO ItemVenda (idVenda, idProduto, quantidade, valorUnitario)
    VALUES (@idVenda, @idProduto, @quantidade, @valorUnitario);

    -- 2. Dedução do estoque correspondente
    UPDATE Produto
    SET estoque = estoque - @quantidade
    WHERE idProduto = @idProduto;

    -- 3. Valida se o produto existia e foi alterado
    IF @@ROWCOUNT = 0
    BEGIN
        THROW 50001, 'Produto informado não encontrado para baixa em estoque.', 1;
    END;

    COMMIT TRANSACTION TRN_AtualizarEstoqueProdutos;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
    BEGIN
        ROLLBACK TRANSACTION TRN_AtualizarEstoqueProdutos;
    END;

    SELECT
        ERROR_NUMBER() AS NumeroErro,
        ERROR_LINE() AS LinhaComErro,
        ERROR_MESSAGE() AS MensagemErro;
END CATCH;
GO

-- 6 c.	Quando uma venda for inserida, sua comissão pode ser inserida.
DECLARE @idCliente INT = 1;
DECLARE @idVendedor INT = 1;
DECLARE @valorFrete MONEY = 15.00;
DECLARE @valorComissao MONEY = 50.00;
DECLARE @idVendaGerado INT;

BEGIN TRY
    BEGIN TRANSACTION TRN_InserirVendaEComissao;

    -- 1. Insere o registro da venda
    INSERT INTO Venda (dataVenda, valorFrete, idCliente, idVendedor)
    VALUES (GETDATE(), @valorFrete, @idCliente, @idVendedor);

    -- 2. Captura a chave primária gerada pela sessão atual
    SET @idVendaGerado = SCOPE_IDENTITY();

    -- 3. Insere a comissão vinculada à venda recém-gerada
    INSERT INTO Comissao (valor, idVenda, idVendedor)
    VALUES (@valorComissao, @idVendaGerado, @idVendedor);

    COMMIT TRANSACTION TRN_InserirVendaEComissao;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
    BEGIN
        ROLLBACK TRANSACTION TRN_InserirVendaEComissao;
    END;

    SELECT
        ERROR_NUMBER() AS NumeroErro,
        ERROR_LINE() AS LinhaComErro,
        ERROR_MESSAGE() AS MensagemErro;
END CATCH;
GO