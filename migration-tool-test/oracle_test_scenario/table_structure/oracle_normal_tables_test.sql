-- 普通表测试脚本
-- 测试场景：无主键表、单一主键表、自增主键表、联合主键表、外键表、唯一约束表、检查约束表

-- 1. 无主键表
CREATE TABLE no_primary_key_table (
    id NUMBER,
    name VARCHAR2(100),
    age NUMBER,
    salary NUMBER(10,2),
    create_date DATE
);

-- 插入测试数据
BEGIN
    FOR i IN 1..1000 LOOP
        INSERT INTO no_primary_key_table VALUES (
            i,
            '员工' || i,
            20 + MOD(i, 40),
            5000 + MOD(i, 15000) + (i * 0.01),
            TO_DATE('2020-01-01', 'YYYY-MM-DD') + MOD(i, 1500)
        );
    END LOOP;
    COMMIT;
END;
/

-- 2. 单一主键表
CREATE TABLE single_primary_key_table (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    age NUMBER,
    salary NUMBER(10,2),
    create_date DATE
);

-- 插入测试数据
BEGIN
    FOR i IN 1..1000 LOOP
        INSERT INTO single_primary_key_table VALUES (
            i,
            '员工' || i,
            20 + MOD(i, 40),
            5000 + MOD(i, 15000) + (i * 0.01),
            TO_DATE('2020-01-01', 'YYYY-MM-DD') + MOD(i, 1500)
        );
    END LOOP;
    COMMIT;
END;
/

-- 3. 自增主键表（使用序列和触发器实现自增）
CREATE SEQUENCE auto_increment_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE auto_increment_table (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    age NUMBER,
    salary NUMBER(10,2),
    create_date DATE
);

CREATE OR REPLACE TRIGGER auto_increment_trigger
BEFORE INSERT ON auto_increment_table
FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        SELECT auto_increment_seq.NEXTVAL INTO :NEW.id FROM dual;
    END IF;
END;
/

-- 插入测试数据（ID自动生成）
BEGIN
    FOR i IN 1..1000 LOOP
        INSERT INTO auto_increment_table (name, age, salary, create_date) VALUES (
            '员工' || i,
            20 + MOD(i, 40),
            5000 + MOD(i, 15000) + (i * 0.01),
            TO_DATE('2020-01-01', 'YYYY-MM-DD') + MOD(i, 1500)
        );
    END LOOP;
    COMMIT;
END;
/

-- 4. 联合主键表
CREATE TABLE composite_primary_key_table (
    department_id NUMBER,
    employee_id NUMBER,
    name VARCHAR2(100),
    position VARCHAR2(50),
    salary NUMBER(10,2),
    PRIMARY KEY (department_id, employee_id)
);

-- 插入测试数据
BEGIN
    FOR i IN 1..1000 LOOP
        INSERT INTO composite_primary_key_table VALUES (
            1 + MOD(i, 10),
            1 + MOD(i, 100),
            '员工' || i,
            CASE MOD(i, 5)
                WHEN 0 THEN '开发工程师'
                WHEN 1 THEN '测试工程师'
                WHEN 2 THEN '产品经理'
                WHEN 3 THEN '技术总监'
                ELSE 'UI设计师'
            END,
            5000 + MOD(i, 15000) + (i * 0.01)
        );
    END LOOP;
    COMMIT;
END;
/

-- 5. 外键表
CREATE TABLE table_structure_department_table (
    department_id NUMBER PRIMARY KEY,
    department_name VARCHAR2(100),
    location VARCHAR2(100)
);

CREATE TABLE table_structure_employee_table (
    employee_id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    department_id NUMBER,
    salary NUMBER(10,2),
    CONSTRAINT fk_department FOREIGN KEY (department_id) REFERENCES table_structure_department_table(department_id)
);

-- 插入部门数据
BEGIN
    FOR i IN 1..20 LOOP
        INSERT INTO table_structure_department_table VALUES (
            i,
            '部门' || i,
            CASE MOD(i, 6)
                WHEN 0 THEN '北京'
                WHEN 1 THEN '上海'
                WHEN 2 THEN '深圳'
                WHEN 3 THEN '广州'
                WHEN 4 THEN '杭州'
                ELSE '成都'
            END
        );
    END LOOP;
    COMMIT;
END;
/

-- 插入员工数据
BEGIN
    FOR i IN 1..1000 LOOP
        INSERT INTO table_structure_employee_table VALUES (
            i,
            '员工' || i,
            1 + MOD(i, 20),
            5000 + MOD(i, 15000) + (i * 0.01)
        );
    END LOOP;
    COMMIT;
END;
/

-- 6. 唯一约束表
CREATE TABLE unique_constraint_table (
    id NUMBER PRIMARY KEY,
    email VARCHAR2(100) UNIQUE,
    phone VARCHAR2(20) UNIQUE,
    name VARCHAR2(100),
    age NUMBER
);

-- 插入测试数据
BEGIN
    FOR i IN 1..1000 LOOP
        INSERT INTO unique_constraint_table VALUES (
            i,
            'user' || LPAD(i, 6, '0') || '@example.com',
            '138' || LPAD(TO_CHAR(MOD(i, 100000000)), 8, '0'),
            '员工' || i,
            20 + MOD(i, 40)
        );
    END LOOP;
    COMMIT;
END;
/

