/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.coordinator.check;

import java.util.HashMap;
import java.util.Map;

/**
 * Factory class for creating scenario parameter check strategies
 */
public class ScenarioCheckStrategyFactory {
    private static final Map<String, ScenarioParamCheckStrategy> strategyMap = new HashMap<>();
    
    static {
        // Register all supported check strategies
        registerStrategy(new DefaultScenarioCheckStrategy());
        registerStrategy(new OracleToOgracCheckStrategy());
    }
    
    /**
     * Register a check strategy for a specific source type
     * @param strategy The check strategy instance
     */
    private static void registerStrategy(ScenarioParamCheckStrategy strategy) {
        strategyMap.put(strategy.getSupportedSourceType(), strategy);
    }
    
    /**
     * Get the check strategy for a specific source type
     * @param sourceType The source database type
     * @return The check strategy instance
     */
    public static ScenarioParamCheckStrategy getStrategy(String sourceType) {
        if (sourceType == null) {
            return strategyMap.get("default");
        }
        
        ScenarioParamCheckStrategy strategy = strategyMap.get(sourceType.toLowerCase());
        return strategy != null ? strategy : strategyMap.get("default");
    }
}