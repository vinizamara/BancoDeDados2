-- transações

CREATE TABLE teste (
    id int PRIMARY KEY,
    campoA VARCHAR(50) NOT NULL,
    campoB VARCHAR(50) NULL
)

INSERT INTO teste
VALUES
(1, 'Teste 1', 'Outro teste'),
(2, 'Teste 2', 'Outro teste')

SELECT * FROM teste

BEGIN TRANSACTION testeTran
    begin try
        INSERT INTO teste
        VALUES
            (10, 'Teste 1', 'Outro teste'),
            (20, 'Teste 2', 'Outro teste'),
            (30, null, 'Outro teste')
        COMMIT TRANSACTION testeTran
    END TRY
    BEGIN CATCH
        SELECT ERROR_NUMBER() AS NumeroErro,
               ERROR_LINE() AS LinhaComErro,
               ERROR_MESSAGE() AS MensagemErro
        ROLLBACK TRANSACTION testeTran
    END CATCH 
