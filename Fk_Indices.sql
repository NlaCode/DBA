SELECT
       fk.name                                      AS FK,
       o.name                                       AS TABELA,
       fkc_c.name                                   AS COLUNA,
       SUM(ps.row_count)                            AS QTD_LINHAS,
       o_ref.name                                   AS REF_TABELA,
       c_ref.name                                   AS REF_COLUNA,
       SUM(ps_ref.row_count)                        AS REF_QTD_LINHAS
FROM sys.foreign_keys fk
    JOIN sys.foreign_key_columns fkc                ON fk.object_id = fkc.constraint_object_id
    JOIN sys.columns fkc_c                          ON fkc.parent_object_id = fkc_c.object_id
        AND fkc.parent_column_id = fkc_c.column_id
    LEFT JOIN sys.index_columns ic
    JOIN sys.columns c                              ON ic.object_id = c.object_id
        AND ic.column_id = c.column_id              ON fkc.parent_object_id = ic.object_id
        AND fkc.parent_column_id = ic.column_id
    JOIN sys.columns c_ref                          ON fk.referenced_object_id = c_ref.object_id
        AND fkc.referenced_column_id = c_ref.column_id
    JOIN sys.objects o                              ON o.object_id = fk.parent_object_id
    JOIN sys.objects o_ref                          ON fk.referenced_object_id = o_ref.object_id
    JOIN sys.dm_db_partition_stats ps               ON o.object_id = ps.object_id
        AND ps.index_id < 2 -- Heap ou clustered index
    JOIN sys.dm_db_partition_stats ps_ref           ON fk.referenced_object_id = ps_ref.object_id
        AND c_ref.column_id = ps_ref.index_id
WHERE
    c.name IS NULL
GROUP BY
    fk.name,
    o.name,
    fkc_c.name,
    c_ref.name,
    o_ref.name
ORDER BY
    QTD_LINHAS DESC