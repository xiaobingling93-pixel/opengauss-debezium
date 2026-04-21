/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.utils;

import org.full.migration.exception.DataXMigrationException;
import org.full.migration.exception.ErrorCode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * MemoryUtils
 * Utility class for memory-related operations
 *
 * @since 2026-04-18
 */
public class MemoryUtils {
    private static final Logger LOGGER = LoggerFactory.getLogger(MemoryUtils.class);
    private static final long DEFAULT_MEMORY = 1024 * 1024 * 1024; // 1GB
    private static final int MAX_WAIT_TIME = 300;
    private static final int CHECK_INTERVAL = 10;
    
    /**
     * Check if there is enough memory to execute a task
     * 
     * <pre>Implementation logic:
     * 1. Get the maximum available memory from the JVM
     * 2. Parse the JVM parameters to extract the required memory (-Xmx parameter)
     * 3. If available memory is less than required memory:
     *    a. Log a warning message
     *    b. Wait for up to 5 minutes (300 seconds) for memory to become available
     *    c. Check memory availability every 10 seconds
     *    d. If memory becomes available within the timeout, continue execution
     *    e. If memory is still insufficient after timeout, throw DataXMigrationException
     * 4. If available memory is sufficient, log an info message and continue execution
     * </pre>
     * 
     * @param jvmParameters JVM parameters for the task
     * @param taskName Task name for logging
     * @throws DataXMigrationException If there is not enough memory
     */
    public static void checkMemoryAvailability(String jvmParameters, String taskName) throws DataXMigrationException {
        long availableMemory = Runtime.getRuntime().maxMemory();
        long requiredMemory = parseRequiredMemory(jvmParameters);
        
        LOGGER.info("Checking memory availability: available={} bytes, required={} bytes for task {}", 
                availableMemory, requiredMemory, taskName);
        
        if (availableMemory < requiredMemory) {
            LOGGER.warn("Insufficient memory for task {}: available={} bytes, required={} bytes. Waiting for memory...", 
                    taskName, availableMemory, requiredMemory);
            
            int waitTime = 0;
            while (availableMemory < requiredMemory && waitTime < MAX_WAIT_TIME) {
                try {
                    Thread.sleep(CHECK_INTERVAL * 1000);
                    availableMemory = Runtime.getRuntime().maxMemory();
                    waitTime += CHECK_INTERVAL;
                    LOGGER.info("Waiting for memory: available={} bytes, required={} bytes, waited {} seconds", 
                            availableMemory, requiredMemory, waitTime);
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    throw new DataXMigrationException(ErrorCode.DATAX_EXECUTION_FAILED.getCode(), 
                            "Memory check interrupted", e);
                }
            }
            
            if (availableMemory < requiredMemory) {
                throw new DataXMigrationException(ErrorCode.DATAX_EXECUTION_FAILED.getCode(), 
                        "Insufficient memory for task " + taskName + 
                        ": available=" + availableMemory + " bytes, required=" + requiredMemory + " bytes");
            }
            
            LOGGER.info("Memory became available: available={} bytes, required={} bytes for task {}", 
                    availableMemory, requiredMemory, taskName);
        }
    }
    
    /**
     * Parse JVM parameters to get required memory in bytes
     * @param jvmParameters JVM parameters string
     * @return Required memory in bytes
     */
    private static long parseRequiredMemory(String jvmParameters) {
        long requiredMemory = 0;
        String[] params = jvmParameters.split(" ");
        
        for (String param : params) {
            if (param.startsWith("-Xmx")) {
                String memoryStr = param.substring(4);
                requiredMemory = parseMemorySize(memoryStr);
                break;
            }
        }
        
        if (requiredMemory == 0) {
            requiredMemory = DEFAULT_MEMORY;
        }
        
        return requiredMemory;
    }
    
    /**
     * Parse memory size string to bytes
     * @param memoryStr Memory size string (e.g., "512m", "2g")
     * @return Memory size in bytes
     */
    private static long parseMemorySize(String memoryStr) {
        memoryStr = memoryStr.toLowerCase();
        long multiplier = 1;
        
        if (memoryStr.endsWith("k")) {
            multiplier = 1024;
            memoryStr = memoryStr.substring(0, memoryStr.length() - 1);
        } else if (memoryStr.endsWith("m")) {
            multiplier = 1024 * 1024;
            memoryStr = memoryStr.substring(0, memoryStr.length() - 1);
        } else if (memoryStr.endsWith("g")) {
            multiplier = 1024 * 1024 * 1024;
            memoryStr = memoryStr.substring(0, memoryStr.length() - 1);
        }
        
        try {
            long size = Long.parseLong(memoryStr);
            return size * multiplier;
        } catch (NumberFormatException e) {
            LOGGER.warn("Failed to parse memory size: {}", memoryStr, e);
            return DEFAULT_MEMORY;
        }
    }
}