/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.jdbc;

import org.full.migration.model.config.DatabaseConfig;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Locale;

/**
 * OpenGaussConnection
 *
 * @since 2025-04-18
 */
public class OracleConnection implements JdbcConnection {
    private static final Logger LOGGER = LoggerFactory.getLogger(OracleConnection.class);
    private static final String JDBC_URL = "jdbc:oracle:thin:@//%s:%d/%s";
    
    @Override
    public Connection getConnection(DatabaseConfig dbConfig) throws SQLException {
        String sourceUrl = String.format(Locale.ROOT, JDBC_URL, dbConfig.getHost(), dbConfig.getPort(),
            dbConfig.getDatabase());
        try {
            Connection conn = DriverManager.getConnection(sourceUrl, dbConfig.getUser(), dbConfig.getPassword());
            if (conn != null && !conn.isClosed()) {
                conn.setAutoCommit(false);
                return conn;
            } else {
                throw new SQLException("Failed to get valid connection");
            }
        } catch (SQLException e) {
            LOGGER.error("Unable to connect to database {}:{}, error message is: {}", dbConfig.getHost(),
                dbConfig.getPort(), e.getMessage());
            throw e;
        }
    }

    @Override
    public Connection retryConnection(DatabaseConfig dbConfig) throws SQLException {
        String sourceUrl = String.format(Locale.ROOT, JDBC_URL, dbConfig.getHost(), dbConfig.getPort(),
            dbConfig.getDatabase());
        Connection connection = null;
        int tryCount = 0;
        while (connection == null && tryCount < RETRY_TIME) {
            try {
                Thread.sleep(SLEEP_TIME);
                LOGGER.info("try re-connect ing");
                connection = DriverManager.getConnection(sourceUrl, dbConfig.getUser(), dbConfig.getPassword());
                if (connection != null && !connection.isClosed()) {
                    connection.setAutoCommit(false);
                } else {
                    connection = null;
                }
            } catch (SQLException | InterruptedException e) {
                LOGGER.error("Unable to connect to database {}:{}, error message is: {}", dbConfig.getHost(),
                    dbConfig.getPort(), e.getMessage());
                connection = null;
            }
            tryCount++;
        }
        return connection;
    }
}
