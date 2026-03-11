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

package org.full.migration.model.config;

import lombok.Data;

/**
 * DataXConfig
 * DataX配置类
 *
 * @since 2025-04-18
 */
@Data
public class DataXParamConfig {
    private String dataxHome;
    private String readerName;
    private String writerName;
    private Integer channel;
    private Integer errorRecordLimit;
    private Double errorPercentageLimit;
    private Integer readBatchSize;
    private Integer readTimeout;
    private Integer writeBatchSize;
    private Integer writeTimeout;
    private Boolean enableBatchWrite;
    private Boolean enablePrepareStatement;
    private Integer batchWriteSize;
    private Integer retryTimes;
    private Integer retryInterval;
}