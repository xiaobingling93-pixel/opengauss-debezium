/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.source.opengauss;

import org.full.migration.enums.SqlCompatibilityEnum;
import org.full.migration.model.config.GlobalConfig;

/**
 * OpenGaussSource for sql_compatibility A
 *
 * @since 2026-03-13
 */
public class OpenGaussASource extends OpenGaussSource {
    public OpenGaussASource(GlobalConfig globalConfig) {
        super(globalConfig, SqlCompatibilityEnum.A);
    }
}
