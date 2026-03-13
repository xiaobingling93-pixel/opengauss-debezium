/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.strategy;

import org.full.migration.source.SourceDatabase;
import org.full.migration.target.ITargetDatabase;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * DataxTableMigration
 *
 * @since 2025-04-18
 */
public class DataxTableMigration extends MigrationStrategy {
    private static final Logger logger = LoggerFactory.getLogger(DataxTableMigration.class);

    /**
     * DataxTableMigration
     *
     * @param source source
     * @param target target
     */
    public DataxTableMigration(SourceDatabase source, ITargetDatabase target) {
        super(source, target);
    }

    @Override
    public void migration(String sourceDbType) {
        logger.info("Starting DataX-based table migration for source type: {}", sourceDbType);
    }
}
