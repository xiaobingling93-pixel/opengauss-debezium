/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

package org.full.migration.datax.model;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

/**
 * Job
 * Represents the job section in DataX configuration.
 * A job contains the global settings and a list of content configurations
 * that define the data migration tasks.
 *
 * @since 2025-04-18
 */
@Data
public class Job {
    private Setting setting;
    private List<Content> content;

    /**
     * Default constructor that initializes with default settings and empty content list.
     */
    public Job() {
        this.setting = new Setting();
        this.content = new ArrayList<>();
    }

    /**
     * Constructor with specified settings and content.
     *
     * @param setting The job settings
     * @param content The list of content configurations
     */
    public Job(Setting setting, List<Content> content) {
        this.setting = setting;
        this.content = content;
    }

    /**
     * Add a content configuration to the job.
     *
     * @param contentItem The content configuration to add
     */
    public void addContent(Content contentItem) {
        if (this.content == null) {
            this.content = new ArrayList<>();
        }
        this.content.add(contentItem);
    }

    @Override
    public String toString() {
        return "Job{setting=" + setting + ", content=" + content + '}';
    }
}