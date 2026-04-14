-- Oracle 所有数据类型测试脚本
-- 覆盖Oracle指定数据类型的全部测试场景
-- 基于Oracle官方文档数据类型规范

-------------------------------------------------------------------------------
-- 1. 数值类型测试表
-------------------------------------------------------------------------------

-- 1.1 整数类型测试表
CREATE TABLE integer_types_test (
    id NUMBER PRIMARY KEY,
    -- 整数类型
    int_col INTEGER,                 -- 整数类型
    int_alias INT,                   -- INTEGER的别名
    smallint_col SMALLINT,            -- 小整数类型
    -- NUMBER类型作为整数
    num_int NUMBER(10),              -- 精度10的整数
    num_prec_38_0 NUMBER(38,0)      -- 最大精度整数
);

-- 插入整数类型测试数据
INSERT INTO integer_types_test VALUES (
    1, 12345, 67890, 999, 1234567890, 99999999999999999999999999999999999999
);

-- 1.2 定点数类型测试表
CREATE TABLE decimal_types_test (
    id NUMBER PRIMARY KEY,
    -- 定点数类型
    num_default NUMBER,              -- 默认精度
    num_prec_5_2 NUMBER(5,2),        -- 精度5，小数位2
    num_prec_8_2 NUMBER(8,2),        -- 精度8，小数位2
    num_prec_10_5 NUMBER(10,5),      -- 精度10，小数位5
    num_prec_15_10 NUMBER(15,10),    -- 精度15，小数位10
    num_prec_38_10 NUMBER(38,10),    -- 最大精度带小数
    -- 测试负小数位
    num_neg_scale NUMBER(10,-2)       -- 负小数位（允许）
);

-- 插入定点数类型测试数据
INSERT INTO decimal_types_test VALUES (
    1, 12345.6789, 123.45, 12345.67, 12345.67890, 99999.9999999999,
    9999999999999999999999999999.9999999999, 1234500
);
-- 1.3 浮点数类型测试表
CREATE TABLE float_types_test (
    id NUMBER PRIMARY KEY,
    -- 浮点数类型
    float_default FLOAT,             -- 默认精度浮点数
    float_prec_1 FLOAT(1),           -- 最小精度浮点数
    float_prec_5 FLOAT(5),           -- 精度5位二进制的浮点数
    float_prec_63 FLOAT(63),         -- 中等精度浮点数
    float_prec_126 FLOAT(126),       -- 最大精度浮点数
    double_col DOUBLE PRECISION       -- 双精度浮点数
);

-- 插入浮点数类型测试数据
INSERT INTO float_types_test VALUES (
    1, 123.45, 123.45, 123.45, 123.45, 123.45, 123.456789
);

-- 1.4 二进制浮点类型测试表
CREATE TABLE binary_float_types_test (
    id NUMBER PRIMARY KEY,
    -- 二进制浮点类型
    binary_float_col BINARY_FLOAT,   -- 32位单精度浮点数 (IEEE 754)
    binary_double_col BINARY_DOUBLE, -- 64位双精度浮点数 (IEEE 754)
    real_col REAL,                   -- 等同于 BINARY_FLOAT
    double_precision_col DOUBLE PRECISION  -- 等同于 BINARY_DOUBLE
);

-- 插入二进制浮点类型测试数据
INSERT INTO binary_float_types_test VALUES (
    1, 123.45, 123.456789, 123.45, 123.456789
);

-------------------------------------------------------------------------------
-- 2. 字符类型测试表
-------------------------------------------------------------------------------

-- 2.1 基本字符类型测试表
CREATE TABLE basic_character_types_test (
    id NUMBER PRIMARY KEY,
    
    char_default CHAR,              
    char_col CHAR(10),            
    char_byte CHAR(10 BYTE),        
    char_char CHAR(10 CHAR),      
    char_max CHAR(2000),          
    
    varchar2_col VARCHAR2(100),    
    varchar2_byte VARCHAR2(100 BYTE), 
    varchar2_char VARCHAR2(100 CHAR),
    varchar2_max VARCHAR2(4000)    
);

-- 插入基本字符类型测试数据
INSERT INTO basic_character_types_test VALUES (
    1, 'A', 'Fixed', 'Byte', 'Char', RPAD('A', 2000, 'A'),
    'Variable', 'VarByte', 'VarChar', RPAD('B', 4000, 'B')
);

-- 2.2 国家字符类型测试表
CREATE TABLE national_character_types_test (
    -- 国家字符集
    id NUMBER PRIMARY KEY,
    nchar_default NCHAR,             -- 默认长度NCHAR(1)
    nchar_col NCHAR(10),            -- 固定长度国家字符
    nchar_max NCHAR(1000),          -- 最大长度NCHAR
    nvarchar2_col NVARCHAR2(100),   -- 可变长度国家字符
    nvarchar2_max NVARCHAR2(2000)   -- 最大长度NVARCHAR2
);

