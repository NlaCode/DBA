SELECT
        OBJECT_NAME(i.object_id)            AS tabela,
        i.name                              AS indice,
        ius.user_seeks                      AS seek,
        ius.user_scans                      AS scan,
        ius.user_lookups                    AS lookups,
        ius.user_updates                    AS updates,
        CONVERT(DATE,ius.last_user_seek)    AS ult_seek,
        CONVERT(DATE,ius.last_user_scan)    AS ult_scan,
        CONVERT(DATE,ius.last_user_lookup)  AS ult_lookup,
        CONVERT(DATE, ius.last_user_update) AS ult_Update
FROM sys.dm_db_index_usage_stats    AS ius
        JOIN sys.indexes            AS i ON i.index_id = ius.index_id
            AND i.object_id = ius.object_id
WHERE
    ius.database_id = DB_ID()
    AND i.is_unique_constraint = 0 -- sem índices unique
    AND i.is_primary_key = 0
    AND i.is_disabled = 0
    AND i.type > 1                 -- não considerar índices heaps/clustered
    AND ((ius.user_seeks + ius.user_scans + ius.user_lookups) < ius.user_updates
        OR (ius.user_seeks = 0 AND ius.user_scans = 0))






