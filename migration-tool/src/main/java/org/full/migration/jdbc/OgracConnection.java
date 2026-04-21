/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.jdbc;

import org.full.migration.exception.DatabaseConnectionException;
import org.full.migration.exception.ErrorCode;
import org.full.migration.model.config.DatabaseConfig;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Locale;

/**
 * OgracConnection
 * Ograc database connection implementation
 *
 * @since 2026-03-09
 */
public class OgracConnection implements JdbcConnection {
    private static final Logger LOGGER = LoggerFactory.getLogger(OgracConnection.class);
    private static final String JDBC_URL = "jdbc:oGRAC://%s:%d";
    
    static {
        try {
            Class.forName("org.opengauss.Driver");
            LOGGER.info("oGRAC driver loaded successfully");
        } catch (ClassNotFoundException e) {
            LOGGER.error("oGRAC driver not found: {}", e.getMessage());
            throw new ExceptionInInitializerError(new DatabaseConnectionException(ErrorCode.DRIVER_LOAD_FAILED.getCode(), "Failed to load oGRAC driver", e));
        }
    }

    /**
     * Get Ograc database connection
     *
     * @param dbConfig Database configuration object
     * @return Database connection object
     * @throws SQLException SQL exception
     */
    @Override
    public Connection getConnection(DatabaseConfig dbConfig) throws SQLException {
        String sourceUrl = String.format(Locale.ROOT, JDBC_URL, dbConfig.getHost(), dbConfig.getPort());
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
        String sourceUrl = String.format(Locale.ROOT, JDBC_URL, dbConfig.getHost(), dbConfig.getPort());
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
