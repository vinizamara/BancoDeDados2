/*
# LISTA DE EXERCÍCIOS — `BdLocadora`

## 1. Modelo Conceitual e Cardinalidades

Analise o cenário da locadora de veículos (`BdLocadora`) descrito abaixo, complete as cardinalidades de cada relacionamento de acordo com as regras de negócio, corrija eventuais inconsistências conceituais e aplique as regras de transformação para criar o modelo físico.

### Entidades e Atributos

* **Funcionario**: `CodFun`, `Nome`, `CPF`, `Cargo`, `Salario`, `DataAdmissao`, `CodSupervisor` (Auto-relacionamento com `Funcionario`)
* **Cliente**: `CodCli`, `Nome`, `CNH`, `CategoriaCNH`, `Cidade`, `Telefone`
* **Veiculo**: `CodVei`, `Placa`, `Modelo`, `Categoria`, `ValorDiaria`, `Quilometragem`, `Status`
* **Locacao**: `CodLoc`, `DataRetirada`, `DataPrevistaDevolucao`, `DataDevolucaoReal`, `ValorTotal`, `Situacao`
* *Relacionamento*: **Funcionario** — *registra* — **Locacao**
* *Relacionamento*: **Cliente** — *realiza* — **Locacao**
* *Relacionamento*: **Veiculo** — *alocado em* — **Locacao**


* **MultaOcorrencia**: `CodMul`, `Descricao`, `ValorMulta`, `DataRegistro`, `DataVencimento`
* *Relacionamento*: **Locacao** — *gera* — **MultaOcorrencia**


* **Oficina**: `CodOfi`, `RazaoSocial`, `CNPJ`, `Especialidade`
* **Manutencao** (Relacionamento N:N entre `Veiculo` e `Oficina`): `CodVei`, `CodOfi`, `DataServico`, `DescricaoServico`, `Custo`

---

## 2. Criação do Banco de Dados e Restrições de Integridade

Crie o banco de dados `BdLocadora` e implemente todas as tabelas com as seguintes restrições de integridade:

* **a)** Cada tabela principal deve possuir uma chave primária com numeração automática, exceto a tabela associativa `Manutencao`, que deve utilizar chave primária composta (`CodVei`, `CodOfi`, `DataServico`).
* **b)** Analise os relacionamentos e crie todas as chaves estrangeiras necessárias, incluindo o auto-relacionamento de supervisão na tabela `Funcionario`.
* **c)** Os campos `Nome` (em `Funcionario` e `Cliente`), `Placa` e `Modelo` (em `Veiculo`) são campos obrigatórios.
* **d)** Não poderão existir dois funcionários cadastrados com o mesmo `CPF`, dois clientes com a mesma `CNH`, dois veículos com a mesma `Placa` nem duas oficinas com o mesmo `CNPJ`.
* **e)** O `Cargo` do funcionário deverá aceitar apenas os valores: `'Atendente'`, `'Gerente'`, `'Mecanico'` ou `'Supervisor'`.
* **f)** O `Salario` de um funcionário não poderá ser inferior a R$ 2.100,00.
* **g)** A `CategoriaCNH` do cliente deverá aceitar apenas os valores: `'B'`, `'C'`, `'D'` ou `'E'`.
* **h)** O `Status` do veículo deverá aceitar apenas `'Disponivel'`, `'Alugado'` ou `'Manutencao'`, assumindo `'Disponivel'` como valor padrão.
* **i)** A `DataRetirada` da locação deve ter como valor padrão a data atual do sistema, e a `DataPrevistaDevolucao` deverá ser obrigatoriamente maior ou igual à `DataRetirada`.
* **j)** Na tabela `MultaOcorrencia`, o `ValorMulta` deve ser maior que zero e a coluna `DataVencimento` deve ser gerada automaticamente para 15 dias após a `DataRegistro`.

---

## 3. Carga de Dados

Insira registros válidos em todas as tabelas para viabilizar os testes das consultas e transações:

* **a)** 5 funcionários (incluindo pelo menos 1 supervisor/gerente vinculado aos demais via `CodSupervisor`).
* **b)** 6 clientes (de cidades distintas como `'Franca'`, `'Ribeirão Preto'` e `'Campinas'`, deixando ao menos 1 cliente sem telefone cadastrado).
* **c)** 6 veículos (variando categorias, diárias e status, deixando ao menos 1 veículo que nunca foi alugado).
* **d)** 8 locações (contendo locações `'Finalizada'`, `'Aberta'` e `'Cancelada'`).
* **e)** 4 multas/ocorrências vinculadas a locações distintas.
* **f)** 3 oficinas e 5 registros de manutenção.

---

## 4. Consultas

Desenvolva consultas SQL para atender aos seguintes requisitos:

* **a)** Liste o nome do cliente em letras maiúsculas, os 4 primeiros caracteres da CNH, a cidade e o telefone. Caso o telefone não esteja preenchido, exiba `'SEM TELEFONE'`. Filtre apenas os clientes cujo nome termine com `'Silva'` ou contenha `'os'` e que residam em `'Franca'`.
* **b)** Liste o código da locação, a data de retirada, o nome do cliente, o modelo e a placa do veículo, o nome do funcionário que registrou a locação e o nome do seu respectivo supervisor (exibindo `'SEM SUPERVISOR'` caso não possua).
* **c)** Exiba a categoria do veículo, a quantidade de veículos cadastrados, a menor diária, a maior diária e a média do valor da diária por categoria. Exiba apenas as categorias cuja média de diária seja superior a R$ 150,00.
* **d)** Liste o modelo e a placa de todos os veículos cadastrados, a quantidade de locações realizadas por cada veículo e a soma do valor total arrecadado. Inclua obrigatoriamente os veículos que nunca foram alugados (exibindo `0` na quantidade e no faturamento).
* **e)** Liste os 3 clientes que mais gastaram somando o valor total de suas locações finalizadas, exibindo o nome do cliente, a cidade e o valor total gasto.
* **f)** Liste o nome, o cargo e o salário dos funcionários que recebem acima da média salarial da empresa e que já registraram locações para clientes da cidade de `'Ribeirão Preto'`.

---

## 5. Transações Explícitas

Crie comandos para simular transações explícitas nas tabelas para os seguintes casos:

* **a)** Crie uma transação que insira uma nova locação na tabela `Locacao` com `Situacao = 'Aberta'` e atualize imediatamente o `Status` do veículo correspondente na tabela `Veiculo` para `'Alugado'`. Caso o veículo não exista ou já esteja com status diferente de `'Disponivel'`, garanta que toda a operação seja desfeita.
* **b)** Crie uma transação que finalize uma locação específica (atualizando `DataDevolucaoReal`, `ValorTotal` e `Situacao = 'Finalizada'`), libere o veículo para `'Disponivel'` somando a quilometragem rodada e, na mesma transação, insira uma multa por atraso na tabela `MultaOcorrencia` vinculada à locação finalizada.
* **c)** Crie uma transação que insira um novo registro na tabela `Manutencao`, altere o `Status` do veículo para `'Manutencao'` e conceda um aumento de 6% no `Salario` de todos os funcionários com cargo `'Mecanico'`. Caso qualquer etapa falhe, garanta que nenhuma alteração seja persistida.
*/