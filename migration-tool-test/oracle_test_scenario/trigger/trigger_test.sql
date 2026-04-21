-- Trigger test script
-- Test scenarios: INSERT trigger, UPDATE trigger, DELETE trigger, compound trigger, INSTEAD OF trigger

-- Create test table for trigger testing
CREATE TABLE trigger_test_table (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    age NUMBER,
    create_date DATE,
    update_date DATE
);

-- Create audit table for trigger testing
CREATE TABLE trigger_audit_table (
    audit_id NUMBER PRIMARY KEY,
    table_name VARCHAR2(100),
    operation VARCHAR2(10),
    operation_date DATE,
    old_values VARCHAR2(4000),
    new_values VARCHAR2(4000)
);

-- Create sequence for audit table
CREATE SEQUENCE audit_seq START WITH 1 INCREMENT BY 1;

-- 1. INSERT trigger
CREATE OR REPLACE TRIGGER insert_trigger
BEFORE INSERT ON trigger_test_table
FOR EACH ROW
BEGIN
    IF :NEW.create_date IS NULL THEN
        :NEW.create_date := SYSDATE;
    END IF;
    
    -- 记录审计信息
    INSERT INTO trigger_audit_table (audit_id, table_name, operation, operation_date, new_values)
    VALUES (audit_seq.NEXTVAL, 'TRIGGER_TEST_TABLE', 'INSERT', SYSDATE, 
            'id: ' || :NEW.id || ', name: ' || :NEW.name || ', age: ' || :NEW.age);
END;
/

-- 2. UPDATE trigger
CREATE OR REPLACE TRIGGER update_trigger
BEFORE UPDATE ON trigger_test_table
FOR EACH ROW
BEGIN
    :NEW.update_date := SYSDATE;
    
    -- 记录审计信息
    INSERT INTO trigger_audit_table (audit_id, table_name, operation, operation_date, old_values, new_values)
    VALUES (audit_seq.NEXTVAL, 'TRIGGER_TEST_TABLE', 'UPDATE', SYSDATE, 
            'name: ' || :OLD.name || ', age: ' || :OLD.age, 
            'name: ' || :NEW.name || ', age: ' || :NEW.age);
END;
/

-- 3. DELETE trigger
CREATE OR REPLACE TRIGGER delete_trigger
BEFORE DELETE ON trigger_test_table
FOR EACH ROW
BEGIN
    -- 记录审计信息
    INSERT INTO trigger_audit_table (audit_id, table_name, operation, operation_date, old_values)
    VALUES (audit_seq.NEXTVAL, 'TRIGGER_TEST_TABLE', 'DELETE', SYSDATE, 
            'id: ' || :OLD.id || ', name: ' || :OLD.name || ', age: ' || :OLD.age);
END;
/

-- 5. INSTEAD OF trigger (for views)
-- Create a view for testing INSTEAD OF trigger
CREATE VIEW trigger_test_view AS
SELECT id, name, age
FROM trigger_test_table;

CREATE OR REPLACE TRIGGER instead_of_trigger
INSTEAD OF INSERT ON trigger_test_view
FOR EACH ROW
BEGIN
    -- 插入到基表
    INSERT INTO trigger_test_table (id, name, age)
    VALUES (:NEW.id, :NEW.name, :NEW.age);
    
    -- 记录审计信息
    INSERT INTO trigger_audit_table (audit_id, table_name, operation, operation_date, new_values)
    VALUES (audit_seq.NEXTVAL, 'TRIGGER_TEST_VIEW', 'INSERT', SYSDATE, 
            'id: ' || :NEW.id || ', name: ' || :NEW.name || ', age: ' || :NEW.age);
END;
/

-- View created triggers
SELECT trigger_name, table_name, triggering_event, status
FROM user_triggers
ORDER BY trigger_name;
