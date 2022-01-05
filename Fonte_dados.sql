-- Cria o schema source

-- ************** Conectado como usuário system **************

-- Cria a tablespace

-- Tablespace especifica a localização de armazenamento do BD
CREATE TABLESPACE TBS_SOURCE -- nome da Tablespace
LOGGING DATAFILE '/u01/app/oracle/oradata/orcl/TBS_SOURCE.dbf' --localização
SIZE 1M AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO;    --tamanho

-- Caso seja necessário remover o usuário e recriá-lo
-- Drop user source cascade;

-- Cria o schema
CREATE USER source IDENTIFIED BY source0123;
GRANT CONNECT, RESOURCE TO source;
GRANT UNLIMITED TABLESPACE TO source;


-- ************** Conectado como usuário source **************

CREATE TABLE TB_CADASTRO_CLIENTE 
(
  ID_CLIENTE INTEGER  NOT NULL 
, NOME_CLIENTE VARCHAR2(100) 
, EMAIL_CLIENTE VARCHAR2(50) 
, CONSTRAINT TB_CADASTRO_CLIENTE_PK PRIMARY KEY 
  (
    ID_CLIENTE 
  )
  ENABLE 
);

CREATE TABLE TB_ENDERECO 
(
  ID_ENDERECO INTEGER NOT NULL 
, LOGRADOURO VARCHAR2(50) 
, NUMERO NUMBER 
, CIDADE VARCHAR2(20) 
, ESTADO VARCHAR2(20) 
, PAIS VARCHAR2(20) 
, CEP VARCHAR2(20) 
, ID_CLIENTE INTEGER
, CONSTRAINT TB_ENDERECO_PK PRIMARY KEY 
  (
    ID_ENDERECO 
  )
  ENABLE 
);

ALTER TABLE TB_ENDERECO
ADD CONSTRAINT TB_ENDERECO_FK1 FOREIGN KEY
(
  ID_CLIENTE 
)
REFERENCES TB_CADASTRO_CLIENTE
(
  ID_CLIENTE 
)
ENABLE;

CREATE TABLE TB_PRODUTO 
(
  ID_PRODUTO INTEGER NOT NULL 
, SKU VARCHAR2(30) 
, NOME_PRODUTO VARCHAR2(100) 
, ID_CATEGORIA INTEGER
, CONSTRAINT TB_PRODUTO_PK PRIMARY KEY 
  (
    ID_PRODUTO 
  )
  ENABLE 
);

CREATE TABLE TB_CATEGORIA 
(
  ID_CATEGORIA INTEGER NOT NULL 
, NOME_CATEGORIA VARCHAR2(20) 
, NOME_SUB_CATEGORIA VARCHAR2(20) 
, CONSTRAINT TB_CATEGORIA_PK PRIMARY KEY 
  (
    ID_CATEGORIA 
  )
  ENABLE 
);

ALTER TABLE TB_PRODUTO
ADD CONSTRAINT TB_PRODUTO_FK1 FOREIGN KEY
(
  ID_CATEGORIA 
)
REFERENCES TB_CATEGORIA
(
  ID_CATEGORIA 
)
ENABLE;

CREATE TABLE TB_LOCALIDADE 
(
  ID_LOCALIDADE INTEGER NOT NULL 
, NOME_LOCALIDADE VARCHAR2(100) 
, CIDADE_LOCALIDADE VARCHAR2(20) 
, CONSTRAINT TB_LOCALIDADE_PK PRIMARY KEY 
  (
    ID_LOCALIDADE 
  )
  ENABLE 
);


CREATE TABLE TB_PEDIDOS 
(
  ID_TRANSACAO INTEGER NOT NULL 
, DATA_TRANSACAO TIMESTAMP 
, DATA_ENTREGA TIMESTAMP 
, STATUS_PAGAMENTO VARCHAR2(20) 
, ID_CLIENTE INTEGER 
, ID_LOCALIDADE INTEGER 
, CONSTRAINT TB_PEDIDOS_PK PRIMARY KEY 
  (
    ID_TRANSACAO 
  )
  ENABLE 
);

