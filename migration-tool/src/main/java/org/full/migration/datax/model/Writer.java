/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.datax.model;

import lombok.Data;

/**
 * Writer
 * Represents the writer section in DataX configuration.
 * Defines the data target configuration including the writer plugin name
 * and connection parameters.
 *
 * @since 2025-04-18
 */
@Data
public class Writer {
    private String name;
    private WriterParameter parameter;

    /**
     * Default constructor that initializes with "gaussdbwriter" as the default plugin.
     */
    public Writer() {
        this.name = "gaussdbwriter";
        this.parameter = new WriterParameter();
    }

    /**
     * Constructor with specified name and parameter.
     *
     * @param name      The writer plugin name
     * @param parameter The writer parameters
     */
    public Writer(String name, WriterParameter parameter) {
        this.name = name;
        this.parameter = parameter;
    }

    @Override
    public String toString() {
        return "Writer{name='" + name + '\'' + ", parameter=" + parameter + '}';
    }
}