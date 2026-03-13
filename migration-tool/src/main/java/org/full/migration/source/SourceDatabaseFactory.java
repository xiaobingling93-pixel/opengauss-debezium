/*
 * Copyright (c) 2025-2025 Huawei Technologies Co.,Ltd.
 *
 * openGauss is licensed under Mulan PSL v2.
 * You can use this software according to the terms and conditions of the Mulan PSL v2.
 * You may obtain a copy of Mulan PSL v2 at:
 *
 *           http://license.coscl.org.cn/MulanPSL2
 *
 * THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
 * EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
 * MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
 * See the Mulan PSL v2 for more details.
 */

package org.full.migration.source;

import org.full.migration.enums.SqlCompatibilityEnum;
import org.full.migration.model.config.GlobalConfig;
import org.full.migration.source.opengauss.OpenGaussASource;
import org.full.migration.source.opengauss.OpenGaussBSource;
import org.full.migration.source.opengauss.OpenGaussSource;
import org.full.migration.utils.OpenGaussUtils;

import java.sql.SQLException;

/**
 * SourceDatabaseFactory
 *
 * @since 2025-04-18
 */
public class SourceDatabaseFactory {
    /**
     * getSourceDatabase
     *
     * @param dbType dbType
     * @return SourceDatabase
     */
    public static SourceDatabase getSourceDatabase(GlobalConfig globalConfig, String dbType) {
        if ("sqlserver".equals(dbType)) {
            return new SqlServerSource(globalConfig);
        } else if ("postgresql".equals(dbType)) {
            return new PostgresSource(globalConfig);
        } else if ("opengauss".equals(dbType)) {
            return createOpenGaussSource(globalConfig);
        } else {
            throw new IllegalArgumentException("Unsupported source database type: " + dbType);
        }
    }

    private static OpenGaussSource createOpenGaussSource(GlobalConfig globalConfig) {
        try {
            SqlCompatibilityEnum compatibilityEnum = OpenGaussUtils.getSqlCompatibilityEnum(
                    globalConfig.getSourceConfig().getDbConn());
            if (compatibilityEnum.equals(SqlCompatibilityEnum.A)) {
                return new OpenGaussASource(globalConfig);
            } else if (compatibilityEnum.equals(SqlCompatibilityEnum.B)) {
                return new OpenGaussBSource(globalConfig);
            } else {
                throw new RuntimeException("Unsupported source openGauss sql_compatibility: " + compatibilityEnum);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to get sql_compatibility from openGauss source", e);
        }
    }
}
