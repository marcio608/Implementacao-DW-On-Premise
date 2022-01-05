
-- Inicia-se agora o trabalho de limpeza dos dados na satage area. Alguns problemas foram simulados nos dados.


-- ************** Conectado como usuário starea **************

-- Limpeza e Transformação da tabela ST_CADASTRO_CLIENTE

SELECT * FROM ST_CADASTRO_CLIENTE

-- Adicionando uma tabela data.
ALTER TABLE ST_CADASTRO_CLIENTE ADD (DATA_REGISTRO DATE); 

-- Preenchendo a tabela DATA_REGISTRO com a data atual.

UPDATE ST_CADASTRO_CLIENTE SET DATA_REGISTRO = CURRENT_DATE;
COMMIT;

-- No campo EMAIL_CLIENTE há 3 tipos de problemas:

--(i) Campo email nulo
-- Neste caso optou-se por deixar a mensagem 'não informado'.
UPDATE ST_CADASTRO_CLIENTE SET EMAIL_CLIENTE = 'não informado' where email_cliente is null;
COMMIT;

--(ii) Campo email com caracteres 'xxx' no começo do email
-- Neste caso também optou-se por deixar a mensagem 'não informado'.

UPDATE ST_CADASTRO_CLIENTE SET EMAIL_CLIENTE = 'não informado' where substr(email_cliente, 1, 3) = 'xxx';
COMMIT;

-- (iii) Números no campo do email
-- Neste caso criou-se uma função 
CREATE FUNCTION e_numero( p_str IN VARCHAR2 )
  RETURN NUMBER
IS
  l_num NUMBER;
BEGIN
  l_num := to_number( p_str );
  RETURN 1;
EXCEPTION
  WHEN value_error
  THEN
    RETURN 0;
END;

-- Aplicando a função
UPDATE ST_CADASTRO_CLIENTE SET EMAIL_CLIENTE = 'não informado' where e_numero(email_cliente) = 1;
COMMIT;


--(iv) Não há o campo CEP e o campo Aceita_Campanha na tabela CADASTRO_CLIENTE
--O campo CEP será então importado da tabela ENDERECO e o campo ACEITA_CAMPANHA será inserido e contará com o valor zero

CREATE TABLE ST_DIM_CLIENTE 
(
  NK_ID_CLIENTE VARCHAR2(20), 
  NM_CLIENTE VARCHAR2(50), 
  NM_CIDADE_CLIENTE VARCHAR2(50), 
  FLAG_ACEITA_CAMPANHA CHAR(1), 
  DESC_CEP VARCHAR2(10)
);

INSERT INTO ST_DIM_CLIENTE 
SELECT A.ID_CLIENTE, A.NOME_CLIENTE, B.CIDADE, 0, B.CEP
FROM ST_CADASTRO_CLIENTE A, ST_ENDERECO B
where A.ID_CLIENTE = B.ID_CLIENTE;
COMMIT;

SELECT * FROM ST_DIM_CLIENTE



-- Limpeza e Transformação da tabela ST_LOCALIDADE

-- Problema: não há o campo REGIAO
--Cria-se então o campo REGIAO.


CREATE TABLE ST_DIM_LOCALIDADE (
    NK_ID_LOCALIDADE VARCHAR(20) NOT NULL,
    NM_LOCALIDADE VARCHAR(50) NOT NULL,
    NM_CIDADE_LOCALIDADE VARCHAR(50) NOT NULL,
    NM_REGIAO_LOCALIDADE VARCHAR(50) NOT NULL
);

INSERT INTO ST_DIM_LOCALIDADE
SELECT ID_LOCALIDADE, NOME_LOCALIDADE, CIDADE_LOCALIDADE,  
CASE
WHEN CIDADE_LOCALIDADE = 'Barueri' THEN 'Sudeste'
WHEN CIDADE_LOCALIDADE = 'São Paulo' THEN 'Sudeste'
WHEN CIDADE_LOCALIDADE = 'Rio de Janeiro' THEN 'Sudeste'
WHEN CIDADE_LOCALIDADE = 'Salvador' THEN 'Nordeste'
WHEN CIDADE_LOCALIDADE = 'Tatuapé' THEN 'Sudeste'
ELSE 'NA'
END as REGIAO
FROM ST_LOCALIDADE;
COMMIT;

