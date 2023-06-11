CREATE SCHEMA crm;

USE crm;

CREATE TABLE `Usuario` (
  `pessoa_fisica` char(11) NOT NULL,
  `id_usuario` int UNIQUE NOT NULL AUTO_INCREMENT,
  `login_usuario` varchar(30) UNIQUE NOT NULL,
  `hash_senha` varchar(32) NOT NULL,
  `cargo` int NOT NULL,
  PRIMARY KEY (`id_usuario`, `login_usuario`)
);

CREATE TABLE `Cargo` (
  `id_cargo` int UNIQUE PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `descricao_cargo` varchar(20) NOT NULL
);

CREATE TABLE `Pessoa_Fisica` (
  `cpf` char(11) UNIQUE PRIMARY KEY NOT NULL,
  `nome` varchar(50) NOT NULL,
  `data_nascimento` date NOT NULL,
  `telefone` varchar(20) NOT NULL,
  `sexo` int NOT NULL
);

CREATE TABLE `Genero` (
  `id_sexo` int UNIQUE PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `sexo` varchar(30) UNIQUE NOT NULL
);

CREATE TABLE `Endereco_Pessoa_Fisica` (
  `id_endereco` int UNIQUE NOT NULL AUTO_INCREMENT,
  `id_pessoa_fisica` char(11) NOT NULL,
  `tipo_logradouro` varchar(15) NOT NULL,
  `logradouro` varchar(70) NOT NULL,
  `numero` int NOT NULL,
  `cep` char(8) NOT NULL,
  `cidade` varchar(30) NOT NULL,
  `estado` char(2) NOT NULL,
  PRIMARY KEY (`id_endereco`, `id_pessoa_fisica`)
);

CREATE TABLE `Endereco_Pessoa_Juridica` (
  `id_endereco` int UNIQUE NOT NULL AUTO_INCREMENT,
  `id_pessoa_juridica` char(11) NOT NULL,
  `tipo_logradouro` varchar(15) NOT NULL,
  `logradouro` varchar(70) NOT NULL,
  `numero` int NOT NULL,
  `cep` char(8) NOT NULL,
  `cidade` varchar(30) NOT NULL,
  `estado` char(2) NOT NULL,
  PRIMARY KEY (`id_endereco`, `id_pessoa_juridica`)
);

CREATE TABLE `Estado` (
  `sigla_estado` char(2) UNIQUE PRIMARY KEY NOT NULL,
  `nome_estado` varchar(30) UNIQUE NOT NULL
);

CREATE TABLE `Pessoa_Juridica` (
  `cnpj` char(14) UNIQUE PRIMARY KEY NOT NULL,
  `razao_social` varchar(40) UNIQUE NOT NULL,
  `nome_fantasia` varchar(70) NOT NULL
);

CREATE TABLE `Sociedade` (
  `cnpj` char(14) NOT NULL,
  `cpf` char(11) NOT NULL
);

CREATE TABLE `Venda` (
  `numero_venda` int UNIQUE PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `data_venda` timestamp NOT NULL DEFAULT (NOW()),
  `desconto` float NOT NULL DEFAULT 0,
  `xml_nota_saida` text NOT NULL,
  `vendedor` int NOT NULL,
  `cliente_juridico` char(14),
  `cliente` char(11)
);

CREATE TABLE `Produtos_Vendidos` (
  `venda` int NOT NULL,
  `produto` char(8) NOT NULL
);

CREATE TABLE `Produto` (
  `cod_produto` char(8) UNIQUE PRIMARY KEY NOT NULL,
  `valor_custo` decimal(10,2) NOT NULL,
  `valor_venda` decimal(10,2) NOT NULL,
  `lote` varchar(12) NOT NULL,
  `unidade_medida` varchar(10) NOT NULL DEFAULT "Unidade",
  `descricao` varchar(70) NOT NULL,
  `ipi` float NOT NULL,
  `icms` float NOT NULL,
  `categoria_produto` int NOT NULL
);

CREATE TABLE `Categoria_Produto` (
  `id_categoria_produto` int UNIQUE PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `categoria` varchar(30) UNIQUE NOT NULL
);

CREATE TABLE `Estoque` (
  `id_estoque` int UNIQUE PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `quantidade` int NOT NULL,
  `produto` char(8) NOT NULL
);

CREATE TABLE `Conta` (
  `id_conta` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `numero_conta` varchar(20) NOT NULL,
  `agencia_conta` char(4) NOT NULL,
  `numero_banco` char(3) NOT NULL,
  `saldo_banco` decimal(12,2) NOT NULL DEFAULT 0
);

CREATE TABLE `Receita` (
  `id_receita` int UNIQUE PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `valor_receita` decimal(10, 2) NOT NULL,
  `venda` int NOT NULL,
  `status_receita` int NOT NULL,
  `categoria_receita` int NOT NULL,
  `conta` int NOT NULL
);

