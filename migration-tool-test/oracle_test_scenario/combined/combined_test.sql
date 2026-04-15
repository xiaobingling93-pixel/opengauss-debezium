-- Table structure and migration data volume combined test script
-- Test scenarios: Small table with auto-increment PK, medium table with composite PK, large range partitioned table, huge hash partitioned table, gigantic composite partitioned table, huge table without PK

-- 1. Small table with auto-increment PK (10,000 records)
CREATE SEQUENCE auto_increment_small_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE auto_increment_small_table (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    age NUMBER,
    department VARCHAR2(100)
);

CREATE OR REPLACE TRIGGER auto_increment_small_trigger
BEFORE INSERT ON auto_increment_small_table
FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        SELECT auto_increment_small_seq.NEXTVAL INTO :NEW.id FROM dual;
    END IF;
END;
/

-- 2. Medium table with composite PK (100,000 records)
CREATE TABLE composite_primary_key_medium_table (
    id1 NUMBER,
    id2 NUMBER,
    name VARCHAR2(100),
    age NUMBER,
    department VARCHAR2(100),
    PRIMARY KEY (id1, id2)
);

-- 3. Large range partitioned table (1,000,000 records)
CREATE TABLE range_partition_large_table (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    create_date DATE,
    department VARCHAR2(100)
)
PARTITION BY RANGE (create_date) (
    PARTITION p1 VALUES LESS THAN (TO_DATE('2023-01-01', 'YYYY-MM-DD')),
    PARTITION p2 VALUES LESS THAN (TO_DATE('2024-01-01', 'YYYY-MM-DD')),
    PARTITION p3 VALUES LESS THAN (TO_DATE('2025-01-01', 'YYYY-MM-DD'))
);

-- 4. Huge hash partitioned table (10,000,000 records)
CREATE TABLE hash_partition_huge_table (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    age NUMBER,
    department VARCHAR2(100)
)
PARTITION BY HASH (id) (
    PARTITION p1,
    PARTITION p2,
    PARTITION p3,
    PARTITION p4,
    PARTITION p5,
    PARTITION p6,
    PARTITION p7,
    PARTITION p8
);

-- 5. Gigantic composite partitioned table (20,000,000 records)
CREATE TABLE composite_partition_gigantic_table (
    id NUMBER,
    name VARCHAR2(100),
    create_date DATE,
    department VARCHAR2(100)
)
PARTITION BY RANGE (create_date)
SUBPARTITION BY HASH (id) (
    PARTITION p2023 VALUES LESS THAN (TO_DATE('2024-01-01', 'YYYY-MM-DD')) (
        SUBPARTITION p2023_1,
        SUBPARTITION p2023_2,
        SUBPARTITION p2023_3,
        SUBPARTITION p2023_4
    ),
    PARTITION p2024 VALUES LESS THAN (TO_DATE('2025-01-01', 'YYYY-MM-DD')) (
        SUBPARTITION p2024_1,
        SUBPARTITION p2024_2,
        SUBPARTITION p2024_3,
        SUBPARTITION p2024_4
    )
);

-- 6. Huge table without PK (10,000,000 records)
CREATE TABLE no_primary_key_huge_table (
    id NUMBER,
    name VARCHAR2(100),
    age NUMBER,
    department VARCHAR2(100),
    hire_date DATE,
    salary NUMBER
);

-- View created combined test tables
SELECT table_name FROM user_tables WHERE table_name LIKE '%_TABLE';

-- View partitioned table information
SELECT table_name, partition_name FROM user_tab_partitions WHERE table_name IN (
    'RANGE_PARTITION_LARGE_TABLE', 'HASH_PARTITION_HUGE_TABLE', 'COMPOSITE_PARTITION_GIGANTIC_TABLE'
) ORDER BY table_name, partition_name;

-- View composite partitioned table subpartition information
SELECT table_name, partition_name, subpartition_name FROM user_tab_subpartitions WHERE table_name = 'COMPOSITE_PARTITION_GIGANTIC_TABLE' ORDER BY partition_name, subpartition_name;