SELECT * FROM ST_DIM_LOCALIDADE;


-- Limpeza e Transformação da tabela ST_PRODUTO e ST_CATEGORIA 

-- Problema: não há marca do produto na fonte.

CREATE TABLE ST_DIM_PRODUTO (
    NK_ID_PRODUTO VARCHAR(20) NOT NULL,
    DESC_SKU VARCHAR(50) NOT NULL,
    NM_PRODUTO VARCHAR(50) NOT NULL,
    NM_CATEGORIA_PRODUTO VARCHAR(30) NOT NULL,
    NM_MARCA_PRODUTO VARCHAR(30) NOT NULL
);

SELECT A.ID_PRODUTO, A.SKU, A.NOME_PRODUTO, B.NOME_CATEGORIA
FROM ST_PRODUTO A, ST_CATEGORIA B
WHERE A.ID_CATEGORIA = B.ID_CATEGORIA;

-- Inserindo as marcas 
INSERT INTO ST_DIM_PRODUTO
SELECT A.ID_PRODUTO, A.SKU, A.NOME_PRODUTO, B.NOME_CATEGORIA,
CASE
WHEN A.NOME_PRODUTO LIKE '%Sony%' THEN 'Sony'  -- Query: Quando houver a palavra sony no nome do produto então a marca é Sony.
WHEN A.NOME_PRODUTO LIKE '%Iphone%' THEN 'Apple'
WHEN A.NOME_PRODUTO LIKE '%MSI%' THEN 'MSI'
WHEN A.NOME_PRODUTO LIKE '%Galaxy%' THEN 'Samsung'
WHEN A.NOME_PRODUTO LIKE '%ASUS%' THEN 'Asus'
WHEN A.NOME_PRODUTO LIKE '%Vaio%' THEN 'Vaio'
WHEN A.NOME_PRODUTO LIKE '%Canon%' THEN 'Canon'
ELSE 'NA'
END as MARCA_PRODUTO
FROM ST_PRODUTO A, ST_CATEGORIA B
WHERE A.ID_CATEGORIA = B.ID_CATEGORIA;
COMMIT;


SELECT * FROM ST_DIM_PRODUTO


-- Limpeza e Transformação da tabela ST_PEDIDOS e ST_ITENS_PEDIDO 

-- Problemas: valores nulos em status_pagamento e data_transacao
-- Decisão de negócio: substituir valores NA em status_pagamento por 'Erro'
	--Substituir o valor nulo na data_transacao pelo valor da data_entrega.
	
	
CREATE TABLE ST_VENDA(
    ID_TRANSACAO INTEGER,
    DATA_VENDA DATE,
    STATUS_PAGAMENTO VARCHAR2(20),
    ID_CLIENTE INTEGER,
    ID_LOCALIDADE INTEGER,
    ID_PRODUTO INTEGER,
    QUANTIDADE INTEGER,
    PRECO_UNITARIO DECIMAL
);

SELECT * FROM ST_PEDIDOS
SELECT * FROM ST_ITENS_PEDIDO

INSERT INTO ST_VENDA
SELECT A.ID_TRANSACAO, A.DATA_ENTREGA, 
CASE
WHEN A.STATUS_PAGAMENTO = 'NA' THEN 'Erro'
ELSE A.STATUS_PAGAMENTO
END as STATUS_PAGAMENTO, A.ID_CLIENTE, A.ID_LOCALIDADE, B.ID_PRODUTO, B.QUANTIDADE, B.PRECO_UNITARIO
FROM ST_PEDIDOS A, ST_ITENS_PEDIDO B
WHERE A.ID_TRANSACAO = B.ID_TRANSACAO;
COMMIT;

SELECT * FROM ST_VENDA





