-- ************* Conectado como usuário system *************

GRANT CREATE VIEW TO DW;
GRANT CREATE MATERIALIZED VIEW TO DW;


-- ************* Conectado como usuário dw *************
-- Criando VIEW

CREATE VIEW vw_vendas_2021 as
SELECT
   D.NM_CATEGORIA_PAI as Categoria_Pai,
   D.NM_CATEGORIA_PRODUTO as Categoria,
   D.NM_PRODUTO as Produto,
   B.NR_DIA as Dia,
   B.NR_ANO as Ano,
   SUM(A.QTD_VENDA) as QTD_VENDA_TOTAL,
   SUM(A.VL_VENDA_TOTAL) as VL_VENDA_TOTAL
 FROM TB_FATO_VENDA A
 INNER JOIN TB_DIM_TEMPO B      ON A.SK_DATA = B.SK_DATA
 INNER JOIN TB_DIM_CLIENTE C    ON A.SK_CLIENTE = C.SK_CLIENTE
 INNER JOIN TB_DIM_PRODUTO D    ON A.SK_PRODUTO = D.SK_PRODUTO
 INNER JOIN TB_DIM_LOCALIDADE E ON A.SK_LOCALIDADE = E.SK_LOCALIDADE
 GROUP BY D.NM_CATEGORIA_PAI, D.NM_CATEGORIA_PRODUTO, D.NM_PRODUTO, B.NR_ANO, B.NR_DIA
 ORDER BY SUM(A.VL_VENDA_TOTAL) DESC;

EXPLAIN PLAN FOR
SELECT
   D.NM_CATEGORIA_PAI as Categoria_Pai,
   D.NM_CATEGORIA_PRODUTO as Categoria,
   D.NM_PRODUTO as Produto,
   B.NR_DIA as Dia,
   B.NR_ANO as Ano,
   SUM(A.QTD_VENDA) as QTD_VENDA_TOTAL,
   SUM(A.VL_VENDA_TOTAL) as VL_VENDA_TOTAL
 FROM TB_FATO_VENDA A
 INNER JOIN TB_DIM_TEMPO B      ON A.SK_DATA = B.SK_DATA
 INNER JOIN TB_DIM_CLIENTE C    ON A.SK_CLIENTE = C.SK_CLIENTE
 INNER JOIN TB_DIM_PRODUTO D    ON A.SK_PRODUTO = D.SK_PRODUTO
 INNER JOIN TB_DIM_LOCALIDADE E ON A.SK_LOCALIDADE = E.SK_LOCALIDADE
 GROUP BY D.NM_CATEGORIA_PAI, D.NM_CATEGORIA_PRODUTO, D.NM_PRODUTO, B.NR_ANO, B.NR_DIA
 ORDER BY SUM(A.VL_VENDA_TOTAL) DESC;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- Otimizando o banco de dados
 
CREATE MATERIALIZED VIEW mv_vendas_2021
   AS SELECT
   D.NM_CATEGORIA_PAI as Categoria_Pai,
   D.NM_CATEGORIA_PRODUTO as Categoria,
   D.NM_PRODUTO as Produto,
   B.NR_DIA as Dia,
   B.NR_ANO as Ano,
   SUM(A.QTD_VENDA) as QTD_VENDA_TOTAL,
   SUM(A.VL_VENDA_TOTAL) as VL_VENDA_TOTAL
 FROM TB_FATO_VENDA A
 INNER JOIN TB_DIM_TEMPO B      ON A.SK_DATA = B.SK_DATA
 INNER JOIN TB_DIM_CLIENTE C    ON A.SK_CLIENTE = C.SK_CLIENTE
 INNER JOIN TB_DIM_PRODUTO D    ON A.SK_PRODUTO = D.SK_PRODUTO
 INNER JOIN TB_DIM_LOCALIDADE E ON A.SK_LOCALIDADE = E.SK_LOCALIDADE
 GROUP BY D.NM_CATEGORIA_PAI, D.NM_CATEGORIA_PRODUTO, D.NM_PRODUTO, B.NR_ANO, B.NR_DIA
 ORDER BY SUM(A.VL_VENDA_TOTAL) DESC;

EXPLAIN PLAN FOR
SELECT * FROM mv_vendas_2021;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

EXEC DBMS_MVIEW.refresh('mv_vendas_2021');




