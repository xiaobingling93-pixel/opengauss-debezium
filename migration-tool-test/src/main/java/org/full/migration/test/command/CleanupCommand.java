/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.test.command;

import org.apache.commons.cli.CommandLine;
import org.full.migration.test.manager.TestEnvironmentManager;

/**
 * CleanupCommand
 * Command to clean up test environment
 * Implements the TestCommand interface to provide cleanup functionality
 */
public class CleanupCommand implements TestCommand {
    @Override
    public void execute(CommandLine cmd) throws Exception {
        String configPath = cmd.getOptionValue("--config");
        TestEnvironmentManager manager = new TestEnvironmentManager(configPath);
        manager.cleanup();
    }
}