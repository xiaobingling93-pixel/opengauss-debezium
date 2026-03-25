/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.datax.model;

import lombok.Data;

/**
 * Reader
 * Represents the reader section in DataX configuration.
 * Defines the data source configuration including the reader plugin name
 * and connection parameters.
 *
 * @since 2025-04-18
 */
@Data
public class Reader {
    private String name;
    private ReaderParameter parameter;

    /**
     * Default constructor that initializes with "oraclereader" as the default plugin.
     */
    public Reader() {
        this.name = "oraclereader";
        this.parameter = new ReaderParameter();
    }

    /**
     * Constructor with specified name and parameter.
     *
     * @param name      The reader plugin name
     * @param parameter The reader parameters
     */
    public Reader(String name, ReaderParameter parameter) {
        this.name = name;
        this.parameter = parameter;
    }

    @Override
    public String toString() {
        return "Reader{name='" + name + '\'' + ", parameter=" + parameter + '}';
    }
}