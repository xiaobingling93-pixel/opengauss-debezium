-- General size test scenarios for Oracle

-- Create log table for tracking execution
CREATE TABLE general_data_execution_log (
    log_id NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    log_time TIMESTAMP DEFAULT SYSTIMESTAMP,
    log_level VARCHAR2(20) NOT NULL,
    log_message VARCHAR2(4000) NOT NULL,
    table_name VARCHAR2(50),
    operation VARCHAR2(50)
)
/

-- Create 20 tables with different sizes (10-1000)
-- Each table has 8 columns with reasonable sizes

-- Table 1: varchar2(10)
CREATE TABLE general_test_data_10 (
    id NUMBER(10) PRIMARY KEY,
    name VARCHAR2(10) NOT NULL,        -- Main test field: 10 chars
    value NUMBER(10) NOT NULL,
    code VARCHAR2(10) NOT NULL,         -- Code: 10 chars
    description VARCHAR2(50) NOT NULL,  -- Description: 50 chars
    status VARCHAR2(10) NOT NULL,       -- Status: 10 chars
    category VARCHAR2(20) NOT NULL,     -- Category: 20 chars
    subcategory VARCHAR2(30) NOT NULL   -- Subcategory: 30 chars
)
/

-- Table 2: varchar2(50)
CREATE TABLE general_test_data_50 (
    id NUMBER(10) PRIMARY KEY,
    name VARCHAR2(50) NOT NULL,        -- Main test field: 50 chars
    value NUMBER(10) NOT NULL,
    code VARCHAR2(10) NOT NULL,
    description VARCHAR2(100) NOT NULL, -- Description: 100 chars
    status VARCHAR2(10) NOT NULL,
    category VARCHAR2(20) NOT NULL,
    subcategory VARCHAR2(30) NOT NULL
)
/

-- Table 3: varchar2(100)
CREATE TABLE general_test_data_100 (
    id NUMBER(10) PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,       -- Main test field: 100 chars
    value NUMBER(10) NOT NULL,
    code VARCHAR2(10) NOT NULL,
    description VARCHAR2(150) NOT NULL, -- Description: 150 chars
    status VARCHAR2(10) NOT NULL,
    category VARCHAR2(20) NOT NULL,
    subcategory VARCHAR2(30) NOT NULL
)
/

-- Table 4: varchar2(150)
CREATE TABLE general_test_data_150 (
    id NUMBER(10) PRIMARY KEY,
    name VARCHAR2(150) NOT NULL,       -- Main test field: 150 chars
    value NUMBER(10) NOT NULL,
    code VARCHAR2(10) NOT NULL,
    description VARCHAR2(200) NOT NULL, -- Description: 200 chars
    status VARCHAR2(10) NOT NULL,
    category VARCHAR2(20) NOT NULL,
    subcategory VARCHAR2(30) NOT NULL
)
/

-- Table 5: varchar2(200)
CREATE TABLE general_test_data_200 (
    id NUMBER(10) PRIMARY KEY,
    name VARCHAR2(200) NOT NULL,       -- Main test field: 200 chars
    value NUMBER(10) NOT NULL,
    code VARCHAR2(10) NOT NULL,
    description VARCHAR2(250) NOT NULL, -- Description: 250 chars
    status VARCHAR2(10) NOT NULL,
    category VARCHAR2(20) NOT NULL,
    subcategory VARCHAR2(50) NOT NULL  -- Subcategory: 50 chars
)
/

-- Table 6: varchar2(250)
CREATE TABLE general_test_data_250 (
    id NUMBER(10) PRIMARY KEY,
    name VARCHAR2(250) NOT NULL,       -- Main test field: 250 chars
    value NUMBER(10) NOT NULL,
    code VARCHAR2(10) NOT NULL,
    description VARCHAR2(300) NOT NULL, -- Description: 300 chars
    status VARCHAR2(10) NOT NULL,
    category VARCHAR2(20) NOT NULL,
    subcategory VARCHAR2(50) NOT NULL
)
/

