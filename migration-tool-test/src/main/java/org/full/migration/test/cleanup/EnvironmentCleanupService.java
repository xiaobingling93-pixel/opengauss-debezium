/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.test.cleanup;

import java.sql.Connection;
import java.sql.SQLException;

/**
 * EnvironmentCleanupService
 * Service interface for environment cleanup operations
 * This interface defines the contract for managing database connections
 * and cleaning up test environments in oracle2ograc migration scenarios
 */
public interface EnvironmentCleanupService {
    /**
     * Get source database connection
     * @return Source database connection
     * @throws SQLException if database connection fails
     */
    Connection getSourceConnection() throws SQLException;
    
    /**
     * Get target database connection
     * @return Target database connection
     * @throws SQLException if database connection fails
     */
    Connection getTargetConnection() throws SQLException;
    
    /**
     * Get test scenario path from configuration
     * @return Test scenario path
     */
    String getTestScenarioPath();
    
    /**
     * Get test log configuration
     * @return Test log configuration (enabled or disabled)
     */
    String getTestLog();
    
    /**
     * Get database owner from configuration
     * @return Database owner
     */
    String getOwner();
    
    /**
     * Clean up test environment
     * Cleans up all test objects from both source and target databases
     * @throws Exception if cleanup fails
     */
    void cleanup() throws Exception;
}