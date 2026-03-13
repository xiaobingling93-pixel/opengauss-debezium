/*
 * Copyright (c) 2025-2025 Huawei Technologies Co.,Ltd.
 *
 * openGauss is licensed under Mulan PSL v2.
 * You can use this software according to the terms and conditions of the Mulan PSL v2.
 * You may obtain a copy of Mulan PSL v2 at:
 *
 *           http://license.coscl.org.cn/MulanPSL2
 *
 * THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
 * EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
 * MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
 * See the Mulan PSL v2 for more details.
 */

package org.full.migration.model.table;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Table
 *
 * @since 2025-04-18
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Table {
    private String catalogName;
    private String schemaName;
    private String targetSchemaName;
    private String tableName;
    private long rowCount;
    private long totalTableSize;
    private long aveRowLength;
    private boolean isPartition;
    private boolean isSubPartition;
    private boolean hasPrimaryKey;
    private boolean hasSegment = false;

    /**
     * Constructor
     *
     * @param catalogName catalogName
     * @param schemaName schemaName
     * @param tableName tableName
     */
    public Table(String catalogName, String schemaName, String tableName) {
        this.catalogName = catalogName;
        this.schemaName = schemaName;
        this.tableName = tableName;
    }
    
    /**
     * 判断是否是分区表
     *
     * @return 是否是分区表
     */
    public boolean isPartitioned() {
        return isPartition;
    }
    
    /**
     * 获取预估行数
     *
     * @return 预估行数
     */
    public long getEstimatedRowCount() {
        return rowCount;
    }
}
