-- ************** Conectado como usuário dw **************

-- Carga de Dados

INSERT INTO TB_FATO_VENDA
SELECT B.SK_CLIENTE as SK_CLIENTE, 
       C.SK_PRODUTO as SK_PRODUTO, 
       D.SK_LOCALIDADE as SK_LOCALIDADE,
       TO_NUMBER(TO_CHAR(A.DATA_VENDA,'yyyymmdd'), '99999999') as SK_DATA, -- primeiro converte o campo DATA_VENDA (tipo DATE) para uma string,
       (A.PRECO_UNITARIO * A.QUANTIDADE) as VL_VENDA,                         -- depois converte para o tipo decimal.
       A.QUANTIDADE as QTD_VENDA,
       CURRENT_DATE -- data do carregamento
FROM STAREA.ST_VENDA A, TB_DIM_CLIENTE B, TB_DIM_PRODUTO C, TB_DIM_LOCALIDADE D
WHERE A.ID_CLIENTE = B.NK_ID_CLIENTE
  AND A.ID_PRODUTO = C.NK_ID_PRODUTO
  AND A.ID_LOCALIDADE = D.NK_ID_LOCALIDADE;
COMMIT;

SELECT * FROM STAREA.ST_VENDA;

SELECT A.ID_TRANSACAO, B.SK_CLIENTE 
  FROM STAREA.ST_VENDA A, TB_DIM_CLIENTE B 
 WHERE A.ID_CLIENTE = B.NK_ID_CLIENTE;

SELECT A.ID_TRANSACAO, B.SK_CLIENTE 
  FROM STAREA.ST_VENDA A LEFT JOIN TB_DIM_CLIENTE B 
    ON A.ID_CLIENTE = B.NK_ID_CLIENTE;

INSERT INTO TB_DIM_CLIENTE VALUES(-1, -1, '<não identificado>', '<não identificado>', 0, 'NA');
COMMIT;

INSERT INTO TB_DIM_PRODUTO VALUES(-1, -1, '<não identificado>', '<não identificado>', '<não identificado>', '<não identificado>');
COMMIT;

INSERT INTO TB_DIM_LOCALIDADE VALUES(-1, -1, '<não identificado>', '<não identificado>', '<não identificado>');
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