/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.coordinator.check;

import org.full.migration.model.config.GlobalConfig;

/**
 * Parameter check strategy for the default scenario
 * (applicable to migrations from SQL Server, PostgreSQL, etc., to openGauss)
 * 
 */
public class DefaultScenarioCheckStrategy implements ScenarioParamCheckStrategy {
    @Override
    public boolean check(GlobalConfig globalConfig, String taskType) {
        if ("table".equalsIgnoreCase(taskType)) {
            // Default scenario table migration check
            return globalConfig.getSourceConfig().isValid(taskType);
        }
        return true;
    }
    
    @Override
    public String getSupportedSourceType() {
        return "default";
    }
}