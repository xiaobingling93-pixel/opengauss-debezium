-- 分区表测试脚本
-- 测试场景：范围分区、哈希分区、列表分区、复合分区、间隔分区、引用分区、系统分区

-- 创建测试用户和表空间
-- 1. 范围分区表（按日期范围分区）
CREATE TABLE range_partition_table (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    age NUMBER,
    salary NUMBER(10,2),
    create_date DATE
)
PARTITION BY RANGE (create_date) (
    PARTITION p_2022 VALUES LESS THAN (TO_DATE('2023-01-01', 'YYYY-MM-DD')),
    PARTITION p_2023_q1 VALUES LESS THAN (TO_DATE('2023-04-01', 'YYYY-MM-DD')),
    PARTITION p_2023_q2 VALUES LESS THAN (TO_DATE('2023-07-01', 'YYYY-MM-DD')),
    PARTITION p_2023_q3 VALUES LESS THAN (TO_DATE('2023-10-01', 'YYYY-MM-DD')),
    PARTITION p_2023_q4 VALUES LESS THAN (TO_DATE('2024-01-01', 'YYYY-MM-DD')),
    PARTITION p_2024 VALUES LESS THAN (TO_DATE('2025-01-01', 'YYYY-MM-DD'))
);

-- 插入测试数据（覆盖各个分区）
BEGIN
    FOR i IN 1..1000 LOOP
        INSERT INTO range_partition_table VALUES (
            i,
            '员工' || i,
            20 + MOD(i, 40),
            5000 + MOD(i, 15000) + (i * 0.01),
            TO_DATE('2022-01-01', 'YYYY-MM-DD') + MOD(i, 800)
        );
    END LOOP;
    COMMIT;
END;
/

-- 2. 哈希分区表（按ID哈希分区）
CREATE TABLE hash_partition_table (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    age NUMBER,
    salary NUMBER(10,2),
    department VARCHAR2(50)
)
PARTITION BY HASH (id) (
    PARTITION p_hash_1,
    PARTITION p_hash_2,
    PARTITION p_hash_3,
    PARTITION p_hash_4
);

-- 插入测试数据（均匀分布到各个分区）
BEGIN
    FOR i IN 1..1000 LOOP
        INSERT INTO hash_partition_table VALUES (
            i,
            '员工' || i,
            20 + MOD(i, 40),
            5000 + MOD(i, 15000) + (i * 0.01),
            CASE MOD(i, 5)
                WHEN 0 THEN '研发部'
                WHEN 1 THEN '产品部'
                WHEN 2 THEN '设计部'
                WHEN 3 THEN '测试部'
                ELSE '运维部'
            END
        );
    END LOOP;
    COMMIT;
END;
/

-- 3. 列表分区表（按地区列表分区）
CREATE TABLE list_partition_table (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    age NUMBER,
    salary NUMBER(10,2),
    region VARCHAR2(20)
)
PARTITION BY LIST (region) (
    PARTITION p_north VALUES ('北京', '天津', '河北', '山西', '内蒙古'),
    PARTITION p_east VALUES ('上海', '江苏', '浙江', '安徽', '福建', '江西', '山东'),
    PARTITION p_south VALUES ('广东', '广西', '海南'),
    PARTITION p_west VALUES ('重庆', '四川', '贵州', '云南', '西藏'),
    PARTITION p_central VALUES ('河南', '湖北', '湖南'),
    PARTITION p_northeast VALUES ('辽宁', '吉林', '黑龙江'),
    PARTITION p_northwest VALUES ('陕西', '甘肃', '青海', '宁夏', '新疆')
);

