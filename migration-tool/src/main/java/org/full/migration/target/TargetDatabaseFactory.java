/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.target;

import org.full.migration.enums.SqlCompatibilityEnum;
import org.full.migration.exception.ErrorCode;
import org.full.migration.exception.TargetDatabaseException;
import org.full.migration.model.config.DatabaseConfig;
import org.full.migration.model.config.GlobalConfig;
import org.full.migration.utils.OpenGaussUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.SQLException;

/**
 * TargetDatabaseFactory
 * Target database factory class for creating different types of target database implementations
 *
 * @since 2025-04-18
 */
public class TargetDatabaseFactory {
    private static final Logger LOGGER = LoggerFactory.getLogger(TargetDatabaseFactory.class);
    
    /**
     * getTargetDatabase
     * Create appropriate target database implementation based on source and target database types
     *
     * @param sourceDbType Source database type
     * @param targetDbType Target database type
     * @param globalConfig Global configuration
     * @return Target database implementation
     */
    public static ITargetDatabase getTargetDatabase(String sourceDbType, String targetDbType, GlobalConfig globalConfig)
            throws TargetDatabaseException {
        LOGGER.info("Creating target database for source: {}, target: {}", sourceDbType, targetDbType);
        
        // Check if DataX mode is needed
        if (isDataXScenario(sourceDbType, targetDbType)) {
            LOGGER.info("Using DataXTargetDatabase for DataX scenario");
            throw new TargetDatabaseException(ErrorCode.TARGET_DATABASE_NOT_SUPPORT.getCode(), targetDbType);
        } else {
            LOGGER.info("Using traditional TargetDatabase for CSV scenario");
            return new TargetDatabase(globalConfig, getOpenGaussSqlCompatibilityEnum(globalConfig.getOgConn()));
        }
    }
    
    /**
     * isDataXScenario
     * Determine if it's a DataX scenario
     *
     * @param sourceDbType Source database type
     * @param targetDbType Target database type
     * @return Whether it's a DataX scenario
     */
    private static boolean isDataXScenario(String sourceDbType, String targetDbType) {
        // Define scenarios that require DataX
        // 1. Oracle to Ograc migration
        if ("oracle".equalsIgnoreCase(sourceDbType) && "ograc".equalsIgnoreCase(targetDbType)) {
            return true;
        }
        // Default to traditional CSV mode
        return false;
    }

    private static SqlCompatibilityEnum getOpenGaussSqlCompatibilityEnum(DatabaseConfig databaseConfig) {
        try {
            return OpenGaussUtils.getSqlCompatibilityEnum(databaseConfig);
        } catch (SQLException e) {
            throw new RuntimeException("Failed to get sql_compatibility from openGauss target", e);
        }
    }
}