-- Table 7: varchar2(300)
CREATE TABLE general_test_data_300 (
    id NUMBER(10) PRIMARY KEY,
    name VARCHAR2(300) NOT NULL,       -- Main test field: 300 chars
    value NUMBER(10) NOT NULL,
    code VARCHAR2(10) NOT NULL,
    description VARCHAR2(350) NOT NULL, -- Description: 350 chars
    status VARCHAR2(10) NOT NULL,
    category VARCHAR2(20) NOT NULL,
    subcategory VARCHAR2(50) NOT NULL
)
/

-- Table 8: varchar2(350)
CREATE TABLE general_test_data_350 (
    id NUMBER(10) PRIMARY KEY,
    name VARCHAR2(350) NOT NULL,       -- Main test field: 350 chars
    value NUMBER(10) NOT NULL,
    code VARCHAR2(10) NOT NULL,
    description VARCHAR2(400) NOT NULL, -- Description: 400 chars
    status VARCHAR2(10) NOT NULL,
    category VARCHAR2(20) NOT NULL,
    subcategory VARCHAR2(50) NOT NULL
)
/

-- Table 9: varchar2(400)
CREATE TABLE general_test_data_400 (
    id NUMBER(10) PRIMARY KEY,
    name VARCHAR2(400) NOT NULL,       -- Main test field: 400 chars
    value NUMBER(10) NOT NULL,
    code VARCHAR2(10) NOT NULL,
    description VARCHAR2(450) NOT NULL, -- Description: 450 chars
    status VARCHAR2(10) NOT NULL,
    category VARCHAR2(20) NOT NULL,
    subcategory VARCHAR2(50) NOT NULL
)
/

-- Table 10: varchar2(450)
CREATE TABLE general_test_data_450 (
    id NUMBER(10) PRIMARY KEY,
    name VARCHAR2(450) NOT NULL,       -- Main test field: 450 chars
    value NUMBER(10) NOT NULL,
    code VARCHAR2(10) NOT NULL,
    description VARCHAR2(500) NOT NULL, -- Description: 500 chars
    status VARCHAR2(10) NOT NULL,
    category VARCHAR2(20) NOT NULL,
    subcategory VARCHAR2(50) NOT NULL
)
/

-- Table 11: varchar2(500)
CREATE TABLE general_test_data_500 (
    id NUMBER(10) PRIMARY KEY,
    name VARCHAR2(500) NOT NULL,       -- Main test field: 500 chars
    value NUMBER(10) NOT NULL,
    code VARCHAR2(10) NOT NULL,
    description VARCHAR2(550) NOT NULL, -- Description: 550 chars
    status VARCHAR2(10) NOT NULL,
    category VARCHAR2(20) NOT NULL,
    subcategory VARCHAR2(50) NOT NULL
)
/

-- Table 12: varchar2(550)
CREATE TABLE general_test_data_550 (
    id NUMBER(10) PRIMARY KEY,
    name VARCHAR2(550) NOT NULL,       -- Main test field: 550 chars
    value NUMBER(10) NOT NULL,
    code VARCHAR2(10) NOT NULL,
    description VARCHAR2(600) NOT NULL, -- Description: 600 chars
    status VARCHAR2(10) NOT NULL,
    category VARCHAR2(20) NOT NULL,
    subcategory VARCHAR2(50) NOT NULL
)
/

-- Table 13: varchar2(600)
CREATE TABLE general_test_data_600 (
    id NUMBER(10) PRIMARY KEY,
    name VARCHAR2(600) NOT NULL,       -- Main test field: 600 chars
    value NUMBER(10) NOT NULL,
    code VARCHAR2(10) NOT NULL,
    description VARCHAR2(650) NOT NULL, -- Description: 650 chars
    status VARCHAR2(10) NOT NULL,
    category VARCHAR2(20) NOT NULL,
    subcategory VARCHAR2(50) NOT NULL
)
/

