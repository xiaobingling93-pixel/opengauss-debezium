-- ============================================================
-- 脚本名称：oracle_index_types_test.sql
-- 功能描述：演示 Oracle 主要索引类型的创建与使用
-- 适用环境：Oracle 11g 及以上（部分特性可能需要更高版本）
-- 注意事项：
--   1. 运行前请确保当前用户有足够配额和权限（如 CREATE TABLE, CREATE INDEX, CTXAPP 等）
--   2. 域索引（Oracle Text）需要 Oracle Text 组件已安装，否则会报错，可注释或跳过
--   3. 脚本末尾提供清理语句，可根据需要执行
-- ============================================================

-- ============================================================
-- 1. 创建测试表
-- ============================================================

-- 1.1 普通表（用于 B-Tree、位图、函数、反向键、虚拟列、不可见索引等）
DROP TABLE t_normal PURGE;
CREATE TABLE t_normal (
    id          NUMBER PRIMARY KEY,          -- 主键自动创建唯一 B-Tree 索引
    code        VARCHAR2(10),
    status      VARCHAR2(10),
    create_date DATE,
    amount      NUMBER(12,2),
    description VARCHAR2(200)
);

-- 1.2 反向索引测试表
DROP TABLE t_normal_reverse PURGE;
CREATE TABLE t_normal_reverse (
    id          NUMBER PRIMARY KEY,          -- 主键自动创建唯一 B-Tree 索引
    code        VARCHAR2(10),
    status      VARCHAR2(10),
    create_date DATE,
    amount      NUMBER(12,2),
    description VARCHAR2(200)
);


-- 1.3 索引组织表（IOT，本身为一种特殊索引结构）
DROP TABLE t_iot PURGE;
CREATE TABLE t_iot (
    id          NUMBER PRIMARY KEY,
    code        VARCHAR2(10),
    status      VARCHAR2(10),
    amount      NUMBER(12,2)
)
ORGANIZATION INDEX;

-- 1.4 用于 Oracle Text 域索引的表
DROP TABLE t_text PURGE;
CREATE TABLE t_text (
    id      NUMBER PRIMARY KEY,
    content VARCHAR2(4000)
);

-- 1.5 用于位图连接索引的维度表和事实表
DROP TABLE t_dim PURGE;
DROP TABLE t_fact PURGE;
CREATE TABLE t_dim (
    dim_id    NUMBER PRIMARY KEY,
    dim_name  VARCHAR2(50)
);
CREATE TABLE t_fact (
    fact_id   NUMBER PRIMARY KEY,
    dim_id    NUMBER,
    measure   NUMBER
);

-- ============================================================
-- 2. 插入测试数据
-- ============================================================

-- 2.1 普通表：插入 1000 行
INSERT INTO t_normal (id, code, status, create_date, amount, description)
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

-- 2.2 反向索引测试表：插入 1000 行
INSERT INTO t_normal_reverse (id, code, status, create_date, amount, description)
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

-- 2.3 索引组织表：插入 500 行
INSERT INTO t_iot (id, code, status, amount)
SELECT LEVEL,
       'CODE' || MOD(LEVEL, 100),
       CASE MOD(LEVEL, 5) 
           WHEN 0 THEN 'ACTIVE' 
           WHEN 1 THEN 'INACTIVE' 
           ELSE 'PENDING' 
       END,
       DBMS_RANDOM.VALUE(1, 10000)
FROM   DUAL
CONNECT BY LEVEL <= 500;

-- 2.4 文本表：插入 100 行
INSERT INTO t_text (id, content)
SELECT LEVEL,
       'This is a sample text for document ' || LEVEL || 
       '. It contains words like Oracle, indexing, and testing.'
FROM   DUAL
CONNECT BY LEVEL <= 100;

-- 2.5 维度表和事实表：插入简单数据
INSERT INTO t_dim (dim_id, dim_name) VALUES (1, 'Category A');
INSERT INTO t_dim (dim_id, dim_name) VALUES (2, 'Category B');
INSERT INTO t_dim (dim_id, dim_name) VALUES (3, 'Category C');

INSERT INTO t_fact (fact_id, dim_id, measure)
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
CREATE INDEX idx_normal_btree ON t_normal(code);
-- 创建唯一索引（移除部分索引条件以提高兼容性）
CREATE UNIQUE INDEX idx_unique_code ON t_normal(code);
CREATE INDEX idx_compressed ON t_normal(create_date, status) COMPRESS 1;       -- 压缩索引

