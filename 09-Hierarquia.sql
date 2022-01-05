-- ************* Conectado como usuário source *************
-- Adicionando hirarquia nos dados

ALTER TABLE TB_PRODUTO MODIFY CONSTRAINT TB_PRODUTO_FK1 DISABLE; -- desabilitando as CONSTRAINTS

TRUNCATE TABLE TB_CATEGORIA;

ALTER TABLE TB_CATEGORIA DROP COLUMN NOME_SUB_CATEGORIA;
ALTER TABLE TB_CATEGORIA ADD (ID_CATEGORIA_PAI NUMBER);


SELECT * FROM TB_CATEGORIA;

INSERT INTO "SOURCE"."TB_CATEGORIA" (ID_CATEGORIA, NOME_CATEGORIA, ID_CATEGORIA_PAI) VALUES ('87654', 'Notebook', NULL);
INSERT INTO "SOURCE"."TB_CATEGORIA" (ID_CATEGORIA, NOME_CATEGORIA, ID_CATEGORIA_PAI) VALUES ('87660', 'Pessoal', '87654');
INSERT INTO "SOURCE"."TB_CATEGORIA" (ID_CATEGORIA, NOME_CATEGORIA, ID_CATEGORIA_PAI) VALUES ('87661', 'Business', '87654');
INSERT INTO "SOURCE"."TB_CATEGORIA" (ID_CATEGORIA, NOME_CATEGORIA, ID_CATEGORIA_PAI) VALUES ('87656', 'Camera', NULL);
INSERT INTO "SOURCE"."TB_CATEGORIA" (ID_CATEGORIA, NOME_CATEGORIA, ID_CATEGORIA_PAI) VALUES ('87662', 'Longa Distância', '87656');
INSERT INTO "SOURCE"."TB_CATEGORIA" (ID_CATEGORIA, NOME_CATEGORIA, ID_CATEGORIA_PAI) VALUES ('87663', 'Semi Profissional', '87656');
INSERT INTO "SOURCE"."TB_CATEGORIA" (ID_CATEGORIA, NOME_CATEGORIA, ID_CATEGORIA_PAI) VALUES ('87658', 'Smartphone', NULL);
INSERT INTO "SOURCE"."TB_CATEGORIA" (ID_CATEGORIA, NOME_CATEGORIA, ID_CATEGORIA_PAI) VALUES ('87664', '8 GB Memória', '87658');
INSERT INTO "SOURCE"."TB_CATEGORIA" (ID_CATEGORIA, NOME_CATEGORIA, ID_CATEGORIA_PAI) VALUES ('87665', '4 GB Memória', '87658');
COMMIT;

SELECT * FROM TB_PRODUTO;

UPDATE "SOURCE"."TB_PRODUTO" SET ID_CATEGORIA = '87661' WHERE ID_PRODUTO = 12098712;
UPDATE "SOURCE"."TB_PRODUTO" SET ID_CATEGORIA = '87664' WHERE ID_PRODUTO = 12098713;
UPDATE "SOURCE"."TB_PRODUTO" SET ID_CATEGORIA = '87662' WHERE ID_PRODUTO = 12098714;
UPDATE "SOURCE"."TB_PRODUTO" SET ID_CATEGORIA = '87660' WHERE ID_PRODUTO = 12098715;
UPDATE "SOURCE"."TB_PRODUTO" SET ID_CATEGORIA = '87665' WHERE ID_PRODUTO = 12098716;
UPDATE "SOURCE"."TB_PRODUTO" SET ID_CATEGORIA = '87663' WHERE ID_PRODUTO = 12098717;
UPDATE "SOURCE"."TB_PRODUTO" SET ID_CATEGORIA = '87660' WHERE ID_PRODUTO = 12098718;
COMMIT;

ALTER TABLE TB_PRODUTO MODIFY CONSTRAINT TB_PRODUTO_FK1 ENABLE; -- habilitando as constr

SELECT NOME_PRODUTO, NOME_CATEGORIA
  FROM TB_PRODUTO, TB_CATEGORIA
 WHERE TB_CATEGORIA.ID_CATEGORIA = TB_PRODUTO.ID_CATEGORIA;

grant select on tb_categoria to starea;
grant select on tb_produto to starea;


-- ************* Conectado como usuário starea *************

DROP TABLE ST_CATEGORIA;

