/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.datax.config;

import lombok.Data;
import org.full.migration.model.config.DatabaseConfig;
import org.full.migration.model.table.Table;

/**
 * DataXConfigContext
 * DataX configuration generation context
 * Encapsulates all parameters required for strategy generation configuration
 *
 * @since 2025-04-18
 */
@Data
public class DataXConfigContext {
    private DatabaseConfig sourceConfig;
    private DatabaseConfig targetConfig;
    private String schemaName;
    private String tableName;
    private String targetSchemaName;
    private Table table;
    private DataXCommonConfig commonConfig;
    
    /**
     * Constructor (does not set commonConfig parameter)
     */
    public DataXConfigContext(DatabaseConfig sourceConfig, DatabaseConfig targetConfig,
                             String schemaName, String tableName, String targetSchemaName,
                             Table table) {
        this.sourceConfig = sourceConfig;
        this.targetConfig = targetConfig;
        this.schemaName = schemaName;
        this.tableName = tableName;
        this.targetSchemaName = targetSchemaName;
        this.table = table;
        this.commonConfig = null;
    }
}