CREATE TABLE `Despesa` (
  `id_despesa` int UNIQUE PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `valor_despesa` decimal(10, 2) NOT NULL,
  `usuario` int NOT NULL,
  `status_despesa` int NOT NULL,
  `categoria_despesa` int NOT NULL,
  `conta` int NOT NULL
);

CREATE TABLE `Status_Receita` (
  `id_status_receita` int UNIQUE PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `descricao_status_receita` varchar(30) UNIQUE NOT NULL
);

CREATE TABLE `Status_Despesa` (
  `id_status_despesa` int UNIQUE PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `descricao_status_despesa` varchar(30) UNIQUE NOT NULL
);

CREATE TABLE `Categoria_Receita` (
  `id_categoria_receita` int UNIQUE PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `descricao_categoria_receita` varchar(30) UNIQUE NOT NULL
);

CREATE TABLE `Categoria_Despesa` (
  `id_categoria_despesa` int UNIQUE PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `descricao_categoria_despesa` varchar(30) UNIQUE NOT NULL
);

ALTER TABLE `Usuario` ADD FOREIGN KEY (`pessoa_fisica`) REFERENCES `Pessoa_Fisica` (`cpf`);

ALTER TABLE `Usuario` ADD FOREIGN KEY (`cargo`) REFERENCES `Cargo` (`id_cargo`);

ALTER TABLE `Pessoa_Fisica` ADD FOREIGN KEY (`sexo`) REFERENCES `Genero` (`id_sexo`);

ALTER TABLE `Endereco_Pessoa_Fisica` ADD FOREIGN KEY (`id_pessoa_fisica`) REFERENCES `Pessoa_Fisica` (`cpf`);

ALTER TABLE `Endereco_Pessoa_Fisica` ADD FOREIGN KEY (`estado`) REFERENCES `Estado` (`sigla_estado`);

ALTER TABLE `Endereco_Pessoa_Juridica` ADD FOREIGN KEY (`id_pessoa_juridica`) REFERENCES `Pessoa_Juridica` (`cnpj`);

ALTER TABLE `Endereco_Pessoa_Juridica` ADD FOREIGN KEY (`estado`) REFERENCES `Estado` (`sigla_estado`);

ALTER TABLE `Sociedade` ADD FOREIGN KEY (`cnpj`) REFERENCES `Pessoa_Juridica` (`cnpj`);

ALTER TABLE `Sociedade` ADD FOREIGN KEY (`cpf`) REFERENCES `Pessoa_Fisica` (`cpf`);

ALTER TABLE `Venda` ADD FOREIGN KEY (`vendedor`) REFERENCES `Usuario` (`id_usuario`);

ALTER TABLE `Venda` ADD FOREIGN KEY (`cliente_juridico`) REFERENCES `Pessoa_Juridica` (`cnpj`);

ALTER TABLE `Venda` ADD FOREIGN KEY (`cliente`) REFERENCES `Pessoa_Fisica` (`cpf`);

ALTER TABLE `Produtos_Vendidos` ADD FOREIGN KEY (`venda`) REFERENCES `Venda` (`numero_venda`);

ALTER TABLE `Produtos_Vendidos` ADD FOREIGN KEY (`produto`) REFERENCES `Produto` (`cod_produto`);

ALTER TABLE `Produto` ADD FOREIGN KEY (`categoria_produto`) REFERENCES `Categoria_Produto` (`id_categoria_produto`);

ALTER TABLE `Estoque` ADD FOREIGN KEY (`produto`) REFERENCES `Produto` (`cod_produto`);

ALTER TABLE `Receita` ADD FOREIGN KEY (`venda`) REFERENCES `Venda` (`numero_venda`);

ALTER TABLE `Receita` ADD FOREIGN KEY (`status_receita`) REFERENCES `Status_Receita` (`id_status_receita`);

ALTER TABLE `Receita` ADD FOREIGN KEY (`categoria_receita`) REFERENCES `Categoria_Receita` (`id_categoria_receita`);

ALTER TABLE `Receita` ADD FOREIGN KEY (`conta`) REFERENCES `Conta` (`id_conta`);

ALTER TABLE `Despesa` ADD FOREIGN KEY (`usuario`) REFERENCES `Usuario` (`id_usuario`);

ALTER TABLE `Despesa` ADD FOREIGN KEY (`status_despesa`) REFERENCES `Status_Despesa` (`id_status_despesa`);

ALTER TABLE `Despesa` ADD FOREIGN KEY (`categoria_despesa`) REFERENCES `Categoria_Despesa` (`id_categoria_despesa`);

ALTER TABLE `Despesa` ADD FOREIGN KEY (`conta`) REFERENCES `Conta` (`id_conta`);