ALTER TABLE TB_PEDIDOS
ADD CONSTRAINT TB_PEDIDOS_FK1 FOREIGN KEY
(
  ID_CLIENTE 
)
REFERENCES TB_CADASTRO_CLIENTE
(
  ID_CLIENTE 
)
ENABLE;

ALTER TABLE TB_PEDIDOS
ADD CONSTRAINT TB_PEDIDOS_FK2 FOREIGN KEY
(
  ID_LOCALIDADE 
)
REFERENCES TB_LOCALIDADE
(
  ID_LOCALIDADE 
)
ENABLE;



CREATE TABLE TB_ITENS_PEDIDO 
(
  ID_TRANSACAO INTEGER NOT NULL 
, ID_PRODUTO INTEGER NOT NULL 
, QUANTIDADE INTEGER 
, PRECO_UNITARIO DOUBLE PRECISION 
, CONSTRAINT TB_ITENS_PEDIDO_PK PRIMARY KEY 
  (
    ID_TRANSACAO 
  , ID_PRODUTO 
  )
  ENABLE 
);

ALTER TABLE TB_ITENS_PEDIDO
ADD CONSTRAINT TB_ITENS_PEDIDO_FK1 FOREIGN KEY
(
  ID_PRODUTO 
)
REFERENCES TB_PRODUTO
(
  ID_PRODUTO 
)
ENABLE;


TRUNCATE TABLE TB_CADASTRO_CLIENTE;
INSERT INTO "SOURCE"."TB_CADASTRO_CLIENTE" (ID_CLIENTE, NOME_CLIENTE, EMAIL_CLIENTE) VALUES ('1098', 'Pele', 'pele@gmail.com');
INSERT INTO "SOURCE"."TB_CADASTRO_CLIENTE" (ID_CLIENTE, NOME_CLIENTE, EMAIL_CLIENTE) VALUES ('1099', 'Zico', 'zico@gmail.com');
INSERT INTO "SOURCE"."TB_CADASTRO_CLIENTE" (ID_CLIENTE, NOME_CLIENTE, EMAIL_CLIENTE) VALUES ('1000', 'Ronaldo', 'ronaldo@gmail.com');
INSERT INTO "SOURCE"."TB_CADASTRO_CLIENTE" (ID_CLIENTE, NOME_CLIENTE, EMAIL_CLIENTE) VALUES ('1198', 'Rivaldo', 'rivaldo@gmail.com');
INSERT INTO "SOURCE"."TB_CADASTRO_CLIENTE" (ID_CLIENTE, NOME_CLIENTE, EMAIL_CLIENTE) VALUES ('1298', 'Zidane', 'zidane@gmail.com');
INSERT INTO "SOURCE"."TB_CADASTRO_CLIENTE" (ID_CLIENTE, NOME_CLIENTE, EMAIL_CLIENTE) VALUES ('1398', 'Cristiano', 'cristiano@gmail.com');
INSERT INTO "SOURCE"."TB_CADASTRO_CLIENTE" (ID_CLIENTE, NOME_CLIENTE, EMAIL_CLIENTE) VALUES ('1048', 'Messi', '');
INSERT INTO "SOURCE"."TB_CADASTRO_CLIENTE" (ID_CLIENTE, NOME_CLIENTE, EMAIL_CLIENTE) VALUES ('1928', 'Julio', 'xxxgmail.com');
INSERT INTO "SOURCE"."TB_CADASTRO_CLIENTE" (ID_CLIENTE, NOME_CLIENTE, EMAIL_CLIENTE) VALUES ('1028', 'Messias', 'messias@gmail.com');
INSERT INTO "SOURCE"."TB_CADASTRO_CLIENTE" (ID_CLIENTE, NOME_CLIENTE, EMAIL_CLIENTE) VALUES ('1348', 'Matusalem', '12345');
commit;

