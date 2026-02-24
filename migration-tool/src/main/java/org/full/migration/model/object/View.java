/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.model.object;

import lombok.Data;

/**
 * View
 *
 * @since 2026-02-12
 */
@Data
public class View {
    private String schema;
    private String name;
    private boolean isMaterialized;
    private boolean isIncremental;
    private String definition;
}