-- 插入测试数据（覆盖各个分区）
BEGIN
    FOR i IN 1..1000 LOOP
        INSERT INTO list_partition_table VALUES (
            i,
            '员工' || i,
            20 + MOD(i, 40),
            5000 + MOD(i, 15000) + (i * 0.01),
            CASE MOD(i, 7)
                WHEN 0 THEN '北京'
                WHEN 1 THEN '上海'
                WHEN 2 THEN '广东'
                WHEN 3 THEN '四川'
                WHEN 4 THEN '湖北'
                WHEN 5 THEN '辽宁'
                ELSE '陕西'
            END
        );
    END LOOP;
    COMMIT;
END;
/

-- 4. 复合分区表（范围-哈希复合分区）
CREATE TABLE composite_range_hash_table (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    age NUMBER,
    salary NUMBER(10,2),
    create_date DATE,
    department VARCHAR2(50)
)
PARTITION BY RANGE (create_date)
SUBPARTITION BY HASH (id) (
    PARTITION p_2023 VALUES LESS THAN (TO_DATE('2024-01-01', 'YYYY-MM-DD')) (
        SUBPARTITION p_2023_hash_1,
        SUBPARTITION p_2023_hash_2
    ),
    PARTITION p_2024 VALUES LESS THAN (TO_DATE('2025-01-01', 'YYYY-MM-DD')) (
        SUBPARTITION p_2024_hash_1,
        SUBPARTITION p_2024_hash_2
    )
);

-- 插入测试数据（覆盖各个分区和子分区）
BEGIN
    FOR i IN 1..1000 LOOP
        INSERT INTO composite_range_hash_table VALUES (
            i,
            '员工' || i,
            20 + MOD(i, 40),
            5000 + MOD(i, 15000) + (i * 0.01),
            TO_DATE('2023-01-01', 'YYYY-MM-DD') + MOD(i, 700),
            CASE MOD(i, 5)
                WHEN 0 THEN '研发部'
                WHEN 1 THEN '产品部'
                WHEN 2 THEN '设计部'
                WHEN 3 THEN '测试部'
                ELSE '运维部'
            END
        );
    END LOOP;
    COMMIT;
END;
/

-- 5. 复合分区表（范围-列表复合分区）
CREATE TABLE composite_range_list_table (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    age NUMBER,
    salary NUMBER(10,2),
    create_date DATE,
    region VARCHAR2(20)
)
PARTITION BY RANGE (create_date)
SUBPARTITION BY LIST (region) (
    PARTITION p_2023 VALUES LESS THAN (TO_DATE('2024-01-01', 'YYYY-MM-DD')) (
        SUBPARTITION p_2023_north VALUES ('北京', '天津', '河北'),
        SUBPARTITION p_2023_south VALUES ('广东', '广西', '海南'),
        SUBPARTITION p_2023_east VALUES ('上海', '江苏', '浙江')
    ),
    PARTITION p_2024 VALUES LESS THAN (TO_DATE('2025-01-01', 'YYYY-MM-DD')) (
        SUBPARTITION p_2024_north VALUES ('北京', '天津', '河北'),
        SUBPARTITION p_2024_south VALUES ('广东', '广西', '海南'),
        SUBPARTITION p_2024_east VALUES ('上海', '江苏', '浙江')
    )
);

-- 插入测试数据（覆盖各个分区和子分区）
BEGIN
    FOR i IN 1..1000 LOOP
        INSERT INTO composite_range_list_table VALUES (
            i,
            '员工' || i,
            20 + MOD(i, 40),
            5000 + MOD(i, 15000) + (i * 0.01),
            TO_DATE('2023-01-01', 'YYYY-MM-DD') + MOD(i, 700),
            CASE MOD(i, 3)
                WHEN 0 THEN '北京'
                WHEN 1 THEN '广东'
                ELSE '上海'
            END
        );
    END LOOP;
    COMMIT;
END;
/

-- 6. 间隔分区表（自动创建分区）
CREATE TABLE interval_partition_table (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    age NUMBER,
    salary NUMBER(10,2),
    create_date DATE
)
PARTITION BY RANGE (create_date)
INTERVAL (NUMTOYMINTERVAL(1, 'MONTH')) (
    PARTITION p_initial VALUES LESS THAN (TO_DATE('2023-01-01', 'YYYY-MM-DD'))
);

