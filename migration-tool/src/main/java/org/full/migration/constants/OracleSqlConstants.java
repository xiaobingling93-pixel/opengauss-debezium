/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.constants;

/**
 * OracleSqlConstants
 * Oracle database SQL constants definition
 *
 * @since 2025-04-18
 */
public class OracleSqlConstants {
    /**
     * SQL for querying tables
     */
    public static final String QUERY_TABLE_SQL = """
        SELECT t.table_name AS TableName,t.num_rows AS tableRows,
            CASE WHEN pt.table_name IS NOT NULL THEN 1 ELSE 0 END AS isPartitioned,
            CASE WHEN pk.table_name IS NOT NULL THEN 1 ELSE 0 END AS hasPrimaryKey
        FROM
            user_tables t
            LEFT JOIN user_part_tables pt ON t.table_name = pt.table_name
            LEFT JOIN (
                SELECT DISTINCT table_name FROM user_constraints WHERE constraint_type = 'P'
            ) pk ON t.table_name = pk.table_name
        WHERE t.table_name NOT LIKE 'DR$%'
        ORDER BY t.table_name
    """;

    /**
     * SQL for querying primary keys , sql parameter placeholder is  ? ,this values is oracle table owner
     * table_name,pk_name,pk_columns
     */
    public static final String QUERY_PK_SQL = """
        SELECT ucc.table_name, ucc.constraint_name AS pk_name,
               LISTAGG(ucc.column_name, ', ') WITHIN GROUP (ORDER BY ucc.position) AS pk_columns
        FROM user_cons_columns ucc
        JOIN user_constraints uc ON ucc.constraint_name = uc.constraint_name
        JOIN user_tables ut ON ucc.table_name = ut.table_name
        WHERE ucc.owner = ?  AND uc.constraint_type = 'P' AND ut.table_name NOT LIKE 'DR$%'
        GROUP BY ucc.table_name, ucc.constraint_name
        ORDER BY ucc.table_name, ucc.constraint_name
    """;

    public static final String QUERY_TB_COLUMN_SQL = """
        SELECT t.table_name,
            LISTAGG(c.column_name, ', ') WITHIN GROUP (ORDER BY c.column_id) AS tb_columns
        FROM user_tables t
        JOIN user_tab_cols c ON t.table_name = c.table_name
        WHERE t.table_name NOT LIKE 'DR$%'  AND c.virtual_column = 'NO'
        GROUP BY t.table_name
        ORDER BY t.table_name
    """;


    /**
     * SQL for querying views
     */
    public static final String QUERY_VIEW_SQL = """
        SELECT view_name, text FROM user_views ORDER BY view_name
    """;

    /**
     * SQL for querying functions
     */
    public static final String QUERY_FUNCTION_SQL = """
        SELECT object_name, dbms_metadata.get_ddl('FUNCTION', object_name) AS definition
        FROM user_objects WHERE object_type = 'FUNCTION' ORDER BY object_name
    """;

    /**
     * SQL for querying triggers
     */
    public static final String QUERY_TRIGGER_SQL = """
        SELECT trigger_name, trigger_type, triggering_event, table_name, status,
               dbms_metadata.get_ddl('TRIGGER', trigger_name) AS definition
        FROM user_triggers ORDER BY trigger_name
    """;

    /**
     * SQL for querying procedures
     */
    public static final String QUERY_PROCEDURE_SQL = """
        SELECT object_name, dbms_metadata.get_ddl('PROCEDURE', object_name) AS definition
        FROM user_objects WHERE object_type = 'PROCEDURE' ORDER BY object_name
    """;

    /**
     * SQL for querying sequences and their table relationships
     */
    public static final String QUERY_SEQUENCE_SQL = """
        SELECT s.sequence_name, s.min_value, s.max_value, s.increment_by, s.cycle_flag,
               s.order_flag, s.cache_size, s.last_number, t.table_name, c.column_name
        FROM user_sequences s
        LEFT JOIN (
            SELECT table_name, column_name,
                   DBMS_LOB.SUBSTR(TO_LOB(data_default), 4000) AS data_default_str
            FROM user_tab_columns
            WHERE data_default IS NOT NULL
        ) c ON 1=1
        LEFT JOIN user_tables t ON t.table_name = c.table_name
        WHERE c.data_default_str LIKE s.sequence_name || '.NEXTVAL'
        ORDER BY s.sequence_name
    """;



    /**
     * SQL for querying foreign keys
     */
    public static final String QUERY_FK_SQL = """
        SELECT a.constraint_name AS fk_name, a.table_name,
               LISTAGG(b.column_name, ', ') WITHIN GROUP (ORDER BY b.position) AS fk_columns,
               c.table_name AS ref_table,
               LISTAGG(d.column_name, ', ') WITHIN GROUP (ORDER BY d.position) AS ref_columns
        FROM user_constraints a
        JOIN user_cons_columns b ON a.constraint_name = b.constraint_name
        JOIN user_constraints c ON a.r_constraint_name = c.constraint_name
        JOIN user_cons_columns d ON c.constraint_name = d.constraint_name
        WHERE a.owner = ? AND a.constraint_type = 'R'
        GROUP BY a.constraint_name, a.table_name, c.table_name
        ORDER BY a.table_name, a.constraint_name
    """;

