-- =============================================
-- BankVault Migration Project
-- Script : 01_raw_setup.sql
-- Purpose: Create RAW schema tables and load
--          data from internal stage
-- Author : Jothiyeaswar R
-- Date   : 2026
-- =============================================

USE DATABASE BANK_DW;
USE SCHEMA RAW;
USE WAREHOUSE BANK_WH;

-- ----------------------
-- File Format
-- ----------------------
CREATE OR REPLACE FILE FORMAT RAW.CSV_FORMAT
    TYPE = 'CSV'
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1
    NULL_IF = ('NULL', 'null', '')
    EMPTY_FIELD_AS_NULL = TRUE
    FIELD_OPTIONALLY_ENCLOSED_BY = '"';

-- ----------------------
-- Internal Stage
-- ----------------------
CREATE OR REPLACE STAGE RAW.BANK_STAGE
    FILE_FORMAT = RAW.CSV_FORMAT;

-- ----------------------
-- RAW Tables
-- ----------------------
CREATE OR REPLACE TABLE RAW.CUSTOMERS (
    CUSTOMER_ID         NUMBER,
    FIRST_NAME          VARCHAR(50),
    LAST_NAME           VARCHAR(50),
    EMAIL               VARCHAR(100),
    PHONE               VARCHAR(20),
    CITY                VARCHAR(50),
    DATE_OF_BIRTH       DATE,
    GENDER              VARCHAR(10),
    CUSTOMER_SEGMENT    VARCHAR(20),
    CREATED_DATE        DATE,
    IS_ACTIVE           VARCHAR(1)
);

CREATE OR REPLACE TABLE RAW.ACCOUNTS (
    CUSTOMER_ID     NUMBER,
    ACCOUNT_ID      NUMBER,
    ACCOUNT_NUMBER  VARCHAR(20),
    ACCOUNT_TYPE    VARCHAR(20),
    BRANCH_CODE     VARCHAR(10),
    OPEN_DATE       DATE,
    BALANCE         NUMBER(15,2),
    CURRENCY        VARCHAR(5),
    STATUS          VARCHAR(10)
);

CREATE OR REPLACE TABLE RAW.TRANSACTIONS (
    TRANSACTION_ID    NUMBER,
    ACCOUNT_ID        NUMBER,
    TRANSACTION_DATE  TIMESTAMP,
    TRANSACTION_TYPE  VARCHAR(10),
    AMOUNT            NUMBER(15,2),
    CHANNEL           VARCHAR(20),
    MERCHANT_CATEGORY VARCHAR(30),
    STATUS            VARCHAR(10),
    REMARKS           VARCHAR(100)
);

CREATE OR REPLACE TABLE RAW.LOANS (
    LOAN_ID            NUMBER,
    CUSTOMER_ID        NUMBER,
    ACCOUNT_ID         NUMBER,
    LOAN_TYPE          VARCHAR(30),
    LOAN_AMOUNT        NUMBER(15,2),
    INTEREST_RATE      NUMBER(5,2),
    TENURE_MONTHS      NUMBER,
    DISBURSEMENT_DATE  DATE,
    EMI_AMOUNT         NUMBER(15,2)
);

-- ----------------------
-- Load Data
-- ----------------------
COPY INTO RAW.CUSTOMERS
FROM @RAW.BANK_STAGE/customers.csv
FILE_FORMAT = RAW.CSV_FORMAT
ON_ERROR = 'CONTINUE';

COPY INTO RAW.ACCOUNTS
FROM @RAW.BANK_STAGE/accounts.csv
FILE_FORMAT = RAW.CSV_FORMAT
ON_ERROR = 'CONTINUE';

COPY INTO RAW.TRANSACTIONS
FROM @RAW.BANK_STAGE/transactions.csv
FILE_FORMAT = RAW.CSV_FORMAT
ON_ERROR = 'CONTINUE';

COPY INTO RAW.LOANS
FROM @RAW.BANK_STAGE/loans.csv
FILE_FORMAT = RAW.CSV_FORMAT
ON_ERROR = 'CONTINUE';

-- ----------------------
-- Validation
-- ----------------------
SELECT 'CUSTOMERS'    AS table_name, COUNT(*) AS row_count FROM RAW.CUSTOMERS
UNION ALL
SELECT 'ACCOUNTS'     AS table_name, COUNT(*) AS row_count FROM RAW.ACCOUNTS
UNION ALL
SELECT 'TRANSACTIONS' AS table_name, COUNT(*) AS row_count FROM RAW.TRANSACTIONS
UNION ALL
SELECT 'LOANS'        AS table_name, COUNT(*) AS row_count FROM RAW.LOANS;