-- 插入测试数据（触发自动创建分区）
BEGIN
    FOR i IN 1..1000 LOOP
        INSERT INTO interval_partition_table VALUES (
            i,
            '员工' || i,
            20 + MOD(i, 40),
            5000 + MOD(i, 15000) + (i * 0.01),
            TO_DATE('2023-01-01', 'YYYY-MM-DD') + MOD(i, 365)
        );
    END LOOP;
    COMMIT;
END;
/

-- 7. 引用分区表（基于外键关系分区）
CREATE TABLE parent_table (
    parent_id NUMBER PRIMARY KEY,
    parent_name VARCHAR2(100),
    create_date DATE
)
PARTITION BY RANGE (create_date) (
    PARTITION p_2023 VALUES LESS THAN (TO_DATE('2024-01-01', 'YYYY-MM-DD')),
    PARTITION p_2024 VALUES LESS THAN (TO_DATE('2025-01-01', 'YYYY-MM-DD'))
);

CREATE TABLE child_table (
    child_id NUMBER PRIMARY KEY,
    parent_id NUMBER,
    child_name VARCHAR2(100),
    amount NUMBER(10,2),
    CONSTRAINT fk_parent FOREIGN KEY (parent_id) REFERENCES parent_table(parent_id)
)
PARTITION BY REFERENCE (fk_parent);

-- 插入父表数据
BEGIN
    FOR i IN 1..100 LOOP
        INSERT INTO parent_table VALUES (
            i,
            '父记录' || i,
            TO_DATE('2023-01-01', 'YYYY-MM-DD') + MOD(i, 500)
        );
    END LOOP;
    COMMIT;
END;
/

-- 插入子表数据（自动继承父表的分区）
BEGIN
    FOR i IN 1..1000 LOOP
        INSERT INTO child_table VALUES (
            i,
            1 + MOD(i, 100),
            '子记录' || i,
            1000 + MOD(i, 5000) + (i * 0.01)
        );
    END LOOP;
    COMMIT;
END;
/

-- 8. 系统分区表（应用程序控制分区）
CREATE TABLE system_partition_table (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    age NUMBER,
    salary NUMBER(10,2),
    department VARCHAR2(50)
)
PARTITION BY SYSTEM (
    PARTITION p_system_1,
    PARTITION p_system_2,
    PARTITION p_system_3
);

-- 插入测试数据（指定分区）
BEGIN
    FOR i IN 1..1000 LOOP
        INSERT INTO system_partition_table PARTITION (
            CASE MOD(i, 3)
                WHEN 0 THEN 'p_system_1'
                WHEN 1 THEN 'p_system_2'
                ELSE 'p_system_3'
            END
        ) VALUES (
            i,
            '员工' || i,
            20 + MOD(i, 40),
            5000 + MOD(i, 15000) + (i * 0.01),
            CASE MOD(i, 5)
                WHEN 0 THEN '研发部'
                WHEN 1 THEN '产品部'
                WHEN 2 THEN '设计部'
                WHEN 3 THEN '测试部'
                ELSE '运维部'
            END
        );
    END LOOP;
    COMMIT;
END;
/

-- 9. 虚拟列分区表（基于虚拟列分区）
CREATE TABLE virtual_column_partition_table (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    birth_date DATE,
    age AS (FLOOR(MONTHS_BETWEEN(SYSDATE, birth_date) / 12)) VIRTUAL,
    salary NUMBER(10,2)
)
PARTITION BY RANGE (age) (
    PARTITION p_young VALUES LESS THAN (30),
    PARTITION p_middle VALUES LESS THAN (40),
    PARTITION p_senior VALUES LESS THAN (MAXVALUE)
);

