/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.model;

import lombok.Data;

/**
 * DbObject
 *
 * @since 2025-04-18
 */
@Data
public class DbObject {
    private String schema;
    private String name;
    private String definition;
}
