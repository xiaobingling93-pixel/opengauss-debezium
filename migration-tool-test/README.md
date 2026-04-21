# Migration Tool Test

This is a standalone test project for the Oracle to oGRAC migration tool, specifically designed to manage test environment setup and cleanup for oracle2ograc migration scenarios.

## Key Features

- **Environment Cleanup**: Automatically cleans up test objects (tables, indexes, triggers, etc.) from both source (Oracle) and target (oGRAC) databases
- **Test Data Preparation**: Prepares test environments with various test scenarios and data sets
- **Database-specific SQL Handling**: Provides database-specific SQL statements for both Oracle and oGRAC
- **Parallel Execution**: Cleans up source and target databases in parallel for improved performance
- **Configurable**: Uses YAML configuration files for easy customization

## Constraints

- **Oracle to oGRAC Only**: This tool is specifically designed for Oracle to oGRAC migration testing and may not work with other database combinations
- **Database Privileges**: Requires sufficient privileges to create, drop, and modify database objects in both source and target databases
- **Java 17+ Required**: Built and tested with Java 17, may not work with older Java versions

## Warning

**DO NOT USE IN PRODUCTION ENVIRONMENTS**

This tool is designed for testing purposes only and will automatically clean up all database objects (tables, indexes, triggers, procedures, functions, views, sequences) from both source and target databases. Using this tool in a production environment will result in data loss.

**Always test in a controlled, non-production environment.**

## Project Structure

```
migration-tool-test/
├── config/                  # Configuration files
│   └── config.yml           # Test configuration
├── src/
│   ├── main/
│      ├── java/org/full/migration/test/
│      │   ├── cli/         # Command line interface
│      │   ├── command/      # Test commands
│      │   ├── cleanup/      # Environment cleanup services
│      │   ├── config/       # Configuration management
│      │   ├── manager/      # Test environment manager
│      │   └── sql/          # SQL providers
│      └── resources/        # Resources
│          └── logback.xml   #  log configuration
├── lib/                    # External libraries
├── pom.xml                 # Maven configuration
└── README.md               # This file
```

## Prerequisites

- Java 17+
- Maven 3.6+
- Oracle database 19+
- oGRAC database

## Configuration

1. Copy the configuration template and update it with your database connection details:

```bash
cp config/config.yml config/your_config.yml
```

2. Edit `config/your_config.yml` with your database connection details:

```yaml
# Test environment configuration

# Source database configuration
source:
  url: jdbc:oracle:thin:@//localhost:1521/ORCL
  username: your_username_oracle
  password: your_password

# Target database configuration
target:
  url: jdbc:oGRAC://localhost:5432
  username: your_username_ograc
  password: your_password

# Test scenario configuration
test:
  log: enabled  # Enable/disable test logging
  scenarioPath: ./oracle_test_scenario
  # Script execution configuration
  scripts:
    # Whether to execute the general data procedure script (default: false)
    executeGeneralDataProcedure: false
```

## Build

```bash
mvn clean package
```

## Usage

### Clean up test environment

```bash
java -jar migration-tool-test-1.0.jar --action cleanup --config config/your_config.yml
```

### Prepare test environment with test data

```bash
java -jar migration-tool-test-1.0.jar --action prepare --config config/your_config.yml --scenario constraint
```

### Check data generation status

```bash
java -jar migration-tool-test-1.0.jar --action check --config config/your_config.yml
```

**Expected Output:**

```
TABLE_NAME                     TABLESPACE_NAME   NUM_ROWS    AVG_ROW_LEN  LAST_ANALYZED          ESTIMATED_GB
----------------------------------------------------------------------------------------------------
TABLE_1                        USERS             100000      42           2026-04-15 10:30:00.0   0.00
TABLE_2                        USERS             50000       128          2026-04-15 10:30:05.0   0.01
TABLE_3                        USERS             200000      256          2026-04-15 10:30:10.0   0.05
----------------------------------------------------------------------------------------------------
TOTAL                                                   350000                                  0.06 GB
----------------------------------------------------------------------------------------------------

USERS TABLESPACE USAGE:
----------------------------------------------------------------------------------------------------
TABLESPACE_NAME   GB_USED   GB_MAX   PCT_USED
----------------------------------------------------------------------------------------------------
USERS             5.23      10.00    52.30%
----------------------------------------------------------------------------------------------------
```

**Output Fields:**

| Field | Description |
|-------|-------------|
| TABLE_NAME | Name of the database table |
| TABLESPACE_NAME | Tablespace where the table is stored |
| NUM_ROWS | Number of rows in the table (statistics from user_tables) |
| AVG_ROW_LEN | Average row length in bytes |
| LAST_ANALYZED | Last time table statistics were gathered |
| ESTIMATED_GB | Estimated table size in GB (num_rows * avg_row_len / 1024 / 1024 / 1024) |
| GB_USED | Actual tablespace usage in GB |
| GB_MAX | Maximum tablespace size in GB |
| PCT_USED | Percentage of tablespace usage |


## Test Scenarios

The test scenarios are located in `oracle_test_scenario/` directory. Each subdirectory represents a test scenario:

- `combined/` - Combined test scenarios
- `constraint/` - Constraint test scenarios
- `data_type/` - Data type test scenarios
- `foreign_key/` - Foreign key test scenarios
- `function/` - Function test scenarios
- `general_data/` - General data test scenarios
- `index/` - Index test scenarios
- `procedure/` - Procedure test scenarios
- `sequence/` - Sequence test scenarios
- `table_structure/` - Table structure test scenarios
- `trigger/` - Trigger test scenarios
- `view/` - View test scenarios

## Troubleshooting

- **Connection issues**: Check your database connection details in the configuration file
- **Permission issues**: Ensure your database user has sufficient permissions to create and drop objects
- **Script execution issues**: Check the SQL scripts in the test scenario directory for syntax errors
- **Data insertion issues**: If you encounter performance issues with data insertion, you can disable the general data procedure script by setting `executeGeneralDataProcedure: false` in the configuration file
- **Table creation issues**: If tables are not being created, check the database user permissions and ensure there are no existing tables with the same names
