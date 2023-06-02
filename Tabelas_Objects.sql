--Escolha um Database

USE BI
GO
SELECT concat(DB_NAME(), '.', SCHEMA_NAME(t.SCHEMA_id), '.', OBJECT_NAME(t.OBJECT_ID)) AS Tabela,
       i.index_id,
       i.name                                                                          AS NomeIndice,
       i.type_desc                                                                     as Tipo,
       SUM(s.used_page_count) * 8 / 128 / 1024                                         AS TamanhoGB,
       s.row_count                                                                     as Qtd_linhas,
       i.fill_factor,
       ISNULL(u.user_seeks, 0)                                                         as Seeks,
       ISNULL(u.user_scans, 0)                                                         as Scans,
       ISNULL(u.user_lookups, 0)                                                       as Lookups,
       STUFF((SELECT ', ' + c.name
              FROM SYS.COLUMNS c
                       INNER JOIN SYS.INDEX_COLUMNS ic ON c.OBJECT_ID = ic.OBJECT_ID AND c.column_id = ic.column_id
              WHERE ic.OBJECT_ID = i.OBJECT_ID
                AND ic.index_id = i.index_id
              FOR XML PATH('')), 1, 2, '')                                             AS INCLUDED_COLUMNS
FROM SYS.TABLES t
         INNER JOIN SYS.INDEXES i ON t.OBJECT_ID = i.OBJECT_ID
         INNER JOIN sys.dm_db_partition_stats AS s ON i.object_id = s.object_id AND i.index_id = s.index_id
         LEFT JOIN sys.dm_db_index_usage_stats AS u
                   ON u.object_id = i.object_id AND u.index_id = i.index_id AND u.database_id = DB_ID()
WHERE NOT EXISTS (SELECT *
                  FROM SYS.DM_DB_INDEX_USAGE_STATS C
                  WHERE DATABASE_ID = DB_ID(DB_NAME())
                    AND i.OBJECT_ID = C.OBJECT_ID
                    AND i.index_id = C.index_id)
  AND t.is_ms_shipped = 0
  AND i.type_desc = 'NONCLUSTERED'
  AND i.name NOT LIKE '%pk%'
  AND i.name NOT LIKE '%uq%'
GROUP BY t.SCHEMA_id,
         t.OBJECT_ID,
         i.type_desc,
         i.fill_factor,
         i.name,
         i.index_id,
         i.OBJECT_ID,
         u.user_seeks,
         u.user_scans,
         u.user_lookups,
         s.row_count
ORDER BY 5 desc
go

select top 50 *
from sys.indexes
go
select top 50 *
from sys.dm_db_partition_stats
go
select top 50 *
from sys.dm_db_index_usage_stats
go

        BI01_ID_PRODUTO, BI01_DT_EMI, BI01_ID, BI01_ID_FILIAL, BI01_ANO, BI01_MES, BI01_CODIGO_TIPO, BI01_ID_GRUPO,
        BI01_ID_FORNECEDOR, BI01_ID_DEPARTAMENTO, BI01_ID_SECAO, BI01_ID_COMPRADOR, BI01_QTDE, BI01_VLR_CUSTO,
        BI01_VLR_VENDA, BI01_PCO_VENDA, BI01_ID_CLIENTE, BI01_CUSTO_MEDIO, BI01_vcl01_codupd, BI01_VLR_BONIFICACAO,
        BI01_VLR_SUBSTITUICAO, BI01_VLR_DEVOLUCAO, BI01_VLR_DESCESAS, BI01_QTDE_BONIFICACAO, BI01_VLR_JUROS,
        BI01_VLR_DESCONTO_FATURAMENTO, BI01_VLR_DESCONTO, BI01_VLR_JUROS_FATURAMENTO, BI01_CUSTO_FINAN_BONIFICACAO,
        BI01_CUSTO_BONIFICACAO_MEDIA, BI01_vcl01_vlrpst, BI01_vcl01_vlrant, BI01_ID_PRODUTO_GRUPO,
        BI01_ID_PRODUTO_SUBGRUPO
        GO
      SELECT * FROM BI.DBO.BI01_VENDA_CUSTO_LUCRO_MES