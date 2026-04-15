/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.test.sql;

/**
 * Provides Oracle-specific SQL statements for cleanup operations
 * This implementation is designed for Oracle databases and uses Oracle-specific
 * data dictionary views for querying database objects
 */
public class OracleSqlProvider implements DatabaseSqlProvider {
    @SuppressWarnings("unused")
    private String schema="";
    
    @Override
    public void setSchema(String schema) {
        this.schema = schema;
    }

    @Override
    public String getTriggersQuery() {
        return "SELECT trigger_name FROM user_triggers";
    }

    @Override
    public String getProceduresQuery() {
        return "SELECT object_name FROM user_objects WHERE object_type = 'PROCEDURE'";
    }

    @Override
    public String getFunctionsQuery() {
        return "SELECT object_name FROM user_objects WHERE object_type = 'FUNCTION'";
    }

    @Override
    public String getViewsQuery() {
        return "SELECT view_name FROM user_views";
    }

    @Override
    public String getIndexesQuery() {
        return "SELECT index_name FROM user_indexes WHERE table_name NOT LIKE 'BIN$%'";
    }

    @Override
    public String getTablesQuery() {
        return "SELECT table_name FROM user_tables WHERE table_name NOT LIKE 'BIN$%'";
    }

    @Override
    public String getSequencesQuery() {
        return "SELECT sequence_name FROM user_sequences";
    }

    @Override
    public String getDropTriggerSql(String triggerName) {
        return "DROP TRIGGER " + triggerName;
    }

    @Override
    public String getDropProcedureSql(String procedureName) {
        return "DROP PROCEDURE " + procedureName;
    }

    @Override
    public String getDropFunctionSql(String functionName) {
        return "DROP FUNCTION " + functionName;
    }

    @Override
    public String getDropViewSql(String viewName) {
        return "DROP VIEW " + viewName;
    }

    @Override
    public String getDropIndexSql(String indexName) {
        return "DROP INDEX " + indexName;
    }

    @Override
    public String getDropTableSql(String tableName) {
        return "DROP TABLE " + tableName + " CASCADE CONSTRAINTS";
    }

    @Override
    public String getDropSequenceSql(String sequenceName) {
        return "DROP SEQUENCE " + sequenceName;
    }
}
