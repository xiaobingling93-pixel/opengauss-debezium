/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.datax;

import java.util.concurrent.atomic.AtomicBoolean;

import lombok.Getter;

import java.lang.StringBuilder;
import java.lang.Process;

/**
 * Log monitoring context class to encapsulate parameters for log monitoring
 */
@Getter
public class LogMonitoringContext {
    private final String logFile;
    private final Process process;
    private final String schemaName;
    private final String tableName;
    private final AtomicBoolean success;
    private final StringBuilder errorBuilder;
    
    public LogMonitoringContext(String logFile, Process process, String schemaName, String tableName,
                               AtomicBoolean success, StringBuilder errorBuilder) {
        this.logFile = logFile;
        this.process = process;
        this.schemaName = schemaName;
        this.tableName = tableName;
        this.success = success;
        this.errorBuilder = errorBuilder;
    }
}