/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.model.object;

import lombok.Data;

/**
 * Sequence
 *
 * @since 2026-02-10
 */
@Data
public class Sequence {
    private String schema;
    private String name;
    private String lastValue;
    private String startValue;
    private long incrementBy;
    private String maxValue;
    private String minValue;
    private long cacheValue;
    private boolean isCycled;
    private boolean isLargeSequence;
    private String ownedTable;
    private String ownedColumn;

    /**
     * Get the owned by table and column.
     *
     * @return the owned by table and column
     */
    public String getOwnedBy() {
        if (ownedTable == null || ownedColumn == null) {
            return "NONE";
        }
        return ownedTable + "." + ownedColumn;
    }
}
