-- Comment test scenarios for Oracle
-- This script demonstrates table and column comments

-- Create tables with comments

-- Table 1: Basic table with comments
CREATE TABLE comment_test_basic (
    id NUMBER(10) PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    value NUMBER(10) NOT NULL,
    description VARCHAR2(255)
)
/

-- Add table comment
COMMENT ON TABLE comment_test_basic IS 'Basic table with comments test'
/

-- Add column comments
COMMENT ON COLUMN comment_test_basic.id IS 'Primary key column'
/

COMMENT ON COLUMN comment_test_basic.name IS 'Name of the entity'
/

COMMENT ON COLUMN comment_test_basic.value IS 'Numeric value'
/

COMMENT ON COLUMN comment_test_basic.description IS 'Description of the entity'
/

-- Table 2: Table with complex column comments
CREATE TABLE comment_test_complex (
    employee_id NUMBER(10) PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    hire_date DATE NOT NULL,
    salary NUMBER(10,2) NOT NULL,
    department_id NUMBER(10),
    active_status VARCHAR2(1) DEFAULT 'Y'
)
/

-- Add table comment
COMMENT ON TABLE comment_test_complex IS 'Complex table with detailed column comments'
/

-- Add column comments
COMMENT ON COLUMN comment_test_complex.employee_id IS 'Unique identifier for employee'
/

COMMENT ON COLUMN comment_test_complex.first_name IS 'Employee''s first name'
/

COMMENT ON COLUMN comment_test_complex.last_name IS 'Employee''s last name'
/

COMMENT ON COLUMN comment_test_complex.hire_date IS 'Date when employee was hired'
/

COMMENT ON COLUMN comment_test_complex.salary IS 'Employee''s monthly salary'
/

COMMENT ON COLUMN comment_test_complex.department_id IS 'Foreign key to department table'
/

COMMENT ON COLUMN comment_test_complex.active_status IS 'Employee status: Y=Active, N=Inactive'
/

-- Table 3: Table with special characters in comments
CREATE TABLE comment_test_special (
    id NUMBER(10) PRIMARY KEY,
    code VARCHAR2(20) NOT NULL,
    value VARCHAR2(100)
)
/

-- Add table comment with special characters
COMMENT ON TABLE comment_test_special IS 'Table with special characters in comments: !@#$%^&*()'
/

-- Add column comments with special characters
COMMENT ON COLUMN comment_test_special.id IS 'ID column (primary key)'
/

COMMENT ON COLUMN comment_test_special.code IS 'Code column (unique identifier)'
/

COMMENT ON COLUMN comment_test_special.value IS 'Value column (can contain special characters: !@#$%^&*)'
/

-- Insert test data
INSERT INTO comment_test_basic (id, name, value, description) VALUES (1, 'Test 1', 100, 'First test record')
/

INSERT INTO comment_test_basic (id, name, value, description) VALUES (2, 'Test 2', 200, 'Second test record')
/

INSERT INTO comment_test_complex (employee_id, first_name, last_name, hire_date, salary, department_id, active_status) 
VALUES (1, 'John', 'Doe', SYSDATE - 365, 5000.00, 1, 'Y')
/

INSERT INTO comment_test_complex (employee_id, first_name, last_name, hire_date, salary, department_id, active_status) 
VALUES (2, 'Jane', 'Smith', SYSDATE - 180, 6000.00, 2, 'Y')
/

INSERT INTO comment_test_special (id, code, value) VALUES (1, 'CODE001', 'Value with special chars: !@#')
/

INSERT INTO comment_test_special (id, code, value) VALUES (2, 'CODE002', 'Value with another chars: $%^')
/

COMMIT
/

-- Query to verify comments
SELECT table_name, comments FROM user_tab_comments WHERE table_name LIKE 'COMMENT_TEST_%' ORDER BY table_name
/

SELECT table_name, column_name, comments FROM user_col_comments WHERE table_name LIKE 'COMMENT_TEST_%' ORDER BY table_name, column_name
/

-- End of comment test scenarios
