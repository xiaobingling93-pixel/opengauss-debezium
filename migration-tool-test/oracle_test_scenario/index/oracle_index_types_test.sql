-- 1.1 普通表（用于 B-Tree、位图、函数、反向键、虚拟列、不可见索引等）
CREATE TABLE t_normal (
    id          NUMBER PRIMARY KEY,          -- 主键自动创建唯一 B-Tree 索引
    code        VARCHAR2(10),
    status      VARCHAR2(10),
    create_date DATE,
    amount      NUMBER(12,2),
    description VARCHAR2(200)
);

-- 1.2 反向索引测试表
CREATE TABLE t_normal_reverse (
    id          NUMBER PRIMARY KEY,          -- 主键自动创建唯一 B-Tree 索引
    code        VARCHAR2(10),
    status      VARCHAR2(10),
    create_date DATE,
    amount      NUMBER(12,2),
    description VARCHAR2(200)
);

-- 1.4 用于 Oracle Text 域索引的表
CREATE TABLE t_text (
    id      NUMBER PRIMARY KEY,
    content VARCHAR2(4000)
);

-- 1.5 用于位图连接索引的维度表和事实表
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

-- 3.1 B-Tree 索引（普通、唯一）
CREATE INDEX idx_normal_btree ON t_normal(code);
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
