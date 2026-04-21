/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.datax.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * DataXConfigFactory
 * DataX configuration factory class, used to manage configuration strategies
 *
 * @since 2025-04-18
 */
public class DataXConfigFactory {
    private static final Logger LOGGER = LoggerFactory.getLogger(DataXConfigFactory.class);
    private static final DataXConfigFactory INSTANCE = new DataXConfigFactory();
    private final DataXConfigStrategy generalStrategy;

    private DataXConfigFactory() {
        generalStrategy = new GeneralDataXConfigStrategy();
        LOGGER.info("DataXConfigFactory initialized with general strategy: {}", generalStrategy.getStrategyName());
    }
    
    /**
     * Get the singleton instance of DataXConfigFactory
     * @return The singleton instance of DataXConfigFactory 
     */
    public static DataXConfigFactory getInstance() {
        return INSTANCE;
    }
    
    /**
     * Get the applicable configuration strategy for the given context
     *
     * @param context Configuration context
     * @return The applicable configuration strategy
     */
    public DataXConfigStrategy getApplicableStrategy(DataXConfigContext context) {
        LOGGER.debug("Applying general strategy: {} for table", generalStrategy.getStrategyName());
        return generalStrategy;
    }
}