-- Table 14: varchar2(650)
CREATE TABLE general_test_data_650 (
    id NUMBER(10) PRIMARY KEY,
    name VARCHAR2(650) NOT NULL,       -- Main test field: 650 chars
    value NUMBER(10) NOT NULL,
    code VARCHAR2(10) NOT NULL,
    description VARCHAR2(700) NOT NULL, -- Description: 700 chars
    status VARCHAR2(10) NOT NULL,
    category VARCHAR2(20) NOT NULL,
    subcategory VARCHAR2(50) NOT NULL
)
/

-- Table 15: varchar2(700)
CREATE TABLE general_test_data_700 (
    id NUMBER(10) PRIMARY KEY,
    name VARCHAR2(700) NOT NULL,       -- Main test field: 700 chars
    value NUMBER(10) NOT NULL,
    code VARCHAR2(10) NOT NULL,
    description VARCHAR2(750) NOT NULL, -- Description: 750 chars
    status VARCHAR2(10) NOT NULL,
    category VARCHAR2(20) NOT NULL,
    subcategory VARCHAR2(50) NOT NULL
)
/

-- Table 16: varchar2(750)
CREATE TABLE general_test_data_750 (
    id NUMBER(10) PRIMARY KEY,
    name VARCHAR2(750) NOT NULL,       -- Main test field: 750 chars
    value NUMBER(10) NOT NULL,
    code VARCHAR2(10) NOT NULL,
    description VARCHAR2(800) NOT NULL, -- Description: 800 chars
    status VARCHAR2(10) NOT NULL,
    category VARCHAR2(20) NOT NULL,
    subcategory VARCHAR2(50) NOT NULL
)
/

-- Table 17: varchar2(800)
CREATE TABLE general_test_data_800 (
    id NUMBER(10) PRIMARY KEY,
    name VARCHAR2(800) NOT NULL,       -- Main test field: 800 chars
    value NUMBER(10) NOT NULL,
    code VARCHAR2(10) NOT NULL,
    description VARCHAR2(850) NOT NULL, -- Description: 850 chars
    status VARCHAR2(10) NOT NULL,
    category VARCHAR2(20) NOT NULL,
    subcategory VARCHAR2(50) NOT NULL
)
/

-- Table 18: varchar2(850)
CREATE TABLE general_test_data_850 (
    id NUMBER(10) PRIMARY KEY,
    name VARCHAR2(850) NOT NULL,       -- Main test field: 850 chars
    value NUMBER(10) NOT NULL,
    code VARCHAR2(10) NOT NULL,
    description VARCHAR2(900) NOT NULL, -- Description: 900 chars
    status VARCHAR2(10) NOT NULL,
    category VARCHAR2(20) NOT NULL,
    subcategory VARCHAR2(50) NOT NULL
)
/

-- Table 19: varchar2(900)
CREATE TABLE general_test_data_900 (
    id NUMBER(10) PRIMARY KEY,
    name VARCHAR2(900) NOT NULL,       -- Main test field: 900 chars
    value NUMBER(10) NOT NULL,
    code VARCHAR2(10) NOT NULL,
    description VARCHAR2(950) NOT NULL, -- Description: 950 chars
    status VARCHAR2(10) NOT NULL,
    category VARCHAR2(20) NOT NULL,
    subcategory VARCHAR2(50) NOT NULL
)
/

-- Table 20: varchar2(1000)
CREATE TABLE general_test_data_1000 (
    id NUMBER(10) PRIMARY KEY,
    name VARCHAR2(1000) NOT NULL,      -- Main test field: 1000 chars
    value NUMBER(10) NOT NULL,
    code VARCHAR2(10) NOT NULL,
    description VARCHAR2(1000) NOT NULL, -- Description: 1000 chars
    status VARCHAR2(10) NOT NULL,
    category VARCHAR2(20) NOT NULL,
    subcategory VARCHAR2(50) NOT NULL
)
/
