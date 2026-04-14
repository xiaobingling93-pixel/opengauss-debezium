/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.test.command;

import org.apache.commons.cli.CommandLine;
import org.full.migration.test.manager.TestEnvironmentManager;

/**
 * PrepareCommand
 * Command to prepare test environment with test data
 * Implements the TestCommand interface to provide test data preparation functionality
 */
public class PrepareCommand implements TestCommand {
    @Override
    public void execute(CommandLine cmd) throws Exception {
        String configPath = cmd.getOptionValue("--config");
        String scenario = cmd.getOptionValue("--scenario");
        if (scenario == null) {
            System.err.println("Error: Scenario is required for prepare action");
            return;
        }
        TestEnvironmentManager manager = new TestEnvironmentManager(configPath);
        manager.prepare(scenario);
    }
}