    /**
     * SQL for querying indexes
     */
    public static final String QUERY_INDEX_SQL = """
        SELECT
            i.index_name,  i.index_type AS type_desc,
            'false' AS has_filter,  NULL AS filter_definition,
            CASE WHEN i.uniqueness = 'UNIQUE' THEN 'true' ELSE 'false' END AS is_unique,
            CASE WHEN c.constraint_type = 'P' THEN 'true' ELSE 'false' END AS is_primary_key,
            CASE WHEN e.column_expression IS NOT NULL THEN 'true' ELSE 'false' END AS has_expression,
            CASE WHEN e.column_expression IS NOT NULL THEN e.column_expression ELSE null END AS index_expression,
            i.table_name, i.tablespace_name, i.status
        FROM user_indexes i
        LEFT JOIN user_constraints c ON i.index_name = c.index_name AND c.constraint_type = 'P'
        LEFT JOIN user_ind_expressions e ON i.index_name = e.index_name
        WHERE i.table_name NOT LIKE 'BIN$%' and i.table_name NOT LIKE 'DR$%'
        ORDER BY i.table_name, i.index_name
    """;

    /**
     * SQL for querying index columns
     */
    public static final String QUERY_INDEX_COL_SQL = """
        SELECT column_name FROM user_ind_columns WHERE  table_name = '%s' AND index_name = '%s'
        ORDER BY column_position
    """;


    /**
     * SQL for querying generate column define
     */
    public static final String QUERY_GENERATE_DEFINE_SQL = """
        SELECT COLUMN_NAME, DATA_DEFAULT AS EXPRESSION, VIRTUAL_COLUMN FROM USER_TAB_COLS
        WHERE TABLE_NAME = ? AND COLUMN_NAME = ?
    """;
    
    /**
     * SQL for querying unique constraints
     * sql parameter placeholder is ?, this values is oracle table owner
     */
    public static final String QUERY_UNIQUE_CONSTRAINT_SQL = """
        SELECT table_name, constraint_name, column_name AS columns
        FROM user_cons_columns
        WHERE owner = ? AND constraint_name IN
        (SELECT constraint_name FROM user_constraints WHERE owner = ? AND constraint_type = 'U')
        ORDER BY table_name, constraint_name, position
    """;
    
    /**
     * SQL for querying check constraints
     * sql parameter placeholder is ?, this values is oracle table owner
     */
    public static final String QUERY_CHECK_CONSTRAINT_SQL = """
        SELECT table_name, constraint_name, search_condition AS definition
        FROM user_constraints
        WHERE owner = ? AND constraint_type = 'C'
        ORDER BY table_name, constraint_name
    """;

    /**
     * SQL for querying partition metadata (合并多个查询为一个，减少数据库访问)
     */
    public static final String QUERY_PARTITION_METADATA_SQL = """
        SELECT 
            T.PARTITIONED,
            PT.PARTITIONING_TYPE,
            PT.INTERVAL,
            CASE WHEN pt.subpartitioning_type IS NOT NULL THEN 'YES' ELSE 'NO' END as subpartitioned,
            pt.subpartitioning_type
        FROM USER_TABLES T
        LEFT JOIN USER_PART_TABLES PT ON T.TABLE_NAME = PT.TABLE_NAME
        WHERE T.TABLE_NAME = ?
    """;

    /**
     * SQL for checking if a table is a partition child table
     */
    public static final String QUERY_PARTITION_CHILD_TABLE_SQL = """
        SELECT COUNT(*) FROM user_tab_partitions WHERE table_name = ?
    """;

    /**
     * SQL for querying partition key
     */
    public static final String QUERY_PARTITION_KEY_SQL = """
        SELECT partition_name, high_value, tablespace_name FROM user_tab_partitions
        WHERE table_name = ? ORDER BY partition_position
    """;

    /**
     * SQL for querying partition columns
     */
    public static final String QUERY_PARTITION_COLUMNS_SQL = """
        SELECT column_name  FROM user_part_key_columns WHERE name = ? ORDER BY column_position
    """;

    /**
     * SQL for querying subpartition columns
     */
    public static final String QUERY_SUBPARTITION_COLUMNS_SQL = """
        SELECT column_name
            FROM user_subpart_key_columns
            WHERE name = ?
        ORDER BY column_position
    """;

    /**
     * SQL for querying subpartitions
     */
    public static final String QUERY_SUBPARTITIONS_SQL = """
        SELECT SUBPARTITION_NAME, HIGH_VALUE
            FROM USER_TAB_SUBPARTITIONS
            WHERE TABLE_NAME = ? AND PARTITION_NAME = ?
        ORDER BY SUBPARTITION_POSITION
    """;

    /**
     * SQL for querying column char used
     */
    public static final String QUERY_COLUMN_CHAR_USED_SQL = """
        SELECT column_name, char_used FROM user_tab_columns WHERE table_name = ?
    """;

}
