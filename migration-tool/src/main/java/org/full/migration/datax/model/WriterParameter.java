/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.datax.model;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

/**
 * WriterParameter
 * Represents the parameter section in DataX configuration for writer.
 * Contains connection information, credentials, write mode, batch settings,
 * and pre/post SQL statements.
 *
 * @since 2025-04-18
 */
@Data
public class WriterParameter {
    private List<Connection> connection;
    private String username;
    private String password;
    private String writeMode;
    private Integer batchSize = 1024;
    private Integer batchInsertSize = 1000;
    private List<String> preSql;
    private List<String> postSql;
    private List<String> column;

    /**
     * Default constructor that initializes with default values.
     * Default batchSize is 1024, default batchInsertSize is 1000.
     */
    public WriterParameter() {
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
     * Add a pre-SQL statement to the list.
     *
     * @param sql The pre-SQL statement to add
     */
    public void addPreSql(String sql) {
        if (this.preSql == null) {
            this.preSql = new ArrayList<>();
        }
        this.preSql.add(sql);
    }

    /**
     * Add a post-SQL statement to the list.
     *
     * @param sql The post-SQL statement to add
     */
    public void addPostSql(String sql) {
        if (this.postSql == null) {
            this.postSql = new ArrayList<>();
        }
        this.postSql.add(sql);
    }

    @Override
    public String toString() {
        return "WriterParameter{connection=" + connection + ", username='" + username + '\'' +
                ", password='" + (password != null ? "[REDACTED]" : null) + '\'' +
                ", writeMode='" + writeMode + '\'' + ", batchSize=" + batchSize +
                ", batchInsertSize=" + batchInsertSize + ", preSql=" + preSql + ", postSql=" + postSql + '}';
    }

    public void addColumn(String string) {
        if (this.column == null) {
            this.column = new ArrayList<>();
        }
        this.column.add(string);
    }
}