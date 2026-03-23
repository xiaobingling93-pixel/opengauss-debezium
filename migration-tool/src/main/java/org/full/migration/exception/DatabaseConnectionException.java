/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.exception;

/**
 * Database connection exception
 */
public class DatabaseConnectionException extends MigrationException {
    /**
     * Constructor for ConnectionException
     *
     * @param errorCode    Error code for the exception
     * @param errorMessage Error message for the exception
     */
    public DatabaseConnectionException(String errorCode, String errorMessage) {
        super(errorCode, errorMessage);
    }
    
    /**
     * Constructor for ConnectionException with details
     *
     * @param errorCode    Error code for the exception
     * @param errorMessage Error message for the exception
     * @param details      Additional details for the exception
     */
    public DatabaseConnectionException(String errorCode, String errorMessage, String details) {
        super(errorCode, errorMessage, details);
    }
    
    /**
     * Constructor for ConnectionException with cause
     *
     * @param errorCode    Error code for the exception
     * @param errorMessage Error message for the exception
     * @param cause        Cause of the exception
     */
    public DatabaseConnectionException(String errorCode, String errorMessage, Throwable cause) {
        super(errorCode, errorMessage, cause);
    }
    
    /**
     * Constructor for ConnectionException with details and cause
     *
     * @param errorCode    Error code for the exception
     * @param errorMessage Error message for the exception
     * @param details      Additional details for the exception
     * @param cause        Cause of the exception
     */
    public DatabaseConnectionException(String errorCode, String errorMessage, String details, Throwable cause) {
        super(errorCode, errorMessage, details, cause);
    }
}