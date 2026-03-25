/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.exception;

/**
 * ConfigurationException
 * Exception thrown when there is an error in the configuration of the migration tool
 */
public class ConfigurationException extends MigrationException {
    /**
     * Constructor for ConfigurationException
     *
     * @param errorCode    Error code for the exception
     * @param errorMessage Error message for the exception
     */
    public ConfigurationException(String errorCode, String errorMessage) {
        super(errorCode, errorMessage);
    }
    
    /**
     * Constructor for ConfigurationException with details
     *
     * @param errorCode    Error code for the exception
     * @param errorMessage Error message for the exception
     * @param details      Additional details for the exception
     */
    public ConfigurationException(String errorCode, String errorMessage, String details) {
        super(errorCode, errorMessage, details);
    }
    
    /**
     * Constructor for ConfigurationException with cause
     *
     * @param errorCode    Error code for the exception
     * @param errorMessage Error message for the exception
     * @param cause        Cause of the exception
     */
    public ConfigurationException(String errorCode, String errorMessage, Throwable cause) {
        super(errorCode, errorMessage, cause);
    }
    
    /**
     * Constructor for ConfigurationException with details and cause
     *
     * @param errorCode    Error code for the exception
     * @param errorMessage Error message for the exception
     * @param details      Additional details for the exception
     * @param cause        Cause of the exception
     */
    public ConfigurationException(String errorCode, String errorMessage, String details, Throwable cause) {
        super(errorCode, errorMessage, details, cause);
    }
}