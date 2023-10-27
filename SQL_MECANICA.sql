USE master
DROP DATABASE MECANICA
CREATE DATABASE MECANICA
USE MECANICA
GO
CREATE TABLE CLIENTE (
id_cliente				INT				NOT NULL IDENTITY(3401, 15),
nome					VARCHAR(100)	NOT NULL,
logradouro_end			VARCHAR(200)	NOT NULL,
numero_end				INT				NOT NULL CHECK(numero_end > 0),
cep_end					CHAR(8)			NOT NULL CHECK(cep_end = 8),
complemento_end			VARCHAR(255)	NOT NULL,
PRIMARY KEY (id_cliente)
)
GO
CREATE TABLE TELEFONE_CLIENTE (
clienteid_cliente		INT				NOT NULL,
telefone				VARCHAR			NOT NULL,
FOREIGN KEY (clienteid_cliente) REFERENCES CLIENTE (id_cliente),
PRIMARY KEY (clienteid_cliente, telefone)
)
GO
CREATE TABLE VEICULO (
placa					CHAR(8)			NOT NULL CHECK(placa = 7),
marca					VARCHAR(30)		NOT NULL,
modelo					VARCHAR(30)		NOT NULL,
cor						VARCHAR(15)		NOT NULL,
ano_fabricacao			INT				NOT NULL CHECK(ano_fabricacao > 1997),
ano_modelo				INT				NOT NULL CHECK(ano_modelo > 1997),
data_aquisicao			DATE			NOT NULL,
clienteid_cliente		INT				NOT NULL,
FOREIGN KEY (clienteid_cliente) REFERENCES CLIENTE (id_cliente),
PRIMARY KEY (placa),
CONSTRAINT chk_ano_modelo_ano_fabricacao CHECK(ano_modelo >= ano_fabricacao AND ano_modelo <= ano_fabricacao + 1)
)
GO
CREATE TABLE PECA (
id_peca					INT				NOT NULL IDENTITY(3411, 7),
nome					VARCHAR(30)		NOT NULL UNIQUE,
preco					DECIMAL(4, 2)	NOT NULL CHECK(preco > 0),
estoque					INT				NOT NULL CHECK(estoque > 10),
PRIMARY KEY (id_peca)
)
GO
CREATE TABLE CATEGORIA (
id_categoria			INT				NOT NULL IDENTITY(1, 1),
categoria				VARCHAR(10)		NOT NULL,
valor_hora				DECIMAL(4, 2)	NOT NULL CHECK(valor_hora > 0),
PRIMARY KEY (id_categoria),
CONSTRAINT chk_categoria_valor_hora 
CHECK   ((UPPER(categoria) = 'Estagiário' AND valor_hora > 15.00) OR
        ((UPPER(categoria) = 'Nível 1'    AND valor_hora> 25.00) OR
        ((UPPER(categoria) = 'Nível 2'    AND valor_hora> 35.00) OR
        ((UPPER(categoria) = 'Nível 3'    AND valor_hora> 50.00)))))
)
GO
CREATE TABLE FUNCIONARIO (
id_funcionario			INT				NOT NULL IDENTITY(101, 1),
nome					VARCHAR(100)	NOT NULL,
logradouro_end			VARCHAR(200)	NOT NULL,
numero_end				INT				NOT NULL CHECK(numero_end > 0),
telefone				CHAR(11)		NOT NULL CHECK(telefone = 10 OR telefone = 11),
categoria_habilitacao	VARCHAR(2)		NOT NULL CHECK ((UPPER(categoria_habilitacao) = 'A') OR (UPPER(categoria_habilitacao) = 'B')
 OR (UPPER(categoria_habilitacao) = 'C') OR (UPPER(categoria_habilitacao) = 'D') OR (UPPER(categoria_habilitacao) = 'E')),
categoriaid				INT				NOT NULL,
FOREIGN KEY (categoriaid) REFERENCES CATEGORIA (id_categoria),
PRIMARY KEY (id_funcionario)
)
GO
CREATE TABLE REPARO (
veiculo_placa			CHAR(8)			NOT NULL,
funcionario_id			INT				NOT NULL,
peca_id					INT				NOT NULL,
datinha					DATE			NOT NULL DEFAULT(GETDATE()),
custo_total				DECIMAL(4, 2)	NOT NULL CHECK(custo_total	 < 0),
tempo					INT				NOT NULL CHECK(tempo	 < 0),
FOREIGN KEY (veiculo_placa) REFERENCES VEICULO (placa),
FOREIGN KEY (funcionario_id) REFERENCES FUNCIONARIO (id_funcionario),
FOREIGN KEY (peca_id) REFERENCES PECA (id_peca),
PRIMARY KEY (veiculo_placa, funcionario_id, peca_id)
)
GO



