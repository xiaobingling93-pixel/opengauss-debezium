/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.datax.model;

import lombok.Data;

/**
 * Speed
 * Represents the speed section in DataX configuration.
 * Controls the concurrency level of data transfer through channel settings.
 *
 * @since 2025-04-18
 */
@Data
public class Speed {
    private int channel;

    /**
     * Default constructor that initializes with 3 channels.
     */
    public Speed() {
        this.channel = 3;
    }

    /**
     * Constructor with specified channel count.
     *
     * @param channel The number of concurrent channels for data transfer
     */
    public Speed(int channel) {
        this.channel = channel;
    }

    @Override
    public String toString() {
        return "Speed{channel=" + channel + '}';
    }
}