-- 1. Single index test table
CREATE TABLE single_index_table (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    age NUMBER,
    department VARCHAR2(100)
);

-- Create single index
CREATE INDEX idx_single_index_name ON single_index_table(name);

-- 2. Composite index test table
CREATE TABLE composite_index_table (
    id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    age NUMBER,
    department VARCHAR2(100)
);

-- Create composite index
CREATE INDEX idx_composite_index_name ON composite_index_table(first_name, last_name);

-- 3. Multiple indexes test table
CREATE TABLE multiple_index_table (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    age NUMBER,
    department VARCHAR2(100),
    hire_date DATE,
    salary NUMBER
);

-- Create multiple indexes
CREATE INDEX idx_multiple_index_name ON multiple_index_table(name);
CREATE INDEX idx_multiple_index_department ON multiple_index_table(department);
CREATE INDEX idx_multiple_index_hire_date ON multiple_index_table(hire_date);
CREATE INDEX idx_multiple_index_salary ON multiple_index_table(salary);

-- View created indexes
SELECT 
    table_name,
    index_name,
    index_type,
    uniqueness
FROM 
    user_indexes
WHERE 
    table_name IN ('SINGLE_INDEX_TABLE', 'COMPOSITE_INDEX_TABLE', 'MULTIPLE_INDEX_TABLE')
ORDER BY 
    table_name, index_name;

-- View index columns
SELECT 
    table_name,
    index_name,
    column_name,
    column_position
FROM 
    user_ind_columns
WHERE 
    table_name IN ('SINGLE_INDEX_TABLE', 'COMPOSITE_INDEX_TABLE', 'MULTIPLE_INDEX_TABLE', 'EXPRESSION_INDEX_TABLE')
ORDER BY 
    table_name, index_name, column_position;

-- 4. Expression index test table
CREATE TABLE expression_index_table (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    email VARCHAR2(100),
    hire_date DATE,
    salary NUMBER
);

-- Create expression indexes
CREATE INDEX idx_expression_upper_name ON expression_index_table(UPPER(name));
CREATE INDEX idx_expression_lower_email ON expression_index_table(LOWER(email));
CREATE INDEX idx_expression_date_trunc ON expression_index_table(TRUNC(hire_date));
CREATE INDEX idx_expression_salary_range ON expression_index_table(FLOOR(salary / 1000) * 1000);

-- View expression indexes
SELECT 
    i.table_name,
    i.index_name,
    i.index_type,
    i.uniqueness,
    e.column_expression
FROM 
    user_indexes i
JOIN 
    user_ind_expressions e ON i.index_name = e.index_name
WHERE 
    i.table_name = 'EXPRESSION_INDEX_TABLE'
ORDER BY 
    i.index_name;

