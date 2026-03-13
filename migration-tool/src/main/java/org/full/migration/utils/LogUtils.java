/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.utils;

import org.full.migration.exception.MigrationException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 日志工具类
 */
public class LogUtils {
    private static final Logger LOGGER = LoggerFactory.getLogger(LogUtils.class);
    
    /**
     * 记录异常信息
     */
    public static void logException(MigrationException e) {
        // 使用结构化日志记录
        LOGGER.error("Migration error: [{}] {}, Details: {}, Cause: {}",
                e.getErrorCode(),
                e.getErrorMessage(),
                e.getDetails(),
                e.getCause() != null ? e.getCause().getMessage() : "null",
                e);
    }
    
    /**
     * 记录普通异常信息
     */
    public static void logException(Exception e) {
        LOGGER.error("Unexpected error: {}", e.getMessage(), e);
    }
}