-- 3.2 位图索引
CREATE BITMAP INDEX idx_bitmap_status ON t_normal(status);

-- 3.3 基于函数的索引（普通函数索引、基于函数的位图索引）
CREATE INDEX idx_func_upper ON t_normal(UPPER(code));
CREATE BITMAP INDEX idx_func_bitmap ON t_normal(CASE WHEN status = 'ACTIVE' THEN 1 ELSE NULL END);

-- 3.4 反向键索引（解决顺序增长列的热点问题）
-- 使用专门的t_normal_reverse表创建反向键索引
CREATE INDEX idx_reverse ON t_normal_reverse(code) REVERSE;


-- 3.6 域索引（以 Oracle Text 的 CONTEXT 索引为例，需要 CTXSYS.CONTEXT 支持）
-- 若未安装 Oracle Text 或用户无 CTXAPP 权限，以下语句会失败，可注释跳过
CREATE INDEX idx_domain_text ON t_text(content) INDEXTYPE IS CTXSYS.CONTEXT;

-- 3.7 基于虚拟列的索引
ALTER TABLE t_normal ADD (virtual_status VARCHAR2(10) GENERATED ALWAYS AS (UPPER(status)) VIRTUAL);
CREATE INDEX idx_virtual ON t_normal(virtual_status);

-- 3.8 不可见索引（对优化器不可见，但 DML 仍维护）
CREATE INDEX idx_invisible ON t_normal(amount) INVISIBLE;

-- 3.9 位图连接索引（用于数据仓库星型模式）
CREATE BITMAP INDEX idx_bitmap_join ON t_fact(t_dim.dim_name)
FROM t_fact, t_dim
WHERE t_fact.dim_id = t_dim.dim_id;

-- 3.10 索引组织表（IOT）上的二级索引（普通 B-Tree）
CREATE INDEX idx_iot_secondary ON t_iot(code);

-- ============================================================
-- 4. 验证索引信息
-- ============================================================

-- 4.1 查看当前用户下所有索引的基本信息
COLUMN index_name FORMAT A30
COLUMN index_type FORMAT A20
COLUMN table_name FORMAT A30
COLUMN partitioned FORMAT A5
COLUMN visibility FORMAT A10
COLUMN revers FORMAT A5
COLUMN compression FORMAT A5
SELECT 
    i.index_name,
    i.index_type,
    i.partitioned,
    i.visibility,
    i.revers,
    i.compression,
    i.table_name
FROM user_indexes i
ORDER BY i.table_name, i.index_name;



-- 4.3 查看函数索引的表达式（如果有）
SELECT index_name, column_expression
FROM user_ind_expressions
WHERE index_name IN ('IDX_FUNC_UPPER', 'IDX_FUNC_BITMAP', 'IDX_VIRTUAL')
ORDER BY index_name;

-- ============================================================
-- 5. 可选：性能测试示例（可自行执行）
-- ============================================================
-- 示例：使用索引的查询
-- SELECT /*+ INDEX(t_normal idx_normal_btree) */ * FROM t_normal WHERE code = 'CODE5';
-- SELECT /*+ INDEX(t_normal idx_bitmap_status) */ * FROM t_normal WHERE status = 'ACTIVE';
-- SELECT * FROM t_text WHERE CONTAINS(content, 'Oracle') > 0;
-- 可根据需要执行 EXPLAIN PLAN 查看执行计划。

-- ============================================================
-- 6. 清理测试环境（如需重新运行，请取消注释）
-- ============================================================
/*
-- 删除索引（按照创建的相反顺序删除）
DROP INDEX idx_iot_secondary;
DROP INDEX idx_invisible;
DROP INDEX idx_virtual;
DROP INDEX idx_reverse;
DROP INDEX idx_func_bitmap;
DROP INDEX idx_func_upper;
DROP INDEX idx_bitmap_status;
DROP INDEX idx_compressed;
DROP INDEX idx_unique_code;
DROP INDEX idx_normal_btree;

-- 删除表
DROP TABLE t_normal PURGE;
DROP TABLE t_normal_reverse PURGE;
DROP TABLE t_iot PURGE;
DROP TABLE t_text PURGE;
DROP TABLE t_dim PURGE;
DROP TABLE t_fact PURGE;
*/