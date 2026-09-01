/*
1-  Crie uma tabela para cadastro de Funcionários, obedecendo as seguintes regras:
	Um campo para código deverá ser chave primária com numeração automática,
	Defina as chaves de todas as demais tabelas desta forma.
	Nome é um atributo obrigatório;
	CPF e RG são atributos que têm valor único para cada funcionário;
	Sexo poderá ser: 'M' ou 'F';
	Categoria deverá ser um dos seguintes valores: Auxiliar, Supervisor, Terceirizado, Contratado, Coordenador.
	Idade deve estar entre 16 e 65 anos;

	Código de departamento que este funcionário trabalha. ///
*/

CREATE TABLE Funcionario(
  codFuncionario INT PRIMARY KEY IDENTITY(1, 1),
  nomeFuncionario VARCHAR(200) NOT NULL,
  cpf CHAR(11),
  rg CHAR(09),
  sexo CHAR(1),
  categoria VARCHAR(20),
  idade INT,
  codDepartamento INT,
  
  CONSTRAINT UQ_Funcionario_cpf UNIQUE (cpf),
  CONSTRAINT UQ_Funcionario_rg UNIQUE (rg),
  CONSTRAINT CK_Funcionario_sexoInMouF CHECK(sexo IN ('M', 'F')),
  CONSTRAINT CK_Funcionario_categoriaIn CHECK(categoria IN 
                                              ('Auxiliar', 'Supervisor', 
                                               'Terceirizado', 'Contratado', 
                                               'Coordenador')),
  CONSTRAINT CK_Funcionario_idadeEntre16E65 CHECK (idade >= 16 AND idade <= 65),
  CONSTRAINT FK_Funcionario_Derpartamento FOREIGN KEY (codDepartamento) References Departamento(codDepartamento)
);

/*
2.	Crie uma tabela para cadastro de Departamentos, com as seguintes restrições:
	Um campo para código do departamento também com numeração automática
	Nome do departamento é atributo obrigatório
	Descrição do departamento

	Código do funcionário gerente do departamento. ////
*/

CREATE TABLE Departamento(
  codDepartamento INT PRIMARY KEY IDENTITY (1, 1),
  nomeDepartamento VARCHAR(200) NOT NULL,
  descDepartamento VARCHAR(500),
  codFuncionario INT,
  
  CONSTRAINT FK_Departamento_Funcionario FOREIGN KEY (codFuncionario) REFERENCES Funcionario(codFuncionario)
);
