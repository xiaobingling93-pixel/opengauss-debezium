/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.target;

import org.full.migration.model.PostgresCustomTypeMeta;
import org.full.migration.model.table.TableData;

import java.sql.Connection;
import java.util.List;
import java.util.Set;

/**
 * ITargetDatabase
 * Interface for target database operations during migration
 * Defines methods for creating schema objects, writing data, and managing constraints
 * 
 * @since 2025-04-18
 */
public interface ITargetDatabase {
    /**
     * Insert table snapshot information into the target database
     * 
     * @param conn      Database connection
     * @param tableData Table data information
     */
    void insertTableSnapshotInfo(Connection conn, TableData tableData);
    
    /**
     * Create schemas in the target database
     * 
     * @param schemas Set of schema names to create
     */
    void createSchemas(Set<String> schemas);
    
    /**
     * Write constraints to the target database
     */
    void writeConstraints();
    
    /**
     * Write table indexes to the target database
     */
    void writeTableIndex();
    
    /**
     * Write table primary keys to the target database
     */
    void writeTablePk();
    
    /**
     * Write table foreign keys to the target database
     */
    void writeTableFk();
    
    /**
     * Write table structure to the target database
     */
    void writeTableConstruct();
    
    /**
     * Write table data to the target database
     */
    void writeTable();
    
    /**
     * Write database objects to the target database
     * 
     * @param sourceDbType Source database type
     * @param objectType   Type of objects to write
     */
    void writeObjects(String sourceDbType, String objectType);
    
    /**
     * Drop replica schema in the target database
     */
    void dropReplicaSchema();
    
    /**
     * Create custom or domain types in the target database
     * 
     * @param customTypes List of custom type metadata
     */
    void createCustomOrDomainTypes(List<PostgresCustomTypeMeta> customTypes);
}
