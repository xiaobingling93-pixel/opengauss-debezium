/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.test.sql;

/**
 * SqlProviderFactory
 * Factory class for creating database-specific SQL providers
 * This factory creates appropriate SQL provider instances based on the database type
 */
public class SqlProviderFactory {
    /**
     * Get a SQL provider instance based on the database type
     * @param dbType Database type (oracle or ograc)
     * @return DatabaseSqlProvider instance for the specified database type
     * @throws IllegalArgumentException if the database type is not supported
     */
    public static DatabaseSqlProvider getSqlProvider(String dbType) {
        if ("oracle".equals(dbType)) {
            return new OracleSqlProvider();
        } else if ("ograc".equals(dbType)) {
            return new OgracSqlProvider();
        }
        throw new IllegalArgumentException("Unsupported database type: " + dbType);
    }
}