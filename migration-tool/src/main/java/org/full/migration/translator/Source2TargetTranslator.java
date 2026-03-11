/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.translator;

import java.util.Optional;

/**
 * Source2TargetTranslator
 * 源数据库到目标数据库的SQL转换器接口
 * 统管各种数据库到目标数据库的转换器实现
 *
 * @since 2025-06-06
 */
public interface Source2TargetTranslator {
    /**
     * 翻译SQL语句
     * @param sqlIn 源数据库的SQL语句
     * @param isDebug 是否开启调试模式
     * @param isColumnCaseSensitive 是否区分列名大小写
     * @return 转换后的SQL语句，如果转换失败则返回Optional.empty()
     */
    Optional<String> translate(String sqlIn, boolean isDebug, boolean isColumnCaseSensitive);
    
    /**
     * 获取源数据库类型
     * @return 源数据库类型
     */
    String getSourceDatabaseType();
    
    /**
     * 获取目标数据库类型
     * @return 目标数据库类型
     */
    String getTargetDatabaseType();
}