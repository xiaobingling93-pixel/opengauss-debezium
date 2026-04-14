-- Insert test data into each table
-- Global parameter to control data volume, default 50000
DECLARE
    -- Define collection types for bulk operations
    TYPE id_tab IS TABLE OF NUMBER;
    TYPE name_tab IS TABLE OF VARCHAR2(1000);
    TYPE value_tab IS TABLE OF NUMBER;
    TYPE code_tab IS TABLE OF VARCHAR2(10);
    TYPE description_tab IS TABLE OF VARCHAR2(1000);
    TYPE status_tab IS TABLE OF VARCHAR2(10);
    TYPE category_tab IS TABLE OF VARCHAR2(1);
    TYPE subcategory_tab IS TABLE OF VARCHAR2(1);
    
    -- Collection variables
    ids id_tab;
    names name_tab;
    values_tab value_tab;
    codes code_tab;
    descriptions description_tab;
    statuses status_tab;
    categories category_tab;
    subcategories subcategory_tab;
    
    data_volume NUMBER := 10000; -- Default: 50,000 rows per table
    batch_size NUMBER := 1000; -- Batch size for bulk operations
    status_list VARCHAR2(100) := 'ACTIVE,INACTIVE,SUSPENDED';
    category_list VARCHAR2(100) := 'A,B,C,D,E';
    subcategory_list VARCHAR2(200) := 'X,Y,Z,W,V,U,T';
    
    -- Procedure to log messages to database
    PROCEDURE log_message(log_level IN VARCHAR2, log_message IN VARCHAR2, table_name IN VARCHAR2 DEFAULT NULL, operation IN VARCHAR2 DEFAULT NULL) IS
    BEGIN
        INSERT INTO general_data_execution_log (log_level, log_message, table_name, operation)
        VALUES (log_level, log_message, table_name, operation);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Failed to log message: ' || SQLERRM);
    END log_message;
    
    -- Procedure to set table to NOLOGGING mode
    PROCEDURE set_nologging(table_name IN VARCHAR2) IS
    BEGIN
        EXECUTE IMMEDIATE 'ALTER TABLE ' || table_name || ' NOLOGGING';
        log_message('INFO', 'Set NOLOGGING mode for ' || table_name, table_name, 'SET_NOLOGGING');
    EXCEPTION
        WHEN OTHERS THEN
            log_message('ERROR', 'Could not set NOLOGGING mode for ' || table_name || ': ' || SQLERRM, table_name, 'SET_NOLOGGING');
    END set_nologging;
    
    -- Procedure to reset table to LOGGING mode
    PROCEDURE set_logging(table_name IN VARCHAR2) IS
    BEGIN
        EXECUTE IMMEDIATE 'ALTER TABLE ' || table_name || ' LOGGING';
        log_message('INFO', 'Reset LOGGING mode for ' || table_name, table_name, 'SET_LOGGING');
    EXCEPTION
        WHEN OTHERS THEN
            log_message('ERROR', 'Could not reset LOGGING mode for ' || table_name || ': ' || SQLERRM, table_name, 'SET_LOGGING');
    END set_logging;
    
    -- Procedure to insert data in bulk
    PROCEDURE insert_data_bulk(table_name IN VARCHAR2, lpad_length IN NUMBER, desc_lpad_length IN NUMBER) IS
        i NUMBER;
        start_time TIMESTAMP;
        end_time TIMESTAMP;
    BEGIN
        start_time := SYSTIMESTAMP;
        log_message('INFO', 'Starting data insertion for table ' || table_name || ' with ' || data_volume || ' rows', table_name, 'INSERT_START');
        
        -- Set table to NOLOGGING mode
        set_nologging(table_name);
        
        i := 1;
        WHILE i <= data_volume LOOP
            -- Initialize collections
            ids := id_tab();
            names := name_tab();
            values_tab := value_tab();
            codes := code_tab();
            descriptions := description_tab();
            statuses := status_tab();
            categories := category_tab();
            subcategories := subcategory_tab();
            
            -- Populate collections
            FOR j IN 0..batch_size-1 LOOP
                IF i+j <= data_volume THEN
                    ids.EXTEND;
                    names.EXTEND;
                    values_tab.EXTEND;
                    codes.EXTEND;
                    descriptions.EXTEND;
                    statuses.EXTEND;
                    categories.EXTEND;
                    subcategories.EXTEND;
                    
                    ids(ids.COUNT) := i+j;
                    names(names.COUNT) := 'Test' || LPAD(i+j, lpad_length, 'x');
                    values_tab(values_tab.COUNT) := i+j;
                    codes(codes.COUNT) := 'CODE' || LPAD(i+j, 5, '0');
                    descriptions(descriptions.COUNT) := 'desc ' || LPAD(i+j, desc_lpad_length, 'x');
                    statuses(statuses.COUNT) := REGEXP_SUBSTR(status_list, '[^,]+', 1, MOD(i+j, 3) + 1);
                    categories(categories.COUNT) := REGEXP_SUBSTR(category_list, '[^,]+', 1, MOD(i+j, 5) + 1);
                    subcategories(subcategories.COUNT) := REGEXP_SUBSTR(subcategory_list, '[^,]+', 1, MOD(i+j, 7) + 1);
                END IF;
            END LOOP;
            
            -- Bulk insert using FORALL with parallel degree 8
            IF table_name = 'general_test_data_10' THEN
                FORALL k IN 1..ids.COUNT
                    INSERT /*+ APPEND PARALLEL(8) */ INTO general_test_data_10 (id, name, value, code, description, status, category, subcategory)
                    VALUES (ids(k), names(k), values_tab(k), codes(k), descriptions(k), statuses(k), categories(k), subcategories(k));
            ELSIF table_name = 'general_test_data_50' THEN
                FORALL k IN 1..ids.COUNT
                    INSERT /*+ APPEND PARALLEL(8) */ INTO general_test_data_50 (id, name, value, code, description, status, category, subcategory)
                    VALUES (ids(k), names(k), values_tab(k), codes(k), descriptions(k), statuses(k), categories(k), subcategories(k));
            ELSIF table_name = 'general_test_data_100' THEN
                FORALL k IN 1..ids.COUNT
                    INSERT /*+ APPEND PARALLEL(8) */ INTO general_test_data_100 (id, name, value, code, description, status, category, subcategory)
                    VALUES (ids(k), names(k), values_tab(k), codes(k), descriptions(k), statuses(k), categories(k), subcategories(k));
            ELSIF table_name = 'general_test_data_150' THEN
                FORALL k IN 1..ids.COUNT
                    INSERT /*+ APPEND PARALLEL(8) */ INTO general_test_data_150 (id, name, value, code, description, status, category, subcategory)
                    VALUES (ids(k), names(k), values_tab(k), codes(k), descriptions(k), statuses(k), categories(k), subcategories(k));
            ELSIF table_name = 'general_test_data_200' THEN
                FORALL k IN 1..ids.COUNT
                    INSERT /*+ APPEND PARALLEL(8) */ INTO general_test_data_200 (id, name, value, code, description, status, category, subcategory)
                    VALUES (ids(k), names(k), values_tab(k), codes(k), descriptions(k), statuses(k), categories(k), subcategories(k));
            ELSIF table_name = 'general_test_data_250' THEN
                FORALL k IN 1..ids.COUNT
                    INSERT /*+ APPEND PARALLEL(8) */ INTO general_test_data_250 (id, name, value, code, description, status, category, subcategory)
                    VALUES (ids(k), names(k), values_tab(k), codes(k), descriptions(k), statuses(k), categories(k), subcategories(k));
            ELSIF table_name = 'general_test_data_300' THEN
                FORALL k IN 1..ids.COUNT
                    INSERT /*+ APPEND PARALLEL(8) */ INTO general_test_data_300 (id, name, value, code, description, status, category, subcategory)
                    VALUES (ids(k), names(k), values_tab(k), codes(k), descriptions(k), statuses(k), categories(k), subcategories(k));
            ELSIF table_name = 'general_test_data_350' THEN
                FORALL k IN 1..ids.COUNT
                    INSERT /*+ APPEND PARALLEL(8) */ INTO general_test_data_350 (id, name, value, code, description, status, category, subcategory)
                    VALUES (ids(k), names(k), values_tab(k), codes(k), descriptions(k), statuses(k), categories(k), subcategories(k));
            ELSIF table_name = 'general_test_data_400' THEN
                FORALL k IN 1..ids.COUNT
                    INSERT /*+ APPEND PARALLEL(8) */ INTO general_test_data_400 (id, name, value, code, description, status, category, subcategory)
                    VALUES (ids(k), names(k), values_tab(k), codes(k), descriptions(k), statuses(k), categories(k), subcategories(k));
            ELSIF table_name = 'general_test_data_450' THEN
                FORALL k IN 1..ids.COUNT
                    INSERT /*+ APPEND PARALLEL(8) */ INTO general_test_data_450 (id, name, value, code, description, status, category, subcategory)
                    VALUES (ids(k), names(k), values_tab(k), codes(k), descriptions(k), statuses(k), categories(k), subcategories(k));
            ELSIF table_name = 'general_test_data_500' THEN
                FORALL k IN 1..ids.COUNT
                    INSERT /*+ APPEND PARALLEL(8) */ INTO general_test_data_500 (id, name, value, code, description, status, category, subcategory)
                    VALUES (ids(k), names(k), values_tab(k), codes(k), descriptions(k), statuses(k), categories(k), subcategories(k));
            ELSIF table_name = 'general_test_data_550' THEN
                FORALL k IN 1..ids.COUNT
                    INSERT /*+ APPEND PARALLEL(8) */ INTO general_test_data_550 (id, name, value, code, description, status, category, subcategory)
                    VALUES (ids(k), names(k), values_tab(k), codes(k), descriptions(k), statuses(k), categories(k), subcategories(k));
            ELSIF table_name = 'general_test_data_600' THEN
                FORALL k IN 1..ids.COUNT
                    INSERT /*+ APPEND PARALLEL(8) */ INTO general_test_data_600 (id, name, value, code, description, status, category, subcategory)
                    VALUES (ids(k), names(k), values_tab(k), codes(k), descriptions(k), statuses(k), categories(k), subcategories(k));
            ELSIF table_name = 'general_test_data_650' THEN
                FORALL k IN 1..ids.COUNT
                    INSERT /*+ APPEND PARALLEL(8) */ INTO general_test_data_650 (id, name, value, code, description, status, category, subcategory)
                    VALUES (ids(k), names(k), values_tab(k), codes(k), descriptions(k), statuses(k), categories(k), subcategories(k));
            ELSIF table_name = 'general_test_data_700' THEN
                FORALL k IN 1..ids.COUNT
                    INSERT /*+ APPEND PARALLEL(8) */ INTO general_test_data_700 (id, name, value, code, description, status, category, subcategory)
                    VALUES (ids(k), names(k), values_tab(k), codes(k), descriptions(k), statuses(k), categories(k), subcategories(k));
            ELSIF table_name = 'general_test_data_750' THEN
                FORALL k IN 1..ids.COUNT
                    INSERT /*+ APPEND PARALLEL(8) */ INTO general_test_data_750 (id, name, value, code, description, status, category, subcategory)
                    VALUES (ids(k), names(k), values_tab(k), codes(k), descriptions(k), statuses(k), categories(k), subcategories(k));
            ELSIF table_name = 'general_test_data_800' THEN
                FORALL k IN 1..ids.COUNT
                    INSERT /*+ APPEND PARALLEL(8) */ INTO general_test_data_800 (id, name, value, code, description, status, category, subcategory)
                    VALUES (ids(k), names(k), values_tab(k), codes(k), descriptions(k), statuses(k), categories(k), subcategories(k));
            ELSIF table_name = 'general_test_data_850' THEN
                FORALL k IN 1..ids.COUNT
                    INSERT /*+ APPEND PARALLEL(8) */ INTO general_test_data_850 (id, name, value, code, description, status, category, subcategory)
                    VALUES (ids(k), names(k), values_tab(k), codes(k), descriptions(k), statuses(k), categories(k), subcategories(k));
            ELSIF table_name = 'general_test_data_900' THEN
                FORALL k IN 1..ids.COUNT
                    INSERT /*+ APPEND PARALLEL(8) */ INTO general_test_data_900 (id, name, value, code, description, status, category, subcategory)
                    VALUES (ids(k), names(k), values_tab(k), codes(k), descriptions(k), statuses(k), categories(k), subcategories(k));
            ELSIF table_name = 'general_test_data_1000' THEN
                FORALL k IN 1..ids.COUNT
                    INSERT /*+ APPEND PARALLEL(8) */ INTO general_test_data_1000 (id, name, value, code, description, status, category, subcategory)
                    VALUES (ids(k), names(k), values_tab(k), codes(k), descriptions(k), statuses(k), categories(k), subcategories(k));
            END IF;
            
            -- Commit after each batch
            COMMIT;
            
            -- Log progress every 10 batches
            IF MOD(i, batch_size * 10) = 1 THEN
                log_message('INFO', 'Inserted ' || (i-1) || ' rows into ' || table_name, table_name, 'INSERT_PROGRESS');
            END IF;
            
            -- Increment the counter
            i := i + batch_size;
        END LOOP;
        
        -- Reset table to LOGGING mode
        set_logging(table_name);
        
        end_time := SYSTIMESTAMP;
        log_message('INFO', 'Completed data insertion for table ' || table_name || ' with ' || data_volume || ' rows in ' || 
                    EXTRACT(SECOND FROM (end_time - start_time)) || ' seconds', table_name, 'INSERT_COMPLETE');
    EXCEPTION
        WHEN OTHERS THEN
            log_message('ERROR', 'Error during data insertion for table ' || table_name || ': ' || SQLERRM, table_name, 'INSERT_ERROR');
            RAISE;
    END insert_data_bulk;