CREATE TABLE ST_CATEGORIA 
(
  ID_CATEGORIA INTEGER NOT NULL 
, NOME_CATEGORIA VARCHAR2(255) 
, ID_CATEGORIA_PAI VARCHAR2(255) 
);

TRUNCATE TABLE ST_CATEGORIA;
INSERT INTO ST_CATEGORIA
SELECT * FROM source.TB_CATEGORIA;
COMMIT;

DROP TABLE ST_PRODUTO;

CREATE TABLE ST_PRODUTO 
(
  ID_PRODUTO INTEGER NOT NULL 
, SKU VARCHAR2(255) 
, NOME_PRODUTO VARCHAR2(255) 
, ID_CATEGORIA INTEGER
);


TRUNCATE TABLE ST_PRODUTO;
INSERT INTO ST_PRODUTO
SELECT * FROM source.TB_PRODUTO;
commit;

DROP TABLE ST_DIM_PRODUTO;

CREATE TABLE ST_DIM_PRODUTO (
    NK_ID_PRODUTO VARCHAR(20) NOT NULL,
    DESC_SKU VARCHAR(50) NOT NULL,
    NM_PRODUTO VARCHAR(50) NOT NULL,
    ID_CATEGORIA_PRODUTO INTEGER,
    NM_CATEGORIA_PRODUTO VARCHAR(30) NOT NULL,
    ID_CATEGORIA_PAI INTEGER,
    NM_CATEGORIA_PAI VARCHAR(30) NOT NULL,
    NM_MARCA_PRODUTO VARCHAR(30) NOT NULL
);

grant select on ST_DIM_PRODUTO to dw;

SELECT A.ID_PRODUTO, A.SKU, A.NOME_PRODUTO, B.ID_CATEGORIA, B.NOME_CATEGORIA, B.ID_CATEGORIA_PAI
FROM ST_PRODUTO A, ST_CATEGORIA B
WHERE A.ID_CATEGORIA = B.ID_CATEGORIA;

SELECT A.ID_CATEGORIA, A.NOME_CATEGORIA, A.ID_CATEGORIA_PAI, B.NOME_CATEGORIA AS NOME_CATEGORIA_PAI
  FROM ST_CATEGORIA A, ST_CATEGORIA B
 WHERE A.ID_CATEGORIA_PAI = B.ID_CATEGORIA;

INSERT INTO ST_DIM_PRODUTO
SELECT A.ID_PRODUTO, 
       A.SKU, 
       A.NOME_PRODUTO, 
       B.ID_CATEGORIA, 
       B.NOME_CATEGORIA, 
       B.ID_CATEGORIA_PAI, 
       C.NOME_CATEGORIA AS NOME_CATEGORIA_PAI,
       CASE
        WHEN A.NOME_PRODUTO LIKE '%Sony%' THEN 'Sony'
        WHEN A.NOME_PRODUTO LIKE '%Iphone%' THEN 'Apple'
        WHEN A.NOME_PRODUTO LIKE '%MSI%' THEN 'MSI'
        WHEN A.NOME_PRODUTO LIKE '%Galaxy%' THEN 'Samsung'
        WHEN A.NOME_PRODUTO LIKE '%ASUS%' THEN 'Asus'
        WHEN A.NOME_PRODUTO LIKE '%Vaio%' THEN 'Vaio'
        WHEN A.NOME_PRODUTO LIKE '%Canon%' THEN 'Canon'
        ELSE 'NA'
       END as MARCA_PRODUTO
  FROM ST_PRODUTO A, ST_CATEGORIA B, ST_CATEGORIA C
 WHERE A.ID_CATEGORIA = B.ID_CATEGORIA
   AND B.ID_CATEGORIA_PAI = C.ID_CATEGORIA;
COMMIT;


SELECT * FROM ST_DIM_PRODUTO;


-- ************* Conectado como usuário dw *************


-- Carregando os dados no DW

ALTER TABLE TB_FATO_VENDA MODIFY CONSTRAINT TB_FATO_VENDA_FK_CLIENTE DISABLE;
ALTER TABLE TB_FATO_VENDA MODIFY CONSTRAINT TB_FATO_VENDA_FK_DATA DISABLE;
ALTER TABLE TB_FATO_VENDA MODIFY CONSTRAINT TB_FATO_VENDA_FK_LOC DISABLE;
ALTER TABLE TB_FATO_VENDA MODIFY CONSTRAINT TB_FATO_VENDA_FK_PRO DISABLE;