-- 插入测试数据（虚拟列自动计算）
BEGIN
    FOR i IN 1..1000 LOOP
        INSERT INTO virtual_column_partition_table (id, name, birth_date, salary) VALUES (
            i,
            '员工' || i,
            TO_DATE('1980-01-01', 'YYYY-MM-DD') + MOD(i, 15000),
            5000 + MOD(i, 15000) + (i * 0.01)
        );
    END LOOP;
    COMMIT;
END;
/

-- 10. 混合分区表（包含索引的分区表）
CREATE TABLE indexed_partition_table (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    email VARCHAR2(100),
    age NUMBER,
    salary NUMBER(10,2),
    create_date DATE,
    department VARCHAR2(50)
)
PARTITION BY RANGE (create_date) (
    PARTITION p_2023 VALUES LESS THAN (TO_DATE('2024-01-01', 'YYYY-MM-DD')),
    PARTITION p_2024 VALUES LESS THAN (TO_DATE('2025-01-01', 'YYYY-MM-DD'))
);

-- 创建本地索引
CREATE INDEX idx_name_local ON indexed_partition_table(name) LOCAL;
CREATE INDEX idx_age_local ON indexed_partition_table(age) LOCAL;

-- 插入测试数据
BEGIN
    FOR i IN 1..1000 LOOP
        INSERT INTO indexed_partition_table VALUES (
            i,
            '员工' || i,
            'user' || LPAD(i, 6, '0') || '@example.com',
            20 + MOD(i, 40),
            5000 + MOD(i, 15000) + (i * 0.01),
            TO_DATE('2023-01-01', 'YYYY-MM-DD') + MOD(i, 700),
            CASE MOD(i, 5)
                WHEN 0 THEN '研发部'
                WHEN 1 THEN '产品部'
                WHEN 2 THEN '设计部'
                WHEN 3 THEN '测试部'
                ELSE '运维部'
            END
        );
    END LOOP;
    COMMIT;
END;
/

-- 查看创建的分区表
SELECT table_name FROM user_tables WHERE partitioned = 'YES' ORDER BY table_name;

-- 查看分区信息
SELECT table_name, partition_name, partition_position, high_value 
FROM user_tab_partitions 
WHERE table_name IN (
    'RANGE_PARTITION_TABLE', 'HASH_PARTITION_TABLE', 'LIST_PARTITION_TABLE',
    'COMPOSITE_RANGE_HASH_TABLE', 'COMPOSITE_RANGE_LIST_TABLE', 'INTERVAL_PARTITION_TABLE',
    'PARENT_TABLE', 'CHILD_TABLE', 'SYSTEM_PARTITION_TABLE', 'VIRTUAL_COLUMN_PARTITION_TABLE',
    'INDEXED_PARTITION_TABLE'
)
ORDER BY table_name, partition_position;

-- 查看子分区信息
SELECT table_name, partition_name, subpartition_name, subpartition_position
FROM user_tab_subpartitions
WHERE table_name IN ('COMPOSITE_RANGE_HASH_TABLE', 'COMPOSITE_RANGE_LIST_TABLE')
ORDER BY table_name, partition_name, subpartition_position;

-- 查看分区键信息
SELECT table_name, column_name, column_position
FROM user_part_key_columns
WHERE table_name IN (
    'RANGE_PARTITION_TABLE', 'HASH_PARTITION_TABLE', 'LIST_PARTITION_TABLE',
    'COMPOSITE_RANGE_HASH_TABLE', 'COMPOSITE_RANGE_LIST_TABLE', 'INTERVAL_PARTITION_TABLE',
    'PARENT_TABLE', 'CHILD_TABLE', 'SYSTEM_PARTITION_TABLE', 'VIRTUAL_COLUMN_PARTITION_TABLE',
    'INDEXED_PARTITION_TABLE'
)
ORDER BY table_name, column_position;

-- 查看分区表索引信息
SELECT table_name, index_name, partitioned, locality
FROM user_indexes
WHERE table_name = 'INDEXED_PARTITION_TABLE'
ORDER BY index_name;