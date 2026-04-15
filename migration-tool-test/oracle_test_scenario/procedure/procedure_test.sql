-- Stored procedure test script
-- Test scenarios: Basic stored procedure, parameterized stored procedure, cursor stored procedure, complex logic stored procedure

-- Switch to test user
CREATE TABLE procedure_test_table (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    age NUMBER,
    salary NUMBER
);

-- 1. Basic stored procedure
CREATE OR REPLACE PROCEDURE basic_procedure IS
BEGIN
    INSERT INTO procedure_test_table (id, name, age, salary)
    VALUES (1, 'Test User', 30, 5000);
    COMMIT;
END;
/

-- 2. Parameterized stored procedure
CREATE OR REPLACE PROCEDURE parameterized_procedure (
    p_id IN NUMBER,
    p_name IN VARCHAR2,
    p_age IN NUMBER,
    p_salary IN NUMBER,
    p_result OUT VARCHAR2
) IS
BEGIN
    INSERT INTO procedure_test_table (id, name, age, salary)
    VALUES (p_id, p_name, p_age, p_salary);
    COMMIT;
    p_result := 'Success';
EXCEPTION
    WHEN OTHERS THEN
        p_result := 'Error: ' || SQLERRM;
        ROLLBACK;
END;
/

-- 3. Cursor stored procedure
CREATE OR REPLACE PROCEDURE cursor_procedure (
    p_min_salary IN NUMBER,
    p_cursor OUT SYS_REFCURSOR
) IS
BEGIN
    OPEN p_cursor FOR
        SELECT id, name, age, salary
        FROM procedure_test_table
        WHERE salary >= p_min_salary
        ORDER BY salary DESC;
END;
/

-- 4. Complex logic stored procedure
CREATE OR REPLACE PROCEDURE complex_procedure (
    p_department IN VARCHAR2,
    p_percent IN NUMBER
) IS
    v_total_salary NUMBER;
    v_employee_count NUMBER;
    v_avg_salary NUMBER;
BEGIN
    -- 计算平均工资
    SELECT COUNT(*), AVG(salary)
    INTO v_employee_count, v_avg_salary
    FROM procedure_test_table;
    
    -- 计算总工资
    v_total_salary := v_employee_count * v_avg_salary;
    
    -- 输出结果
    DBMS_OUTPUT.PUT_LINE('Department: ' || p_department);
    DBMS_OUTPUT.PUT_LINE('Employee Count: ' || v_employee_count);
    DBMS_OUTPUT.PUT_LINE('Average Salary: ' || v_avg_salary);
    DBMS_OUTPUT.PUT_LINE('Total Salary: ' || v_total_salary);
    DBMS_OUTPUT.PUT_LINE('Salary Increase Percent: ' || p_percent);
END;
/

-- View created stored procedures
SELECT object_name FROM user_procedures WHERE object_type = 'PROCEDURE';
