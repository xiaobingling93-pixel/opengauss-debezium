/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.exception;

import lombok.Getter;

/**
 * MigrationException
 * Base exception class for migration tool exceptions
 */
@Getter
public class MigrationException extends Exception {
    private final String errorCode;
    private final String errorMessage;
    private final String details;
    
    /**
     * Constructor for MigrationException
     *
     * @param errorCode    Error code for the exception
     * @param errorMessage Error message for the exception
     */
    public MigrationException(String errorCode, String errorMessage) {
        super(errorMessage);
        this.errorCode = errorCode;
        this.errorMessage = errorMessage;
        this.details = "";
    }
    
    /**
     * Constructor for MigrationException with details
     *
     * @param errorCode    Error code for the exception
     * @param errorMessage Error message for the exception
     * @param details      Additional details for the exception
     */
    public MigrationException(String errorCode, String errorMessage, String details) {
        super(errorMessage);
        this.errorCode = errorCode;
        this.errorMessage = errorMessage;
        this.details = details;
    }
    
    /**
     * Constructor for MigrationException with cause
     *
     * @param errorCode    Error code for the exception
     * @param errorMessage Error message for the exception
     * @param cause        Cause of the exception
     */
    public MigrationException(String errorCode, String errorMessage, Throwable cause) {
        super(errorMessage, cause);
        this.errorCode = errorCode;
        this.errorMessage = errorMessage;
        this.details = cause.getMessage();
    }
    
    /**
     * Constructor for MigrationException with details and cause
     *
     * @param errorCode    Error code for the exception
     * @param errorMessage Error message for the exception
     * @param details      Additional details for the exception
     * @param cause        Cause of the exception
     */
    public MigrationException(String errorCode, String errorMessage, String details, Throwable cause) {
        super(errorMessage, cause);
        this.errorCode = errorCode;
        this.errorMessage = errorMessage;
        this.details = details;
    }
}