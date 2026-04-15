-- Table structure test script description
-- This directory contains two main test scripts:
-- 1. oracle_normal_tables_test.sql - Normal tables test script
-- 2. oracle_partition_tables_test.sql - Partitioned tables test script

-- Usage instructions:
-- 1. First execute oracle_normal_tables_test.sql to test migration of normal tables
-- 2. Then execute oracle_partition_tables_test.sql to test migration of partitioned tables

-- oracle_normal_tables_test.sql contains the following test scenarios:
-- - Table without primary key
-- - Table with single primary key
-- - Table with auto-increment primary key (implemented using sequence and trigger)
-- - Table with composite primary key
-- - Table with foreign key (including master-slave table relationship)
-- - Table with unique constraint
-- - Table with check constraint
-- - Table with not null constraint
-- - Table with default values
-- - Table with indexes (including multiple index types)

-- oracle_partition_tables_test.sql contains the following test scenarios:
-- - Range partitioned table (partitioned by date range)
-- - Hash partitioned table (partitioned by ID hash)
-- - List partitioned table (partitioned by region list)
-- - Composite partitioned table (range-hash composite partitioning)
-- - Composite partitioned table (range-list composite partitioning)
-- - Interval partitioned table (auto-create partitions)
-- - Reference partitioned table (partitioned based on foreign key relationship)
-- - System partitioned table (application-controlled partitioning)
-- - Virtual column partitioned table (partitioned based on virtual column)
-- - Mixed partitioned table (partitioned table with indexes)

-- Notes:
-- 1. Before executing the scripts, ensure that the test_user has been created and granted appropriate permissions
-- 2. Each script contains complete test data
-- 3. The end of each script contains query statements to verify table structure and data
-- 4. To clean up test data, manually delete the relevant tables and user