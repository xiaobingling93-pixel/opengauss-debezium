/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.coordinator.check;

import org.full.migration.model.config.GlobalConfig;

/**
 * Interface for scenario parameter check strategies
 */
public interface ScenarioParamCheckStrategy {
    /**
     * Check if the global configuration is valid for the specified task type
     * @param globalConfig Global configuration
     * @param taskType Task type
     * @return Whether the configuration is valid
     */
    boolean check(GlobalConfig globalConfig, String taskType);
    
    /**
     * Get the source database type supported by this check strategy
     * @return The supported source database type
     */
    String getSupportedSourceType();
}