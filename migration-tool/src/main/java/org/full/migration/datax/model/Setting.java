/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.datax.model;

import lombok.Data;

/**
 * Setting
 * Represents the setting section in DataX configuration.
 * Contains speed and error limit settings for the DataX job.
 *
 * @since 2025-04-18
 */
@Data
public class Setting {
    private Speed speed;
    private ErrorLimit errorLimit;

    /**
     * Default constructor that initializes with default speed and error limit.
     */
    public Setting() {
        this.speed = new Speed();
        this.errorLimit = new ErrorLimit();
    }

    @Override
    public String toString() {
        return "Setting{speed=" + speed + ", errorLimit=" + errorLimit + '}';
    }
}