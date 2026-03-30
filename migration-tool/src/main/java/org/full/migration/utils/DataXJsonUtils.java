/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.utils;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.serializer.SerializerFeature;
import org.full.migration.datax.model.DataXConfig;
import org.full.migration.exception.DataXMigrationException;
import org.full.migration.exception.ErrorCode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * DataXJsonUtils
 * JSON serialization and deserialization utility for DataX configuration objects
 *
 * @since 2025-04-18
 */
public class DataXJsonUtils {
    private static final Logger LOGGER = LoggerFactory.getLogger(DataXJsonUtils.class);

    /**
     * Serialize DataXConfig object to formatted JSON string
     *
     * @param config DataXConfig object to serialize
     * @return JSON string representation
     * @throws DataXMigrationException DataXMigrationException
     */
    public static String toJson(DataXConfig config) throws DataXMigrationException {
        try {
            return JSON.toJSONString(config, SerializerFeature.PrettyFormat);
        } catch (Exception e) {
            LOGGER.error("Failed to serialize DataXConfig to JSON: {}", e.getMessage());
            throw new DataXMigrationException(ErrorCode.DATAX_CONFIG_ERROR.getCode(), config.toString(), e);
        }
    }
}