-- Constraint test scenarios for Oracle

-- Test table for constraints
CREATE TABLE constraint_test (
    id NUMBER(10) PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    age NUMBER(3) CHECK (age > 0 AND age < 150),
    email VARCHAR2(255) UNIQUE,
    department VARCHAR2(50) DEFAULT 'IT'
)
/
-- Test table for unique constraint on multiple columns
CREATE TABLE unique_constraint_test (
    id NUMBER(10),
    name VARCHAR2(100),
    address VARCHAR2(255),
    CONSTRAINT uk_name_address UNIQUE (name, address)
)
/
-- Test table for check constraint with complex condition
CREATE TABLE check_constraint_test (
    id NUMBER(10) PRIMARY KEY,
    salary NUMBER(10, 2) CHECK (salary >= 0),
    hire_date DATE DEFAULT SYSDATE,
    status VARCHAR2(10) CHECK (status IN ('ACTIVE', 'INACTIVE', 'SUSPENDED'))
)
/

-- Test table for not null constraint
CREATE TABLE not_null_test (
    id NUMBER(10) PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    middle_name VARCHAR2(50)
)
/

-- Test table with both valid and disabled constraints
CREATE TABLE mixed_constraint_test (
    id NUMBER(10) PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    age NUMBER(3) CHECK (age > 0 AND age < 150),
    email VARCHAR2(255) UNIQUE,
    phone VARCHAR2(20) CHECK (LENGTH(phone) >= 10)
)
/

-- New table specifically for disabled constraint scenario migration test
CREATE TABLE disabled_constraint_test (
    id NUMBER(10) PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    age NUMBER(3) CHECK (age > 0 AND age < 150),
    email VARCHAR2(255) UNIQUE,
    phone VARCHAR2(20) CHECK (LENGTH(phone) >= 10),
    department VARCHAR2(50) DEFAULT 'IT'
)
/

-- Insert test data
INSERT INTO constraint_test (id, name, age, email, department) VALUES (1, 'John Doe', 30, 'john.doe@example.com', 'IT');
INSERT INTO constraint_test (id, name, age, email, department) VALUES (2, 'Jane Smith', 25, 'jane.smith@example.com', 'HR');
INSERT INTO constraint_test (id, name, age, email, department) VALUES (3, 'Bob Johnson', 35, 'bob.johnson@example.com', 'Finance');
/

INSERT INTO unique_constraint_test (id, name, address) VALUES (1, 'Alice', '123 Main St');
INSERT INTO unique_constraint_test (id, name, address) VALUES (2, 'Bob', '456 Oak Ave');
/

INSERT INTO check_constraint_test (id, salary, hire_date, status) VALUES (1, 50000.00, SYSDATE - 365, 'ACTIVE');
INSERT INTO check_constraint_test (id, salary, hire_date, status) VALUES (2, 60000.00, SYSDATE - 180, 'INACTIVE');
/

INSERT INTO not_null_test (id, first_name, last_name) VALUES (1, 'Tom', 'Brown');
INSERT INTO not_null_test (id, first_name, last_name, middle_name) VALUES (2, 'Mary', 'Wilson', 'Ann');
/

-- Insert data into mixed constraint test table
INSERT INTO mixed_constraint_test (id, name, age, email, phone) VALUES (1, 'John Doe', 30, 'john@example.com', '1234567890');
INSERT INTO mixed_constraint_test (id, name, age, email, phone) VALUES (2, 'Jane Smith', 25, 'jane@example.com', '0987654321');
/

-- Insert data into disabled constraint test table
INSERT INTO disabled_constraint_test (id, name, age, email, phone, department) VALUES (1, 'John Doe', 30, 'john@example.com', '1234567890', 'IT');
INSERT INTO disabled_constraint_test (id, name, age, email, phone, department) VALUES (2, 'Jane Smith', 25, 'jane@example.com', '0987654321', 'HR');
/

SELECT constraint_name FROM user_constraints WHERE table_name = 'MIXED_CONSTRAINT_TEST'
/

-- Step 1: Find constraint names for disabled_constraint_test table
SELECT constraint_name, constraint_type FROM user_constraints WHERE table_name = 'DISABLED_CONSTRAINT_TEST'
/

-- Step 2: Disable specific constraints
-- Alternatively, use dynamic SQL to disable all constraints on the table
DECLARE
BEGIN
    -- Cursor to get all constraints for the table
    FOR c IN (
        SELECT constraint_name 
        FROM user_constraints 
        WHERE table_name = 'DISABLED_CONSTRAINT_TEST'
        AND constraint_type != 'P' -- Skip primary key constraint if needed
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Disabling constraint: ' || c.constraint_name);
        EXECUTE IMMEDIATE 'ALTER TABLE DISABLED_CONSTRAINT_TEST DISABLE CONSTRAINT ' || c.constraint_name;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('All constraints disabled successfully');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

-- Step 4: Verify constraints are disabled
SELECT constraint_name, status FROM user_constraints WHERE table_name = 'DISABLED_CONSTRAINT_TEST';
/

-- Step 5: Migration test instructions:
-- 1. Run the migration tool to migrate disabled_constraint_test table to oGRAC
-- 2. Check if the disabled constraints are properly migrated
-- 3. Verify that the data (including the violating data) is correctly migrated
-- 4. Test if re-enabling constraints works correctly in oGRAC

-- Test dropping and adding constraints
-- First, find the constraint name for age check
SELECT constraint_name FROM user_constraints WHERE table_name = 'CONSTRAINT_TEST' AND constraint_type = 'C';
/

-- Drop CHECK constraint for age
-- Replace with actual constraint name from the query above
-- ALTER TABLE constraint_test DROP CONSTRAINT SYS_C00XXXX3;

-- Add back check constraint with different condition
-- ALTER TABLE constraint_test
-- ADD CONSTRAINT chk_age
-- CHECK (age >= 18 AND age <= 100);

-- Test the new constraint
-- INSERT INTO constraint_test (id, name, age, email, department) VALUES (4, 'Test User', 17, 'test4@example.com', 'IT'); -- Should fail: age check constraint

-- Clean up
-- DROP TABLE constraint_test CASCADE CONSTRAINTS;
-- DROP TABLE unique_constraint_test CASCADE CONSTRAINTS;
-- DROP TABLE check_constraint_test CASCADE CONSTRAINTS;
-- DROP TABLE not_null_test CASCADE CONSTRAINTS;
-- DROP TABLE mixed_constraint_test CASCADE CONSTRAINTS;
-- DROP TABLE disabled_constraint_test CASCADE CONSTRAINTS;
/