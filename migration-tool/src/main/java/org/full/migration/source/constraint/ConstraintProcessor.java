package org.full.migration.source.constraint;

import org.full.migration.exception.TranslatorException;

@FunctionalInterface
public interface ConstraintProcessor {
    String process(String tableName, String constraintName, String constraintValue) throws TranslatorException;
}