TRUNCATE TABLE TB_ENDERECO;
INSERT INTO "SOURCE"."TB_ENDERECO" (ID_ENDERECO, LOGRADOURO, NUMERO, CIDADE, ESTADO, PAIS, CEP, ID_CLIENTE) VALUES ('999887766', 'Rua Nano', '245', 'Rio de Janeiro', 'RJ', 'Brasil', '22998-761', '1098');
INSERT INTO "SOURCE"."TB_ENDERECO" (ID_ENDERECO, LOGRADOURO, NUMERO, CIDADE, ESTADO, PAIS, CEP, ID_CLIENTE) VALUES ('999887768', 'Rua Macieiras', '12', 'Belo Horizonte', 'MG', 'Brasil', '22998-763', '1099');
INSERT INTO "SOURCE"."TB_ENDERECO" (ID_ENDERECO, LOGRADOURO, NUMERO, CIDADE, ESTADO, PAIS, CEP, ID_CLIENTE) VALUES ('999887769', 'Av. Goiabeiras', '76', 'Vela Velha', 'ES', 'Brasil', '21998-763', '1000');
INSERT INTO "SOURCE"."TB_ENDERECO" (ID_ENDERECO, LOGRADOURO, NUMERO, CIDADE, ESTADO, PAIS, CEP, ID_CLIENTE) VALUES ('999887770', 'Av. Kremilim', '769', 'Cariacica', 'ES', 'Brasil', '21398-763', '1198');
commit;

TRUNCATE TABLE TB_CATEGORIA;
INSERT INTO "SOURCE"."TB_CATEGORIA" (ID_CATEGORIA, NOME_CATEGORIA, NOME_SUB_CATEGORIA) VALUES ('87654', 'Notebook', 'Pessoal');
INSERT INTO "SOURCE"."TB_CATEGORIA" (ID_CATEGORIA, NOME_CATEGORIA, NOME_SUB_CATEGORIA) VALUES ('87655', 'Notebook', 'Business');
INSERT INTO "SOURCE"."TB_CATEGORIA" (ID_CATEGORIA, NOME_CATEGORIA, NOME_SUB_CATEGORIA) VALUES ('87656', 'Camera', 'Longa Distância');
INSERT INTO "SOURCE"."TB_CATEGORIA" (ID_CATEGORIA, NOME_CATEGORIA, NOME_SUB_CATEGORIA) VALUES ('87657', 'Camera', 'Semi Profissional');
INSERT INTO "SOURCE"."TB_CATEGORIA" (ID_CATEGORIA, NOME_CATEGORIA, NOME_SUB_CATEGORIA) VALUES ('87658', 'Smartphone', '8 GB Memória');
INSERT INTO "SOURCE"."TB_CATEGORIA" (ID_CATEGORIA, NOME_CATEGORIA, NOME_SUB_CATEGORIA) VALUES ('87659', 'Smartphone', '4 GB Memória');
commit;

TRUNCATE TABLE TB_PRODUTO;
INSERT INTO "SOURCE"."TB_PRODUTO" (ID_PRODUTO, SKU, NOME_PRODUTO, ID_CATEGORIA) VALUES ('12098712', 'DFGTHN6ER4RF', 'Notebook Vaio', '87654');
INSERT INTO "SOURCE"."TB_PRODUTO" (ID_PRODUTO, SKU, NOME_PRODUTO, ID_CATEGORIA) VALUES ('12098713', 'DFWEHN6ER4RF', 'Iphone 8', '87658');
INSERT INTO "SOURCE"."TB_PRODUTO" (ID_PRODUTO, SKU, NOME_PRODUTO, ID_CATEGORIA) VALUES ('12098714', 'DF11HN6ER4RF', 'Camera Sony', '87657');
INSERT INTO "SOURCE"."TB_PRODUTO" (ID_PRODUTO, SKU, NOME_PRODUTO, ID_CATEGORIA) VALUES ('12098715', 'DFGUHN6ER4RF', 'Notebook MSI 16 GB', '87654');
INSERT INTO "SOURCE"."TB_PRODUTO" (ID_PRODUTO, SKU, NOME_PRODUTO, ID_CATEGORIA) VALUES ('12098716', 'DFGUHN6E07RF', 'Samsung Galaxy 9', '87659');
INSERT INTO "SOURCE"."TB_PRODUTO" (ID_PRODUTO, SKU, NOME_PRODUTO, ID_CATEGORIA) VALUES ('12098717', 'DFGUHN6ER08F', 'Camera Canon XTR', '87656');
INSERT INTO "SOURCE"."TB_PRODUTO" (ID_PRODUTO, SKU, NOME_PRODUTO, ID_CATEGORIA) VALUES ('12098718', 'DFGUHN6094RF', 'Notebook ASUS 16 GB', '87654');
commit;

