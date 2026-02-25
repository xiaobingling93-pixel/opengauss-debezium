/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.model.object;

import lombok.Data;

/**
 * Procedure
 *
 * @since 2026/02/24
 */
@Data
public class Procedure {
    private String schema;
    private String name;
    private long oId;
    private String definition;
}