-- 插入国家字符类型测试数据
INSERT INTO national_character_types_test VALUES (
    1, N'中', N'国家字符', N'国家字符' || RPAD('中', 990, '中'), 
    N'可变国家字符', N'可变国家字符' || RPAD('文', 1990, '文')
);

-- 2.3 大字符对象测试表
CREATE TABLE lob_character_types_test (
    -- 大字符对象
    id NUMBER PRIMARY KEY,
    clob_col CLOB,                   -- 字符大对象，最大(4GB-1)*数据库块大小
    nclob_col NCLOB,                 -- 国家字符集大对象
    long_col LONG                    -- 长字符串，最大2GB（已过时，建议使用CLOB）
);

-- 插入大字符对象测试数据
DECLARE
    v_clob CLOB;
    v_nclob NCLOB;
BEGIN
    -- 插入基础数据
    INSERT INTO lob_character_types_test (id, clob_col, nclob_col, long_col)
    VALUES (1, 'This is a CLOB test', '这是一个NCLOB测试', 'This is a LONG string test ' || RPAD('Y', 1000, 'Y'));
    
    -- 直接更新CLOB和NCLOB列
    UPDATE lob_character_types_test
    SET clob_col = 'This is a CLOB test with multiple lines
Line 1
Line 2
Line 3
' || RPAD('X', 1000, 'X'),
        nclob_col = N'这是一个NCLOB测试，包含中文字符
Line 1
Line 2
Line 3
' || RPAD(N'中', 500, N'中')
    WHERE id = 1;
    
    COMMIT;
END;
/

-------------------------------------------------------------------------------
-- 3. 日期类型测试表
-------------------------------------------------------------------------------
CREATE TABLE date_types_test (
    -- 基本日期类型
    id NUMBER PRIMARY KEY,
    
    -- 日期类型
    date_col DATE,                    -- 日期类型，范围：公元前4712年1月1日到公元9999年12月31日
    
    -- TIMESTAMP类型，带不同精度
    timestamp_default TIMESTAMP,              -- 默认精度（6位小数秒）
    timestamp_prec_0 TIMESTAMP(0),            -- 0位小数秒
    timestamp_prec_3 TIMESTAMP(3),            -- 3位小数秒
    timestamp_prec_6 TIMESTAMP(6),            -- 6位小数秒
    timestamp_prec_9 TIMESTAMP(9),            -- 9位小数秒（最大精度）
    
    -- 带时区的TIMESTAMP类型
    timestamp_tz_default TIMESTAMP WITH TIME ZONE,            -- 默认精度带时区
    timestamp_tz_prec_6 TIMESTAMP(6) WITH TIME ZONE,          -- 6位小数秒带时区
    
    -- 带本地时区的TIMESTAMP类型
    timestamp_ltz_default TIMESTAMP WITH LOCAL TIME ZONE,     -- 默认精度带本地时区
    timestamp_ltz_prec_6 TIMESTAMP(6) WITH LOCAL TIME ZONE    -- 6位小数秒带本地时区
);

-- 插入日期类型测试数据
INSERT INTO date_types_test VALUES (
    1, SYSDATE, SYSTIMESTAMP, SYSTIMESTAMP, SYSTIMESTAMP, SYSTIMESTAMP, SYSTIMESTAMP,
    SYSTIMESTAMP, SYSTIMESTAMP, SYSTIMESTAMP, SYSTIMESTAMP
);

-------------------------------------------------------------------------------
-- 4. 二进制类型测试表
-------------------------------------------------------------------------------
CREATE TABLE binary_types_test (
    -- 基本二进制类型
    id NUMBER PRIMARY KEY,
    
    -- 二进制大对象
    blob_col BLOB,                   -- 二进制大对象，最大(4GB-1)*数据库块大小
    
    -- 原始二进制数据
    raw_col RAW(100),                -- 原始二进制数据
    raw_max RAW(2000),               -- 最大长度RAW
    
    -- 长原始二进制数据
    long_raw_col LONG RAW            -- 长原始二进制数据，最大2GB（已过时，建议使用BLOB）
);

-- 插入二进制类型测试数据
INSERT INTO binary_types_test VALUES (
    1, 
    TO_BLOB('48454C4C4F'),           -- 'HELLO'的十六进制表示
    HEXTORAW('48454C4C4F'),          -- 'HELLO'的十六进制表示
    HEXTORAW(RPAD('48454C4C4F', 4000, '41')),  -- 最大长度RAW
    HEXTORAW('48454C4C4F')           -- 'HELLO'的十六进制表示
);