-- 7. 检查约束表
CREATE TABLE check_constraint_table (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    age NUMBER CHECK (age >= 18 AND age <= 65),
    salary NUMBER(10,2) CHECK (salary >= 0),
    gender VARCHAR2(10) CHECK (gender IN ('男', '女', '其他')),
    status VARCHAR2(20) CHECK (status IN ('在职', '离职', '休假'))
);

-- 插入测试数据
BEGIN
    FOR i IN 1..1000 LOOP
        INSERT INTO check_constraint_table VALUES (
            i,
            '员工' || i,
            18 + MOD(i, 48),
            5000 + MOD(i, 15000) + (i * 0.01),
            CASE MOD(i, 3)
                WHEN 0 THEN '男'
                WHEN 1 THEN '女'
                ELSE '其他'
            END,
            CASE MOD(i, 3)
                WHEN 0 THEN '在职'
                WHEN 1 THEN '休假'
                ELSE '离职'
            END
        );
    END LOOP;
    COMMIT;
END;
/

-- 8. 非空约束表
CREATE TABLE not_null_constraint_table (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) NOT NULL,
    phone VARCHAR2(20),
    age NUMBER NOT NULL,
    salary NUMBER(10,2)
);

-- 插入测试数据
BEGIN
    FOR i IN 1..1000 LOOP
        INSERT INTO not_null_constraint_table VALUES (
            i,
            '员工' || i,
            'user' || LPAD(i, 6, '0') || '@example.com',
            CASE MOD(i, 2)
                WHEN 0 THEN '138' || LPAD(TO_CHAR(MOD(i, 100000000)), 8, '0')
                ELSE NULL
            END,
            20 + MOD(i, 40),
            5000 + MOD(i, 15000) + (i * 0.01)
        );
    END LOOP;
    COMMIT;
END;
/

-- 9. 默认值表
CREATE TABLE default_value_table (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    status VARCHAR2(20) DEFAULT '在职',
    create_date DATE DEFAULT SYSDATE,
    is_active NUMBER(1) DEFAULT 1,
    score NUMBER(5,2) DEFAULT 0.00
);

-- 插入测试数据
BEGIN
    FOR i IN 1..1000 LOOP
        INSERT INTO default_value_table VALUES (
            i,
            '员工' || i,
            CASE MOD(i, 3)
                WHEN 0 THEN '在职'
                WHEN 1 THEN '休假'
                ELSE '离职'
            END,
            TO_DATE('2020-01-01', 'YYYY-MM-DD') + MOD(i, 1500),
            CASE MOD(i, 2)
                WHEN 0 THEN 1
                ELSE 0
            END,
            CASE MOD(i, 5)
                WHEN 0 THEN 95.50 + (i * 0.01)
                ELSE 0.00
            END
        );
    END LOOP;
    COMMIT;
END;
/

-- 10. 索引表
CREATE TABLE index_table (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    email VARCHAR2(100),
    age NUMBER,
    salary NUMBER(10,2),
    create_date DATE
);

-- 创建各种索引
CREATE INDEX idx_name ON index_table(name);
CREATE INDEX idx_age ON index_table(age);
CREATE INDEX idx_salary ON index_table(salary);
CREATE INDEX idx_create_date ON index_table(create_date);

-- 插入测试数据
BEGIN
    FOR i IN 1..1000 LOOP
        INSERT INTO index_table VALUES (
            i,
            '员工' || i,
            'user' || LPAD(i, 6, '0') || '@example.com',
            20 + MOD(i, 40),
            5000 + MOD(i, 15000) + (i * 0.01),
            TO_DATE('2020-01-01', 'YYYY-MM-DD') + MOD(i, 1500)
        );
    END LOOP;
    COMMIT;
END;
/

-- 查看创建的表
SELECT table_name FROM user_tables ORDER BY table_name;

-- 查看表结构
SELECT table_name, column_name, data_type, nullable, data_default 
FROM user_tab_columns 
WHERE table_name IN (
    'NO_PRIMARY_KEY_TABLE', 'SINGLE_PRIMARY_KEY_TABLE', 'AUTO_INCREMENT_TABLE',
    'COMPOSITE_PRIMARY_KEY_TABLE', 'TABLE_STRUCTURE_DEPARTMENT_TABLE', 'TABLE_STRUCTURE_EMPLOYEE_TABLE',
    'UNIQUE_CONSTRAINT_TABLE', 'CHECK_CONSTRAINT_TABLE', 'NOT_NULL_CONSTRAINT_TABLE',
    'DEFAULT_VALUE_TABLE', 'INDEX_TABLE'
)
ORDER BY table_name, column_id;

-- 查看约束信息
SELECT table_name, constraint_name, constraint_type 
FROM user_constraints 
WHERE table_name IN (
    'NO_PRIMARY_KEY_TABLE', 'SINGLE_PRIMARY_KEY_TABLE', 'AUTO_INCREMENT_TABLE',
    'COMPOSITE_PRIMARY_KEY_TABLE', 'TABLE_STRUCTURE_DEPARTMENT_TABLE', 'TABLE_STRUCTURE_EMPLOYEE_TABLE',
    'UNIQUE_CONSTRAINT_TABLE', 'CHECK_CONSTRAINT_TABLE', 'NOT_NULL_CONSTRAINT_TABLE',
    'DEFAULT_VALUE_TABLE', 'INDEX_TABLE'
)
ORDER BY table_name, constraint_name;

-- 查看索引信息
SELECT table_name, index_name, index_type 
FROM user_indexes 
WHERE table_name = 'INDEX_TABLE'
ORDER BY index_name;