TRUNCATE TABLE TB_DIM_PRODUTO;

ALTER TABLE TB_DIM_PRODUTO ADD (ID_CATEGORIA_PRODUTO INTEGER);
ALTER TABLE TB_DIM_PRODUTO ADD (ID_CATEGORIA_PAI INTEGER);
ALTER TABLE TB_DIM_PRODUTO ADD (NM_CATEGORIA_PAI VARCHAR2(20));

INSERT INTO TB_DIM_PRODUTO (SK_PRODUTO, 
	                          NK_ID_PRODUTO, 
       						          DESC_SKU, 
       						          NM_PRODUTO, 
       						          ID_CATEGORIA_PRODUTO, 
       						          NM_CATEGORIA_PRODUTO, 
       						          ID_CATEGORIA_PAI, 
       						          NM_CATEGORIA_PAI, 
       						          NM_MARCA_PRODUTO)
SELECT dim_produto_id_seq.NEXTVAL, 
       NK_ID_PRODUTO, 
       DESC_SKU, 
       NM_PRODUTO, 
       ID_CATEGORIA_PRODUTO, 
       NM_CATEGORIA_PRODUTO, 
       ID_CATEGORIA_PAI, 
       NM_CATEGORIA_PAI, 
       NM_MARCA_PRODUTO
FROM STAREA.ST_DIM_PRODUTO;
COMMIT;

TRUNCATE TABLE TB_FATO_VENDA;

INSERT INTO TB_FATO_VENDA
SELECT coalesce(B.SK_CLIENTE, -1) as SK_CLIENTE, 
       coalesce(C.SK_PRODUTO, -1) as SK_PRODUTO, 
       coalesce(D.SK_LOCALIDADE, -1) as SK_LOCALIDADE,
       TO_NUMBER(TO_CHAR(DATA_VENDA,'yyyymmdd'), '99999999') as SK_DATA,
       (A.PRECO_UNITARIO * A.QUANTIDADE) as VL_VENDA,
       A.QUANTIDADE as QTD_VENDA,
       CURRENT_DATE
FROM STAREA.ST_VENDA A LEFT JOIN TB_DIM_CLIENTE B 
  ON A.ID_CLIENTE = B.NK_ID_CLIENTE
  LEFT JOIN TB_DIM_PRODUTO C 
  ON A.ID_PRODUTO = C.NK_ID_PRODUTO
  LEFT JOIN TB_DIM_LOCALIDADE D
  ON A.ID_LOCALIDADE = D.NK_ID_LOCALIDADE;
COMMIT;

ALTER TABLE TB_FATO_VENDA MODIFY CONSTRAINT TB_FATO_VENDA_FK_CLIENTE ENABLE;
ALTER TABLE TB_FATO_VENDA MODIFY CONSTRAINT TB_FATO_VENDA_FK_DATA ENABLE;
ALTER TABLE TB_FATO_VENDA MODIFY CONSTRAINT TB_FATO_VENDA_FK_LOC ENABLE;
ALTER TABLE TB_FATO_VENDA MODIFY CONSTRAINT TB_FATO_VENDA_FK_PRO ENABLE;

SELECT
   D.NM_CATEGORIA_PAI as Categoria,
   B.NM_MES as Mes,
   B.NR_ANO as Ano,
   SUM(A.QTD_VENDA) as QTD_VENDA_TOTAL,
   SUM(A.VL_VENDA) as VL_VENDA_TOTAL
 FROM TB_FATO_VENDA A
 INNER JOIN TB_DIM_TEMPO B      ON A.SK_DATA = B.SK_DATA
 INNER JOIN TB_DIM_CLIENTE C    ON A.SK_CLIENTE = C.SK_CLIENTE
 INNER JOIN TB_DIM_PRODUTO D    ON A.SK_PRODUTO = D.SK_PRODUTO
 INNER JOIN TB_DIM_LOCALIDADE E ON A.SK_LOCALIDADE = E.SK_LOCALIDADE
 GROUP BY D.NM_CATEGORIA_PAI, B.NR_ANO, B.NM_MES
 ORDER BY SUM(A.VL_VENDA) DESC;

 
