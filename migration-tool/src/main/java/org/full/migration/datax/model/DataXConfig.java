/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.datax.model;

import lombok.Data;

/**
 * DataXConfig
 * Represents the complete DataX configuration structure.
 * This is the root class for DataX job configuration, containing the job definition
 * with its settings and content specifications.
 *
 * <p>The configuration structure follows DataX's JSON format:</p>
 * <pre>
 * {
 *   "job": {
 *     "setting": { ... },
 *     "content": [ ... ]
 *   }
 * }
 * </pre>
 *
 * @since 2025-04-18
 */
@Data
public class DataXConfig {
    private Job job;

    /**
     * Default constructor that initializes with an empty Job.
     */
    public DataXConfig() {
        this.job = new Job();
    }

    /**
     * Constructor with a specified Job.
     *
     * @param job The job configuration to use
     */
    public DataXConfig(Job job) {
        this.job = job;
    }

    @Override
    public String toString() {
        return "DataXConfig{job=" + job + '}';
    }
}