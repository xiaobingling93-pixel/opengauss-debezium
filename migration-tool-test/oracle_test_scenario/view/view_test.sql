-- View test script

-- Create test tables for view testing
CREATE TABLE view_test_table1 (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    age NUMBER,
    department VARCHAR2(100)
);

CREATE TABLE view_test_table2 (
    employee_id NUMBER PRIMARY KEY,
    salary NUMBER,
    hire_date DATE
);

-- 1. Basic view
CREATE VIEW basic_view AS
SELECT id, name, age
FROM view_test_table1;

-- 2. Complex view (including join, aggregation, etc.)
CREATE VIEW complex_view AS
SELECT 
    t1.id,
    t1.name,
    t1.department,
    t2.salary,
    t2.hire_date,
    AVG(t2.salary) OVER (PARTITION BY t1.department) AS avg_department_salary
FROM view_test_table1 t1
JOIN view_test_table2 t2 ON t1.id = t2.employee_id;



-- View created views
SELECT view_name FROM user_views;
