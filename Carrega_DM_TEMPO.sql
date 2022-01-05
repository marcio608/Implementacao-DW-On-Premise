-- ************** Conectado como usuário dw **************

-- Carga de Dados
-- Modelo simplificado

INSERT INTO TB_DIM_TEMPO
SELECT 
 TO_CHAR(TO_DATE('31/12/2012','DD/MM/YYYY') + NUMTODSINTERVAL(n,'day'),'YYYYMMDD') AS SK_DATA,
 TO_DATE('31/12/2012','DD/MM/YYYY') + NUMTODSINTERVAL(n,'day') AS Full_Date,
 TO_CHAR(TO_DATE('31/12/2012','DD/MM/YYYY') + NUMTODSINTERVAL(n,'day'),'YYYY') AS NR_ANO,
 TO_CHAR(TO_DATE('31/12/2012','DD/MM/YYYY') + NUMTODSINTERVAL(n,'day'),'MM') AS NR_MES,
 TO_CHAR(TO_DATE('31/12/2012','DD/MM/YYYY') + NUMTODSINTERVAL(n,'day'),'Month') AS NM_MES,
 TO_CHAR(TO_DATE('31/12/2012','DD/MM/YYYY') + NUMTODSINTERVAL(n,'day'),'DD') AS NR_DIA
FROM (
 SELECT LEVEL n
 FROM dual
 CONNECT BY LEVEL <= 3291
);
COMMIT;


-- Verificando

select * from TB_DIM_TEMPO order by SK_DATA desc
