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

package org.full.migration.translator;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

/**
 * TranslatorFactory
 * Translator factory class for managing and providing various database type translators
 *
 * @since 2025-05-20
 */
public class TranslatorFactory {
    private static final Map<String, Source2TargetTranslator> translators = new HashMap<>();

    static {
        // Register supported database types and their translators
        // PostgreSQL to openGauss translator
        translators.put("postgresql", new Postgresql2OpenGaussTranslator());
        // SQL Server to openGauss translator
        translators.put("sqlserver", new SqlServer2OpenGaussTranslator());
        // openGauss to openGauss translator
        translators.put("opengauss", new OpenGauss2OpenGaussTranslator());
        // Oracle to OGRAC translator
        translators.put("oracle", new Oracle2OgracTranslator());
    }

    /**
     * Get the translator for the specified database type
     * @param dbType Database type (e.g., "postgresql", "sqlserver", "oracle")
     * @return Translator instance for the specified database type, or throws IllegalArgumentException if not supported
     */
    public static Source2TargetTranslator getTranslator(String dbType) {
        Source2TargetTranslator translator = translators.get(dbType.toLowerCase());
        if (translator == null) {
            throw new IllegalArgumentException("Unsupported database type: " + dbType);
        }
        return translator;
    }

    /**
     * Directly translate SQL (simplified call)
     * @param dbType Database type (e.g., "postgresql", "sqlserver", "oracle")
     * @param sql SQL statement to translate
     * @param isDebug Whether to enable debug mode
     * @param isCaseSensitive Whether column names are case sensitive
     * @return Translated SQL statement, or empty if translation is not supported
     */
    public static Optional<String> translate(String dbType, String sql, boolean isDebug, boolean isCaseSensitive) {
        return getTranslator(dbType).translate(sql, isDebug, isCaseSensitive);
    }
    
    /**
     * Get the translator for the specified source and target database types
     * @param sourceDbType Source database type (e.g., "postgresql", "sqlserver", "oracle")
     * @param targetDbType Target database type (e.g., "opengauss", "ograc")
     * @return Translator instance for the specified source and target database types, or throws IllegalArgumentException if not supported
     */
    public static Source2TargetTranslator getTranslator(String sourceDbType, String targetDbType) {
        // Currently only supports specific source-target database combinations
        // Future extensions can support more combinations
        Source2TargetTranslator translator = translators.get(sourceDbType.toLowerCase());
        if (translator == null) {
            throw new IllegalArgumentException("Unsupported source database type: " + sourceDbType);
        }
        
        // Check if the translator supports the target database type
        if (!translator.getTargetDatabaseType().equalsIgnoreCase(targetDbType)) {
            throw new IllegalArgumentException("Translator for " + sourceDbType + " does not support target database type: " + targetDbType);
        }
        
        return translator;
    }
}
