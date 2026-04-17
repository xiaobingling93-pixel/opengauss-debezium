-- 1.1 普通表（用于 B-Tree、位图、函数、反向键、虚拟列、不可见索引等）
CREATE TABLE table_index_all_normal (
    id          NUMBER PRIMARY KEY,          -- 主键自动创建唯一 B-Tree 索引
    code        VARCHAR2(10),
    status      VARCHAR2(10),
    create_date DATE,
    amount      NUMBER(12,2),
    description VARCHAR2(200)
);

-- 1.2 分区表（用于演示分区索引）
CREATE TABLE table_index_all_part (
    id          NUMBER,
    code        VARCHAR2(10),
    status      VARCHAR2(10),
    create_date DATE,
    amount      NUMBER(12,2)
)
PARTITION BY RANGE (create_date) (
    PARTITION p_2022 VALUES LESS THAN (DATE '2023-01-01'),
    PARTITION p_2023 VALUES LESS THAN (DATE '2024-01-01'),
    PARTITION p_2024 VALUES LESS THAN (DATE '2025-01-01'),
    PARTITION p_future VALUES LESS THAN (MAXVALUE)
);

-- 1.4 用于 Oracle Text 域索引的表
CREATE TABLE table_index_all_text (
    id      NUMBER PRIMARY KEY,
    content VARCHAR2(4000)
);

-- 1.5 用于位图连接索引的维度表和事实表
CREATE TABLE table_index_all_dim (
    dim_id    NUMBER PRIMARY KEY,
    dim_name  VARCHAR2(50)
);
CREATE TABLE table_index_all_fact (
    fact_id   NUMBER PRIMARY KEY,
    dim_id    NUMBER,
    measure   NUMBER
);

-- ============================================================
-- 2. 插入测试数据
-- ============================================================

-- 2.1 普通表：插入 1000 行
INSERT INTO table_index_all_normal (id, code, status, create_date, amount, description)
SELECT LEVEL,
       'CODE' || MOD(LEVEL, 100),
       CASE MOD(LEVEL, 5)
           WHEN 0 THEN 'ACTIVE'
           WHEN 1 THEN 'INACTIVE'
           ELSE 'PENDING'
       END,
       SYSDATE - MOD(LEVEL, 1000),
       DBMS_RANDOM.VALUE(1, 10000),
       'Row ' || LEVEL
FROM   DUAL
CONNECT BY LEVEL <= 1000;

-- 2.2 分区表：插入 2000 行，确保数据分布到不同分区
INSERT INTO table_index_all_part (id, code, status, create_date, amount)
SELECT LEVEL,
       'CODE' || MOD(LEVEL, 100),
       CASE MOD(LEVEL, 5)
           WHEN 0 THEN 'ACTIVE'
           WHEN 1 THEN 'INACTIVE'
           ELSE 'PENDING'
       END,
       SYSDATE - MOD(LEVEL, 2000),
       DBMS_RANDOM.VALUE(1, 10000)
FROM   DUAL
CONNECT BY LEVEL <= 2000;

-- 2.4 文本表：插入 100 行
INSERT INTO table_index_all_text (id, content)
SELECT LEVEL,
       'This is a sample text for document ' || LEVEL ||
       '. It contains words like Oracle, indexing, and testing.'
FROM   DUAL
CONNECT BY LEVEL <= 100;

-- 2.5 维度表和事实表：插入简单数据
INSERT INTO table_index_all_dim (dim_id, dim_name) VALUES (1, 'Category A');
INSERT INTO table_index_all_dim (dim_id, dim_name) VALUES (2, 'Category B');
INSERT INTO table_index_all_dim (dim_id, dim_name) VALUES (3, 'Category C');

INSERT INTO table_index_all_fact (fact_id, dim_id, measure)
SELECT LEVEL,
       MOD(LEVEL, 3) + 1,
       DBMS_RANDOM.VALUE(10, 100)
FROM   DUAL
CONNECT BY LEVEL <= 500;
COMMIT;

-- ============================================================
-- 3. 创建各类索引
-- ============================================================

-- 3.1 B-Tree 索引（普通、唯一、压缩）
CREATE INDEX idx_all_normal_btree ON table_index_all_normal(code);
-- 普通 B 树索引：CREATE INDEX ... ON 表(列1,列2) COMPRESS [n]; n：前缀列数（仅组合索引有效，n < 列数）
-- 3.2 位图索引
CREATE BITMAP INDEX idx_all_bitmap_status ON table_index_all_normal(status);

-- 3.3 基于函数的索引（普通函数索引、基于函数的位图索引）
CREATE INDEX idx_all_func_upper ON table_index_all_normal(UPPER(code));
CREATE BITMAP INDEX idx_all_func_bitmap ON table_index_all_normal(CASE WHEN status = 'ACTIVE' THEN 1 ELSE NULL END);

-- 3.4 反向键索引（解决顺序增长列的热点问题）

-- 3.5 分区索引
-- 本地分区索引（与表分区对齐）
CREATE INDEX idx_all_local_part ON table_index_all_part(create_date) LOCAL;
-- 全局非分区索引（普通索引，不分区）
CREATE INDEX idx_all_global_nopart ON table_index_all_part(code) GLOBAL;
-- 全局分区索引（按 amount 列分区）
CREATE INDEX idx_all_global_part ON table_index_all_part(amount) GLOBAL
PARTITION BY RANGE (amount) (
    PARTITION p1 VALUES LESS THAN (1000),
    PARTITION p2 VALUES LESS THAN (5000),
    PARTITION p3 VALUES LESS THAN (MAXVALUE)
);

-- 3.6 域索引（以 Oracle Text 的 CONTEXT 索引为例，需要 CTXSYS.CONTEXT 支持）
-- 若未安装 Oracle Text 或用户无 CTXAPP 权限，以下语句会失败，可注释跳过
CREATE INDEX idx_all_domain_text ON table_index_all_text(content) INDEXTYPE IS CTXSYS.CONTEXT;

-- 3.7 基于虚拟列的索引
ALTER TABLE table_index_all_normal ADD (virtual_status VARCHAR2(10) GENERATED ALWAYS AS (UPPER(status)) VIRTUAL);
CREATE INDEX idx_all_virtual ON table_index_all_normal(virtual_status);

-- 3.8 不可见索引（对优化器不可见，但 DML 仍维护）
CREATE INDEX idx_all_invisible ON table_index_all_normal(amount) INVISIBLE;
