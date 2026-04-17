-------------------------------------------------------------------------------
-- 浮点数类型测试 - 分表测试（每个类型独立设计测试数据）
-------------------------------------------------------------------------------

-- 1. 默认精度 FLOAT（FLOAT(126)）
CREATE TABLE float_default_test (
    id NUMBER PRIMARY KEY,
    value FLOAT
);

INSERT INTO float_default_test VALUES (1, 123.4567890123456789);         
INSERT INTO float_default_test VALUES (2, 0.000000000123456789012345);   
INSERT INTO float_default_test VALUES (3, 9876543210987654321);        
INSERT INTO float_default_test VALUES (4, -5.43210987654321e-20);     
INSERT INTO float_default_test VALUES (5, 8.765432109876543e125);       
INSERT INTO float_default_test VALUES (6, 0);                             
INSERT INTO float_default_test VALUES (7, 1);                             


-- 2. FLOAT(1)（二进制精度1，约1位十进制有效数字）
CREATE TABLE float_prec_1_test (
    id NUMBER PRIMARY KEY,
    value FLOAT(1)
);

INSERT INTO float_prec_1_test VALUES (1, 100);        
INSERT INTO float_prec_1_test VALUES (2, 0.1);        
INSERT INTO float_prec_1_test VALUES (3, 900);       
INSERT INTO float_prec_1_test VALUES (4, -50);          
INSERT INTO float_prec_1_test VALUES (5, 1e-10);        
INSERT INTO float_prec_1_test VALUES (6, 9e125);         
INSERT INTO float_prec_1_test VALUES (7, 0);             


-- 3. FLOAT(5)（二进制精度5，约2位十进制有效数字）
CREATE TABLE float_prec_5_test (
    id NUMBER PRIMARY KEY,
    value FLOAT(5)
);

INSERT INTO float_prec_5_test VALUES (1, 120);          
INSERT INTO float_prec_5_test VALUES (2, 0.00012);     
INSERT INTO float_prec_5_test VALUES (3, 9.9e8);        
INSERT INTO float_prec_5_test VALUES (4, -0.00099);     
INSERT INTO float_prec_5_test VALUES (5, 1.2e-20);     
INSERT INTO float_prec_5_test VALUES (6, 8.8e125);      
INSERT INTO float_prec_5_test VALUES (7, 0);


-- 4. FLOAT(63)（二进制精度63，约18位十进制有效数字，相当于双精度）
CREATE TABLE float_prec_63_test (
    id NUMBER PRIMARY KEY,
    value FLOAT(63)
);

INSERT INTO float_prec_63_test VALUES (1, 123.4567890123456789);          
INSERT INTO float_prec_63_test VALUES (2, 0.000000000123456789012345);   
INSERT INTO float_prec_63_test VALUES (3, 9876543210987654321);           
INSERT INTO float_prec_63_test VALUES (4, -5.43210987654321e-20);         
INSERT INTO float_prec_63_test VALUES (5, 8.765432109876543e125);         
INSERT INTO float_prec_63_test VALUES (6, 0);
INSERT INTO float_prec_63_test VALUES (7, 1);


-- 5. FLOAT(126)（二进制精度126，约38位十进制有效数字，Oracle最大精度）
CREATE TABLE float_prec_126_test (
    id NUMBER PRIMARY KEY,
    value FLOAT(126)
);

INSERT INTO float_prec_126_test VALUES (1, 123.45678901234567890123456789012345678);  
INSERT INTO float_prec_126_test VALUES (2, 1.2345678901234567890123456789e-40);     
INSERT INTO float_prec_126_test VALUES (3, 98765432109876543210987654321098765432);   
INSERT INTO float_prec_126_test VALUES (4, -5.4321098765432109876543210987654321e-30);
INSERT INTO float_prec_126_test VALUES (5, 8.7654321098765432109876543210987654e125);         
INSERT INTO float_prec_126_test VALUES (6, 0);
INSERT INTO float_prec_126_test VALUES (7, 1);


-- 6. DOUBLE PRECISION（Oracle中等同于FLOAT(126)）
CREATE TABLE double_precision_test (
    id NUMBER PRIMARY KEY,
    value DOUBLE PRECISION
);

-- 使用与FLOAT(126)类似的数值，但强调双精度特性
INSERT INTO double_precision_test VALUES (1, 123.4567890123456789);                    
INSERT INTO double_precision_test VALUES (2, 0.000000000123456789012345);   
INSERT INTO double_precision_test VALUES (3, 9876543210987654321);           
INSERT INTO double_precision_test VALUES (4, -5.43210987654321e-20);
INSERT INTO double_precision_test VALUES (5, 8.765432109876543e125);
INSERT INTO double_precision_test VALUES (6, 0);
INSERT INTO double_precision_test VALUES (7, 1);

-------------------------------------------------------------------------------
-- 查看所有数据，观察精度差异
-------------------------------------------------------------------------------
SELECT * FROM float_default_test ORDER BY id;
SELECT * FROM float_prec_1_test ORDER BY id;
SELECT * FROM float_prec_5_test ORDER BY id;
SELECT * FROM float_prec_63_test ORDER BY id;
SELECT * FROM float_prec_126_test ORDER BY id;
SELECT * FROM double_precision_test ORDER BY id;

-------------------------------------------------------------------------------
-- 精度对比测试：观察同一数值在不同精度表中的存储结果
-------------------------------------------------------------------------------
-- 对比123.4567890123456789在不同精度下的表现
SELECT 'FLOAT_DEFAULT' as type, value FROM float_default_test WHERE id=1
UNION ALL
SELECT 'FLOAT(1)', value FROM float_prec_1_test WHERE id=1
UNION ALL
SELECT 'FLOAT(5)', value FROM float_prec_5_test WHERE id=1
UNION ALL
SELECT 'FLOAT(63)', value FROM float_prec_63_test WHERE id=1
UNION ALL
SELECT 'FLOAT(126)', value FROM float_prec_126_test WHERE id=1
UNION ALL
SELECT 'DOUBLE', value FROM double_precision_test WHERE id=1;