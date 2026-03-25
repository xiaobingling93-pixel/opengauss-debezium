/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.datax.model;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

/**
 * ReaderParameter
 * Represents the parameter section in DataX configuration for reader.
 * Contains connection information, batch size, query timeout, and split key settings.
 *
 * @since 2025-04-18
 */
@Data
public class ReaderParameter {
    private String username;
    private String password;
    private List<Connection> connection;
    private List<String> column;
    private Integer batchSize = 1024;
    private Integer queryTimeout = 60;
    private String splitPk;

    /**
     * Default constructor that initializes with default values.
     * Default batchSize is 1024, default queryTimeout is 60 seconds.
     */
    public ReaderParameter() {
    }

    /**
     * Add a database connection to the list.
     *
     * @param conn The connection to add
     */
    public void addConnection(Connection conn) {
        if (this.connection == null) {
            this.connection = new ArrayList<>();
        }
        this.connection.add(conn);
    }

    /**
     * Add a column to the list.
     *
     * @param columnName The column name to add
     */
    public void addColumn(String columnName) {
        if (this.column == null) {
            this.column = new ArrayList<>();
        }
        this.column.add(columnName);
    }

    @Override
    public String toString() {
        return "ReaderParameter{connection=" + connection + ", column=" + column + ", batchSize=" + batchSize + ", queryTimeout=" +
                queryTimeout + ", splitPk='" + splitPk + '\'' + '}';
    }
}