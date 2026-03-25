/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.datax.model;

import lombok.Data;

/**
 * ErrorLimit
 * Represents the errorLimit section in DataX configuration.
 * Defines the maximum allowed errors before a job is considered failed.
 *
 * @since 2025-04-18
 */
@Data
public class ErrorLimit {
    private int record;
    private double percentage;

    /**
     * Default constructor that initializes with 0 record limit and 0.02 (2%) percentage limit.
     */
    public ErrorLimit() {
        this.record = 0;
        this.percentage = 0.02;
    }

    /**
     * Constructor with specified error limits.
     *
     * @param record     Maximum number of error records allowed
     * @param percentage Maximum error percentage allowed (0.0 to 1.0)
     */
    public ErrorLimit(int record, double percentage) {
        this.record = record;
        this.percentage = percentage;
    }

    @Override
    public String toString() {
        return "ErrorLimit{record=" + record + ", percentage=" + percentage + '}';
    }
}