/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.test.sql;

/**
 * DatabaseSqlProvider
 * Provides database-specific SQL statements for cleanup operations
 */
public interface DatabaseSqlProvider {
    /**
     * Set the schema name for SQL queries
     * @param schema Schema name
     */
    void setSchema(String schema);
    
    /**
     * Get SQL query to retrieve all triggers
     * @return SQL query string
     */
    String getTriggersQuery();
    
    /**
     * Get SQL query to retrieve all procedures
     * @return SQL query string
     */
    String getProceduresQuery();
    
    /**
     * Get SQL query to retrieve all functions
     * @return SQL query string
     */
    String getFunctionsQuery();
    
    /**
     * Get SQL query to retrieve all views
     * @return SQL query string
     */
    String getViewsQuery();
    
    /**
     * Get SQL query to retrieve all indexes
     * @return SQL query string
     */
    String getIndexesQuery();
    
    /**
     * Get SQL query to retrieve all tables
     * @return SQL query string
     */
    String getTablesQuery();
    
    /**
     * Get SQL query to retrieve all sequences
     * @return SQL query string
     */
    String getSequencesQuery();
    
    /**
     * Get SQL statement to drop a trigger
     * @param triggerName Trigger name
     * @return SQL drop statement
     */
    String getDropTriggerSql(String triggerName);
    
    /**
     * Get SQL statement to drop a procedure
     * @param procedureName Procedure name
     * @return SQL drop statement
     */
    String getDropProcedureSql(String procedureName);
    
    /**
     * Get SQL statement to drop a function
     * @param functionName Function name
     * @return SQL drop statement
     */
    String getDropFunctionSql(String functionName);
    
    /**
     * Get SQL statement to drop a view
     * @param viewName View name
     * @return SQL drop statement
     */
    String getDropViewSql(String viewName);
    
    /**
     * Get SQL statement to drop an index
     * @param indexName Index name
     * @return SQL drop statement
     */
    String getDropIndexSql(String indexName);
    
    /**
     * Get SQL statement to drop a table
     * @param tableName Table name
     * @return SQL drop statement
     */
    String getDropTableSql(String tableName);
    
    /**
     * Get SQL statement to drop a sequence
     * @param sequenceName Sequence name
     * @return SQL drop statement
     */
    String getDropSequenceSql(String sequenceName);
}