TRUNCATE TABLE TB_LOCALIDADE;
INSERT INTO "SOURCE"."TB_LOCALIDADE" (ID_LOCALIDADE, NOME_LOCALIDADE, CIDADE_LOCALIDADE) VALUES ('1', 'Loja Barueri', 'Barueri');
INSERT INTO "SOURCE"."TB_LOCALIDADE" (ID_LOCALIDADE, NOME_LOCALIDADE, CIDADE_LOCALIDADE) VALUES ('2', 'Loja Centro', 'São Paulo');
INSERT INTO "SOURCE"."TB_LOCALIDADE" (ID_LOCALIDADE, NOME_LOCALIDADE, CIDADE_LOCALIDADE) VALUES ('3', 'Loja Tatuape', 'Tatuapé');
INSERT INTO "SOURCE"."TB_LOCALIDADE" (ID_LOCALIDADE, NOME_LOCALIDADE, CIDADE_LOCALIDADE) VALUES ('4', 'Loja Cinelandia', 'Rio de Janeiro');
INSERT INTO "SOURCE"."TB_LOCALIDADE" (ID_LOCALIDADE, NOME_LOCALIDADE, CIDADE_LOCALIDADE) VALUES ('5', 'Loja Pelourinho', 'Salvador');
commit;

TRUNCATE TABLE TB_PEDIDOS;
INSERT INTO "SOURCE"."TB_PEDIDOS" (ID_TRANSACAO, DATA_TRANSACAO, DATA_ENTREGA, STATUS_PAGAMENTO, ID_CLIENTE, ID_LOCALIDADE) VALUES ('009987654432', null, TO_TIMESTAMP('2018-04-17 14:23:22.395000000', 'YYYY-MM-DD HH24:MI:SS.FF'), 'Pago', '1099', 1);
INSERT INTO "SOURCE"."TB_PEDIDOS" (ID_TRANSACAO, DATA_TRANSACAO, DATA_ENTREGA, STATUS_PAGAMENTO, ID_CLIENTE, ID_LOCALIDADE) VALUES ('009985654432', TO_TIMESTAMP('2018-04-16 14:22:38.437000000', 'YYYY-MM-DD HH24:MI:SS.FF'), TO_TIMESTAMP('2018-04-17 15:23:22.395000000', 'YYYY-MM-DD HH24:MI:SS.FF'), 'Pago', '1098', 2);
INSERT INTO "SOURCE"."TB_PEDIDOS" (ID_TRANSACAO, DATA_TRANSACAO, DATA_ENTREGA, STATUS_PAGAMENTO, ID_CLIENTE, ID_LOCALIDADE) VALUES ('009985554432', null, TO_TIMESTAMP('2018-04-17 16:23:22.395000000', 'YYYY-MM-DD HH24:MI:SS.FF'), 'Pago', '1000', 5);
INSERT INTO "SOURCE"."TB_PEDIDOS" (ID_TRANSACAO, DATA_TRANSACAO, DATA_ENTREGA, STATUS_PAGAMENTO, ID_CLIENTE, ID_LOCALIDADE) VALUES ('009981254432', TO_TIMESTAMP('2018-04-16 16:22:38.437000000', 'YYYY-MM-DD HH24:MI:SS.FF'), TO_TIMESTAMP('2018-04-17 16:23:22.395000000', 'YYYY-MM-DD HH24:MI:SS.FF'), 'NA', '1398', 2);
INSERT INTO "SOURCE"."TB_PEDIDOS" (ID_TRANSACAO, DATA_TRANSACAO, DATA_ENTREGA, STATUS_PAGAMENTO, ID_CLIENTE, ID_LOCALIDADE) VALUES ('009982354432', TO_TIMESTAMP('2018-04-16 17:28:38.437000000', 'YYYY-MM-DD HH24:MI:SS.FF'), TO_TIMESTAMP('2018-04-17 17:13:22.395000000', 'YYYY-MM-DD HH24:MI:SS.FF'), 'Pago', '1048', 3);
INSERT INTO "SOURCE"."TB_PEDIDOS" (ID_TRANSACAO, DATA_TRANSACAO, DATA_ENTREGA, STATUS_PAGAMENTO, ID_CLIENTE, ID_LOCALIDADE) VALUES ('009987954432', TO_TIMESTAMP('2018-04-16 18:24:38.437000000', 'YYYY-MM-DD HH24:MI:SS.FF'), TO_TIMESTAMP('2018-04-17 18:43:22.395000000', 'YYYY-MM-DD HH24:MI:SS.FF'), 'Pago', '1028', 4);
INSERT INTO "SOURCE"."TB_PEDIDOS" (ID_TRANSACAO, DATA_TRANSACAO, DATA_ENTREGA, STATUS_PAGAMENTO, ID_CLIENTE, ID_LOCALIDADE) VALUES ('009980954432', TO_TIMESTAMP('2018-04-16 13:29:38.437000000', 'YYYY-MM-DD HH24:MI:SS.FF'), TO_TIMESTAMP('2018-04-17 19:53:22.395000000', 'YYYY-MM-DD HH24:MI:SS.FF'), 'Pago', '1348', 5);
commit;

