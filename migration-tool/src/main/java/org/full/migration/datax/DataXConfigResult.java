/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.datax;

/**
 * DataXConfigResult
 * Result of DataX configuration generation
 * Contains the generated config file path and JVM parameters
 *
 * @since 2026-04-11
 */
public class DataXConfigResult {
    private final String configFile;
    private final String jvmParameters;
    
    /**
     * Constructor
     * @param configFile Path to the generated DataX configuration file
     * @param jvmParameters JVM parameters required by the strategy
     */
    public DataXConfigResult(String configFile, String jvmParameters) {
        this.configFile = configFile;
        this.jvmParameters = jvmParameters;
    }
    
    /**
     * Get the path to the generated DataX configuration file
     * @return Config file path
     */
    public String getConfigFile() {
        return configFile;
    }
    
    /**
     * Get the JVM parameters required by the strategy
     * @return JVM parameters
     */
    public String getJvmParameters() {
        return jvmParameters;
    }
}
