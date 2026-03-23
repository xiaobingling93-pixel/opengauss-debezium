/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.exception;

/**
 * Data migration exception
 */
public class DataXMigrationException extends MigrationException {
    /**
     * Constructor for DataXMigrationException
     *
     * @param errorCode    Error code for the exception
     * @param errorMessage Error message for the exception
     */
    public DataXMigrationException(String errorCode, String errorMessage) {
        super(errorCode, errorMessage);
    }
    
    /**
     * Constructor for DataXMigrationException with details
     *
     * @param errorCode    Error code for the exception
     * @param errorMessage Error message for the exception
     * @param details      Additional details for the exception
     */ 
    public DataXMigrationException(String errorCode, String errorMessage, String details) {
        super(errorCode, errorMessage, details);
    }
    
    /**
     * Constructor for DataXMigrationException with cause
     *
     * @param errorCode    Error code for the exception
     * @param errorMessage Error message for the exception
     * @param cause        Cause of the exception
     */
    public DataXMigrationException(String errorCode, String errorMessage, Throwable cause) {
        super(errorCode, errorMessage, cause);
    }
    
    /**
     * Constructor for DataXMigrationException with details and cause
     *
     * @param errorCode    Error code for the exception
     * @param errorMessage Error message for the exception
     * @param details      Additional details for the exception
     * @param cause        Cause of the exception
     */
    public DataXMigrationException(String errorCode, String errorMessage, String details, Throwable cause) {
        super(errorCode, errorMessage, details, cause);
    }
}