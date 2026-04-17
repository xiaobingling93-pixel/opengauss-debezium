/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.translator;

import org.full.migration.exception.TranslatorException;
import org.full.migration.model.table.Column;

import java.util.Optional;

/**
 * Source2TargetTranslator
 * SQL translator interface from source database to target database
 * Manages various database to target database translator implementations
 *
 * @since 2025-06-06
 */
public interface Source2TargetTranslator {
    /**
     * Translate SQL statement
     *
     * @param sqlIn                 Source database SQL statement
     * @param isDebug               Whether to enable debug mode
     * @param isColumnCaseSensitive Whether column names are case sensitive
     * @return Translated SQL statement, returns Optional.empty() if translation fails
     */
    Optional<String> translate(String sqlIn, boolean isDebug, boolean isColumnCaseSensitive);

    /**
     * translateColumnType
     *
     * @param tableName table name
     * @param column column to translate column type
     * @return translated column type string
     * @throws TranslatorException 
     */
    Optional<String> translateColumnType(String tableName, Column column) throws TranslatorException;

    /**
     * Get source database type
     *
     * @return Source database type
     */
    String getSourceDatabaseType();

    /**
     * Get target database type
     *
     * @return Target database type
     */
    String getTargetDatabaseType();
    
    /**
     * Translate index creation SQL statement
     *
     * @param indexType Source database index type
     * @param isDebug Whether to enable debug mode
     * @return Translated index creation SQL statement, returns Optional.empty() if translation fails
     * @throws TranslatorException 
     */
    Optional<String> translateIndex(String indexType, boolean isDebug) throws TranslatorException ;
    
    /**
     * Translate function call
     *
     * @param functionCall Source database function call
     * @param isDebug Whether to enable debug mode
     * @return Translated function call, returns Optional.empty() if translation fails
     */
    Optional<String> translateFunction(String functionCall, boolean isDebug);
}