TRUNCATE TABLE TB_ITENS_PEDIDO;
INSERT INTO "SOURCE"."TB_ITENS_PEDIDO" (ID_TRANSACAO, ID_PRODUTO, QUANTIDADE, PRECO_UNITARIO) VALUES ('009987654432', '12098712', '1', '2900');
INSERT INTO "SOURCE"."TB_ITENS_PEDIDO" (ID_TRANSACAO, ID_PRODUTO, QUANTIDADE, PRECO_UNITARIO) VALUES ('009985654432', '12098713', '1', '3900.00');
INSERT INTO "SOURCE"."TB_ITENS_PEDIDO" (ID_TRANSACAO, ID_PRODUTO, QUANTIDADE, PRECO_UNITARIO) VALUES ('009985554432', '12098712', '3', '2870.00');
INSERT INTO "SOURCE"."TB_ITENS_PEDIDO" (ID_TRANSACAO, ID_PRODUTO, QUANTIDADE, PRECO_UNITARIO) VALUES ('009981254432', '12098715', '1', '1765.00');
INSERT INTO "SOURCE"."TB_ITENS_PEDIDO" (ID_TRANSACAO, ID_PRODUTO, QUANTIDADE, PRECO_UNITARIO) VALUES ('009982354432', '12098714', '2', '1740.00');
INSERT INTO "SOURCE"."TB_ITENS_PEDIDO" (ID_TRANSACAO, ID_PRODUTO, QUANTIDADE, PRECO_UNITARIO) VALUES ('009987954432', '12098712', '1', '1900.00');
INSERT INTO "SOURCE"."TB_ITENS_PEDIDO" (ID_TRANSACAO, ID_PRODUTO, QUANTIDADE, PRECO_UNITARIO) VALUES ('009980954432', '12098718', '2', '856.00');
commit;

-- Verificando os dados na fonte
select nome_localidade, nome_produto, sum(d.quantidade * d.preco_unitario) as total
from TB_LOCALIDADE a, TB_PRODUTO b, TB_PEDIDOS c, TB_ITENS_PEDIDO d
where a.id_localidade = c.ID_LOCALIDADE
  and b.ID_PRODUTO = d.ID_PRODUTO
  and c.ID_TRANSACAO = d.ID_TRANSACAO
group by nome_localidade, nome_produto
order by nome_localidade, nome_produto

