/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.datax.model;

import lombok.Data;

/**
 * Content
 * Represents the content section in DataX configuration.
 * Each content defines a reader-writer pair for data migration,
 * specifying the source and target data configurations.
 *
 * @since 2025-04-18
 */
@Data
public class Content {
    private Reader reader;
    private Writer writer;
    
    /**
     * Default constructor that initializes with default reader and writer.
     */
    public Content() {
        this.reader = new Reader();
        this.writer = new Writer();
    }

    @Override
    public String toString() {
        return "Content{reader=" + reader + ", writer=" + writer + '}';
    }
}