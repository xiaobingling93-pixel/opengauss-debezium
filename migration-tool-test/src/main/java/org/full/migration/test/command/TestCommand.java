/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.test.command;

import org.apache.commons.cli.CommandLine;

/**
 * TestCommand
 * Interface for test commands
 * Defines the contract for implementing command classes that can be executed
 */
public interface TestCommand {
    /**
     * Execute the command
     * @param cmd Parsed command line arguments
     * @throws Exception if an error occurs during execution
     */
    void execute(CommandLine cmd) throws Exception;
}