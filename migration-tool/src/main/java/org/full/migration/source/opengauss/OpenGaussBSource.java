/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.source.opengauss;

import org.full.migration.constants.OpenGaussConstants;
import org.full.migration.enums.SqlCompatibilityEnum;
import org.full.migration.model.PostgresCustomTypeMeta;
import org.full.migration.model.config.GlobalConfig;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

/**
 * OpenGaussSource for sql_compatibility B
 *
 * @since 2026-03-13
 */
public class OpenGaussBSource extends OpenGaussSource {
    public OpenGaussBSource(GlobalConfig globalConfig) {
        super(globalConfig, SqlCompatibilityEnum.B);
    }

    @Override
    protected String getDatabaseType() {
        return "opengauss_b";
    }

    @Override
    String getQueryTableSql() {
        return OpenGaussConstants.QUERY_TABLE_SQL_B;
    }

    @Override
    String filterEnumSet(String createTableSql) {
        return createTableSql.replaceAll("::\\w+\\.?\\w+,", ",");
    }

    @Override
    public List<PostgresCustomTypeMeta> queryCustomOrDomainTypes(Set<String> schemaSet) {
        return new ArrayList<>();
    }
}
