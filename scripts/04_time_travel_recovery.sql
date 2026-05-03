-- =============================================
-- BankVault Migration Project
-- Script  : 04_time_travel_recovery.sql
-- Purpose : Demonstrate Snowflake Time Travel
--           for data recovery scenarios
-- =============================================

USE DATABASE BANK_DW;
USE SCHEMA RAW;
USE WAREHOUSE BANK_WH;

-- -----------------------------------------------
-- SECTION 1 — Check row count before deletion
-- -----------------------------------------------

SELECT 'BEFORE DELETE' AS stage, COUNT(*) AS row_count
FROM RAW.CUSTOMERS;

-- -----------------------------------------------
-- SECTION 2 — Simulate accidental deletion
-- Delete 100 customers accidentally
-- -----------------------------------------------

DELETE FROM RAW.CUSTOMERS
WHERE CUSTOMER_ID <= 100;

-- -----------------------------------------------
-- SECTION 3 — Confirm rows are deleted
-- -----------------------------------------------

SELECT 'AFTER DELETE' AS stage, COUNT(*) AS row_count
FROM RAW.CUSTOMERS;

-- -----------------------------------------------
-- SECTION 4 — Recover using Time Travel
-- Go back to before the delete happened
-- -----------------------------------------------

CREATE OR REPLACE TABLE RAW.CUSTOMERS AS
SELECT * FROM RAW.CUSTOMERS
BEFORE (STATEMENT => LAST_QUERY_ID(-2));

-- -----------------------------------------------
-- SECTION 5 — Confirm full recovery
-- -----------------------------------------------

SELECT 'AFTER RECOVERY' AS stage, COUNT(*) AS row_count
FROM RAW.CUSTOMERS;

-- -----------------------------------------------
-- SECTION 6 — Verify recovered records
-- -----------------------------------------------

SELECT *
FROM RAW.CUSTOMERS
WHERE CUSTOMER_ID <= 100
LIMIT 10;