-------------------------------------------------------------------------------
-- 5. 布尔类型测试表
-------------------------------------------------------------------------------
CREATE TABLE boolean_type_test (
    -- Boolean type (Oracle doesn't support BOOLEAN, use NUMBER(1) instead)
    id NUMBER PRIMARY KEY,
    bool_col NUMBER(1)                 -- Boolean type: 0=FALSE, 1=TRUE
);

-- 插入布尔类型测试数据
INSERT INTO boolean_type_test VALUES (1, 1);
INSERT INTO boolean_type_test VALUES (2, 0);

-------------------------------------------------------------------------------
-- 6. 特殊类型测试表
-------------------------------------------------------------------------------
CREATE TABLE special_types_test (
    -- 特殊类型
    id NUMBER PRIMARY KEY,
    
    -- 间隔类型
    interval_ym_col INTERVAL YEAR TO MONTH,  -- 年到月的间隔，年精度默认2
    interval_ym_prec_3 INTERVAL YEAR(3) TO MONTH,  -- 年精度3
    interval_ym_prec_9 INTERVAL YEAR(9) TO MONTH,  -- 年精度9（最大精度）
    interval_ds_col INTERVAL DAY TO SECOND,  -- 天到秒的间隔，天精度默认2，小数秒精度默认6
    interval_ds_prec_3_9 INTERVAL DAY(3) TO SECOND(9)  -- 天精度3，小数秒精度9
);

-- 插入特殊类型测试数据
--   INTERVAL '1-6' YEAR TO MONTH,     -- 1年6个月
--    INTERVAL '123-6' YEAR(3) TO MONTH,  -- 123年6个月
--    INTERVAL '999-6' YEAR(9) TO MONTH,  -- 999年6个月（最大精度）
--    INTERVAL '2 10:30:45' DAY TO SECOND,  -- 2天10小时30分45秒
--    INTERVAL '123 10:30:45.123456789' DAY(3) TO SECOND(9)  -- 123天10小时30分45.123456789秒
INSERT INTO special_types_test VALUES (
    1, 
    INTERVAL '1-6' YEAR TO MONTH,  
    INTERVAL '123-6' YEAR(3) TO MONTH,
    INTERVAL '999-6' YEAR(9) TO MONTH,
    INTERVAL '2 10:30:45' DAY TO SECOND,
    INTERVAL '123 10:30:45.123456789' DAY(3) TO SECOND(9)
);

-- 测试默认精度
INSERT INTO special_types_test VALUES (
    2,
    INTERVAL '0-0' YEAR TO MONTH,  -- 最小值
    INTERVAL '0-0' YEAR(3) TO MONTH,
    INTERVAL '0-0' YEAR(9) TO MONTH,
    INTERVAL '0 0:0:0' DAY TO SECOND,  -- 最小值
    INTERVAL '0 0:0:0' DAY(3) TO SECOND(9)
);

-- 测试边界值
INSERT INTO special_types_test VALUES (
    3,
    INTERVAL '99-11' YEAR TO MONTH,  -- 最大年月（默认精度2）
    INTERVAL '999-11' YEAR(3) TO MONTH,  -- 最大年月（精度3）
    INTERVAL '999999999-11' YEAR(9) TO MONTH,  -- 最大年月（精度9）
    INTERVAL '99 23:59:59.999999' DAY TO SECOND,  -- 最大天秒（默认精度2）
    INTERVAL '999 23:59:59.999999999' DAY(3) TO SECOND(9)  -- 最大天秒（精度3）
);
-------------------------------------------------------------------------------
-- 7. XML类型测试表
-------------------------------------------------------------------------------
CREATE TABLE xml_types_test (
    -- XML类型
    id NUMBER PRIMARY KEY,
    xml_col XMLTYPE                   -- XML数据类型，支持XML操作和查询
);

-- 插入XML类型测试数据
INSERT INTO xml_types_test VALUES (
    1, 
    XMLTYPE('<root><person><name>John</name><age>30</age></person></root>')
);

-------------------------------------------------------------------------------
-- 8. JSON类型测试表
-------------------------------------------------------------------------------
CREATE TABLE json_types_test (
    -- JSON类型
    id NUMBER PRIMARY KEY,
    json_col JSON                     -- JSON数据类型 (Oracle 21c+)，支持JSON操作和查询
);

-- 插入JSON类型测试数据
INSERT INTO json_types_test VALUES (
    1, 
    JSON('{"name": "John", "age": 30, "address": {"city": "New York"}}')
);

-------------------------------------------------------------------------------
-- 9. BFILE类型测试表
-------------------------------------------------------------------------------
CREATE TABLE bfile_types_test (
    -- BFILE类型
    id NUMBER PRIMARY KEY,
    bfile_col BFILE                   -- BFILE类型，外部二进制文件引用，最大4GB
);

-- 注意：BFILE需要在文件系统中存在实际文件，这里仅创建表结构

-------------------------------------------------------------------------------
-- 10. ANYDATA类型测试表
-------------------------------------------------------------------------------
CREATE TABLE anydata_types_test (
    -- ANYDATA类型
    id NUMBER PRIMARY KEY,
    anydata_col ANYDATA               -- 可以存储任何类型的数据，用于动态数据类型场景
);

-- 注意：ANYDATA类型需要特殊处理，这里仅创建表结构

-------------------------------------------------------------------------------
-- 11. 边界值测试表
-------------------------------------------------------------------------------
CREATE TABLE boundary_values_test (
    -- 边界值测试
    id NUMBER PRIMARY KEY,
    
    -- NUMBER边界值
    number_min NUMBER,                -- 最小值
    number_max NUMBER,                -- 最大值
    number_zero NUMBER,               -- 零值
    number_null NUMBER,               -- NULL值
    
    -- 字符边界值
    char_empty CHAR(1),              -- 空字符串
    varchar2_empty VARCHAR2(10),      -- 空字符串
    
    -- 日期边界值
    date_min DATE,                   -- 最小日期
    date_max DATE,                   -- 最大日期
    date_null DATE                   -- NULL日期
);

-- 插入边界值测试数据
INSERT INTO boundary_values_test VALUES (
    1, 
    -99999999999999999999999999999999999999,  -- 最小值
    99999999999999999999999999999999999999,   -- 最大值
    0,                                    -- 零值
    NULL,                                  -- NULL值
    '',                                    -- 空字符串
    '',                                    -- 空字符串
    TO_DATE('4712-01-01', 'YYYY-MM-DD'),    -- 最小日期
    TO_DATE('9999-12-31', 'YYYY-MM-DD'),    -- 最大日期
    NULL                                   -- NULL日期
);

-------------------------------------------------------------------------------
-- 查看所有测试表结构
-------------------------------------------------------------------------------
DESC integer_types_test;
DESC decimal_types_test;
DESC float_types_test;
DESC binary_float_types_test;
DESC basic_character_types_test;
DESC national_character_types_test;
DESC lob_character_types_test;
DESC date_types_test;
DESC binary_types_test;
DESC boolean_type_test;
DESC special_types_test;
DESC xml_types_test;
DESC json_types_test;
DESC bfile_types_test;
DESC anydata_types_test;
DESC boundary_values_test;

-------------------------------------------------------------------------------
-- 查看创建的所有测试表
-------------------------------------------------------------------------------
SELECT table_name FROM user_tables WHERE table_name LIKE '%_TEST' ORDER BY table_name;

-------------------------------------------------------------------------------
-- 验证数据插入
-------------------------------------------------------------------------------
SELECT * FROM integer_types_test;
SELECT * FROM decimal_types_test;
SELECT * FROM float_types_test;
SELECT * FROM binary_float_types_test;
SELECT * FROM basic_character_types_test;
SELECT * FROM national_character_types_test;
SELECT id, DBMS_LOB.getlength(clob_col) as clob_length FROM lob_character_types_test; -- 显示CLOB长度
SELECT id, DBMS_LOB.getlength(nclob_col) as nclob_length FROM lob_character_types_test; -- 显示NCLOB长度
SELECT * FROM date_types_test;
SELECT id, DBMS_LOB.getlength(blob_col) as blob_length FROM binary_types_test; -- 显示BLOB长度
SELECT * FROM boolean_type_test;
SELECT * FROM special_types_test;
SELECT id, xml_col.getClobVal() FROM xml_types_test;
SELECT id, json_col FROM json_types_test;
SELECT * FROM boundary_values_test;

-------------------------------------------------------------------------------
-- 数据类型转换测试
-------------------------------------------------------------------------------
-- 测试隐式转换
SELECT 
    TO_NUMBER('12345') as string_to_number,
    TO_CHAR(12345) as number_to_string,
    TO_DATE('2023-01-01', 'YYYY-MM-DD') as string_to_date,
    TO_CHAR(SYSDATE, 'YYYY-MM-DD') as date_to_string
FROM dual;

-- 测试显式转换
SELECT 
    CAST('12345' AS NUMBER) as cast_string_to_number,
    CAST(12345 AS VARCHAR2(10)) as cast_number_to_string,
    CAST(SYSDATE AS VARCHAR2(20)) as cast_date_to_string
FROM dual;