BEGIN
    -- Log start of execution
    log_message('INFO', 'Starting general data test procedure execution', NULL, 'PROCEDURE_START');
    
    -- Enable parallel DML for the session
    BEGIN
        EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';
        log_message('INFO', 'Enabled PARALLEL DML for session', NULL, 'ENABLE_PARALLEL_DML');
    EXCEPTION
        WHEN OTHERS THEN
            log_message('ERROR', 'Could not enable parallel DML: ' || SQLERRM, NULL, 'ENABLE_PARALLEL_DML');
    END;
    
    -- Insert data into each table using bulk operations
    insert_data_bulk('general_test_data_10', 0, 0);
    insert_data_bulk('general_test_data_50', 45, 90);
    insert_data_bulk('general_test_data_100', 95, 140);
    insert_data_bulk('general_test_data_150', 145, 190);
    insert_data_bulk('general_test_data_200', 195, 240);
    insert_data_bulk('general_test_data_250', 245, 290);
    insert_data_bulk('general_test_data_300', 295, 340);
    insert_data_bulk('general_test_data_350', 345, 390);
    insert_data_bulk('general_test_data_400', 395, 440);
    insert_data_bulk('general_test_data_450', 445, 490);
    insert_data_bulk('general_test_data_500', 495, 540);
    insert_data_bulk('general_test_data_550', 545, 590);
    insert_data_bulk('general_test_data_600', 595, 640);
    insert_data_bulk('general_test_data_650', 645, 690);
    insert_data_bulk('general_test_data_700', 695, 740);
    insert_data_bulk('general_test_data_750', 745, 790);
    insert_data_bulk('general_test_data_800', 795, 840);
    insert_data_bulk('general_test_data_850', 845, 890);
    insert_data_bulk('general_test_data_900', 895, 940);
    insert_data_bulk('general_test_data_1000', 995, 990);
    
    -- Disable parallel DML
    BEGIN
        EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';
        log_message('INFO', 'Disabled PARALLEL DML for session', NULL, 'DISABLE_PARALLEL_DML');
    EXCEPTION
        WHEN OTHERS THEN
            log_message('ERROR', 'Could not disable parallel DML: ' || SQLERRM, NULL, 'DISABLE_PARALLEL_DML');
    END;
    
    log_message('INFO', 'Data insertion completed successfully for all tables', NULL, 'PROCEDURE_COMPLETE');
EXCEPTION
    WHEN OTHERS THEN
        log_message('ERROR', 'General data test procedure failed: ' || SQLERRM, NULL, 'PROCEDURE_ERROR');
        ROLLBACK;
END;
/

