-- Data type test script
-- Test scenarios: Numeric types, character types, date types, binary types, boolean types, special types

-------------------------------------------------------------------------------
-- 1. Numeric type test table
-------------------------------------------------------------------------------
CREATE TABLE numeric_type_test_table (
    -- Integer types
    id NUMBER PRIMARY KEY,              -- Numeric type
    tinyint_col NUMBER(3),              -- Corresponds to TINYINT
    smallint_col NUMBER(5),             -- Corresponds to SMALLINT
    int_col NUMBER(10),                -- Corresponds to INT
    bigint_col NUMBER(19),              -- Corresponds to BIGINT
    
    -- Floating-point types
    float_col FLOAT,                    -- Floating-point
    real_col REAL,                      -- Single-precision floating-point
    double_col BINARY_DOUBLE,           -- Double-precision floating-point
    decimal_col NUMBER(10, 2),          -- Decimal
    
    -- Other numeric types
    number_col NUMBER,                  -- General numeric type
    number_prec_col NUMBER(10),         -- Numeric type with precision
    number_prec_scale_col NUMBER(10, 2) -- Numeric type with precision and scale
);

-- Insert numeric type test data
INSERT INTO numeric_type_test_table VALUES (
    1, 123, 12345, 1234567890, 1234567890123456789,
    123.45, 123.45, 123.45, 123.45,
    123, 1234567890, 12345678.90
);

-------------------------------------------------------------------------------
-- 2. Character type test table
-------------------------------------------------------------------------------
CREATE TABLE character_type_test_table (
    -- Basic character types
    id NUMBER PRIMARY KEY,
    char_col CHAR(10),               -- Fixed-length character
    varchar2_col VARCHAR2(100),      -- Variable-length character
    nchar_col NCHAR(10),             -- Fixed-length national character
    nvarchar2_col NVARCHAR2(100),    -- Variable-length national character
    clob_col CLOB,                   -- Character large object
    nclob_col NCLOB,                 -- National character large object
    long_col LONG                    -- Long string
);

-- Insert character type test data
INSERT INTO character_type_test_table VALUES (
    1, 'Fixed', 'Variable length string', N'国家字符', N'可变长度国家字符',
    'This is a CLOB test with multiple lines
Line 1
Line 2
Line 3',
    N'这是一个NCLOB测试，包含中文字符',
    'This is a LONG string test'
);

-------------------------------------------------------------------------------
-- 3. Date type test table
-------------------------------------------------------------------------------
CREATE TABLE date_type_test_table (
    -- Basic date types
    id NUMBER PRIMARY KEY,
    date_col DATE,                    -- Date type,
    
    -- TIMESTAMP types with different precisions
    timestamp_col TIMESTAMP,                    -- Default precision (6 decimal seconds)
    timestamp_prec_0 TIMESTAMP(0),              -- 0 decimal seconds
    timestamp_prec_3 TIMESTAMP(3),              -- 3 decimal seconds
    timestamp_prec_6 TIMESTAMP(6),              -- 6 decimal seconds
    timestamp_prec_9 TIMESTAMP(9),              -- 9 decimal seconds (maximum precision),
    
    -- TIMESTAMP types with time zone
    timestamp_tz_col TIMESTAMP WITH TIME ZONE,  -- Default precision with time zone
    timestamp_tz_prec_6 TIMESTAMP(6) WITH TIME ZONE,  -- 6 decimal seconds with time zone,
    
    -- TIMESTAMP types with local time zone
    timestamp_ltz_col TIMESTAMP WITH LOCAL TIME ZONE,  -- Default precision with local time zone
    timestamp_ltz_prec_6 TIMESTAMP(6) WITH LOCAL TIME ZONE  -- 6 decimal seconds with local time zone
);

-- Insert date type test data
INSERT INTO date_type_test_table VALUES (
    1, SYSDATE, SYSTIMESTAMP, SYSTIMESTAMP, SYSTIMESTAMP, SYSTIMESTAMP, SYSTIMESTAMP,
    SYSTIMESTAMP, SYSTIMESTAMP, SYSTIMESTAMP, SYSTIMESTAMP
);

-------------------------------------------------------------------------------
-- 4. Binary type test table
-------------------------------------------------------------------------------
CREATE TABLE binary_type_test_table (
    -- Binary types
    id NUMBER PRIMARY KEY,
    blob_col BLOB,                   -- Binary large object
    raw_col RAW(100),                -- Raw binary data
    long_raw_col LONG RAW            -- Long raw binary data
);

-- Insert binary type test data
INSERT INTO binary_type_test_table VALUES (
    1, 
    TO_BLOB('48454C4C4F'),           -- Hex representation of 'HELLO'
    HEXTORAW('48454C4C4F'),          -- Hex representation of 'HELLO'
    HEXTORAW('48454C4C4F')           -- Hex representation of 'HELLO'
);

-------------------------------------------------------------------------------
-- 5. Boolean type test table
-------------------------------------------------------------------------------
CREATE TABLE boolean_type_test_table (
    -- Boolean type
    id NUMBER PRIMARY KEY,
    bool_col BOOLEAN                 -- Boolean type
);

-- Insert boolean type test data
INSERT INTO boolean_type_test_table VALUES (1, TRUE);
INSERT INTO boolean_type_test_table VALUES (2, FALSE);

-------------------------------------------------------------------------------
-- 6. Special type test table
-------------------------------------------------------------------------------
CREATE TABLE special_type_test_table (
    -- Special types
    id NUMBER PRIMARY KEY,
    interval_ym_col INTERVAL YEAR TO MONTH,  -- Year to month interval
    interval_ds_col INTERVAL DAY TO SECOND,  -- Day to second interval
    rowid_col ROWID,                         -- Row identifier
    urowid_col UROWID                        -- Universal row identifier
);

-- Insert special type test data
INSERT INTO special_type_test_table VALUES (
    1, 
    INTERVAL '1-6' YEAR TO MONTH,     -- 1 year 6 months
    INTERVAL '2 10:30:45' DAY TO SECOND,  -- 2 days 10 hours 30 minutes 45 seconds
    NULL, NULL
);
