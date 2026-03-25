/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.datax.model;

import lombok.Data;

import java.util.List;

/**
 * Connection
 * Represents the connection part in DataX configuration.
 * Holds the database connection information including JDBC URL, table names,
 * query SQL, credentials, and schema.
 *
 * @since 2025-04-18
 */
@Data
public class WriterConnection extends Connection{
    private String jdbcUrl;

    /**
     * Default constructor that initializes null for jdbcUrl, table, and querySql.
     */
    public WriterConnection() {
        super();
        this.jdbcUrl = null;
    }

    @Override
    public String toString() {
        return "WriterConnection{jdbcUrl=" + jdbcUrl +", table=" + getTable() +
                ", querySql=" + getQuerySql() +", schema='" + getSchema() + '\'' +'}';
    }
}