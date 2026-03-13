/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.utils;

import org.full.migration.constants.OpenGaussConstants;
import org.full.migration.enums.SqlCompatibilityEnum;
import org.full.migration.jdbc.OpenGaussConnection;
import org.full.migration.model.config.DatabaseConfig;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Locale;

/**
 * OpenGaussUtils
 *
 * @since 2026-03-13
 */
public class OpenGaussUtils {
    /**
     * Get the SQL compatibility enum from OpenGauss.
     *
     * @param databaseConfig the database config
     * @return the SQL compatibility enum
     * @throws SQLException if an SQL error occurs
     */
    public static SqlCompatibilityEnum getSqlCompatibilityEnum(DatabaseConfig databaseConfig) throws SQLException {
        OpenGaussConnection openGaussConnection = new OpenGaussConnection();
        try (Connection conn = openGaussConnection.getConnection(databaseConfig);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(OpenGaussConstants.SHOW_SQL_COMPATIBILITY)) {
            if (rs.next()) {
                String sqlCompatibility = rs.getString(1);
                return SqlCompatibilityEnum.valueOf(sqlCompatibility.toUpperCase(Locale.ROOT));
            }
            throw new SQLException("Show sql_compatibility result is empty");
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Unsupported openGauss sql_compatibility", e);
        }
    }

    /**
     * Open dolphin.sql_mode ansi_quotes.
     *
     * @param connection the openGauss connection
     * @throws SQLException if a database access error occurs
     */
    public static void openDolphinSqlModeAnsiQuotes(Connection connection) throws SQLException {
        try (Statement statement = connection.createStatement();
             ResultSet rs = statement.executeQuery(OpenGaussConstants.OPENGAUSS_SHOW_DOLPHIN_SQL_MODE)) {
            if (rs.next()) {
                String currentValue = rs.getString("dolphin.sql_mode");
                if (!currentValue.contains("ansi_quotes")) {
                    statement.executeUpdate(String.format(OpenGaussConstants.OPENGAUSS_SET_DOLPHIN_SQL_MODE_MODEL,
                            currentValue + ",ansi_quotes"));
                }
            }
        }
    }
}
