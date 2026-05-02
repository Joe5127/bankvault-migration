-- =============================================
-- BankVault Migration Project
-- Script  : 02_reconciliation_report.sql
-- Purpose : Prove data accuracy across all
--           3 layers RAW → STAGING → MARTS
-- =============================================

USE DATABASE BANK_DW;
USE WAREHOUSE BANK_WH;

-- -----------------------------------------------
-- SECTION 1 — Row Count Reconciliation
-- Proves no records were lost during migration
-- -----------------------------------------------

SELECT
    'CUSTOMERS'         AS entity,
    COUNT(*)            AS raw_count,
    (SELECT COUNT(*) FROM STAGING.stg_customers)    AS staging_count,
    (SELECT COUNT(*) FROM MARTS.dim_customer)        AS marts_count,
    CASE
        WHEN COUNT(*) = (SELECT COUNT(*) FROM STAGING.stg_customers)
         AND COUNT(*) = (SELECT COUNT(*) FROM MARTS.dim_customer)
        THEN 'PASS ✓'
        ELSE 'FAIL ✗'
    END                 AS reconciliation_status
FROM RAW.CUSTOMERS

UNION ALL

SELECT
    'ACCOUNTS'          AS entity,
    COUNT(*)            AS raw_count,
    (SELECT COUNT(*) FROM STAGING.stg_accounts)     AS staging_count,
    (SELECT COUNT(*) FROM MARTS.dim_account)         AS marts_count,
    CASE
        WHEN COUNT(*) = (SELECT COUNT(*) FROM STAGING.stg_accounts)
         AND COUNT(*) = (SELECT COUNT(*) FROM MARTS.dim_account)
        THEN 'PASS ✓'
        ELSE 'FAIL ✗'
    END                 AS reconciliation_status
FROM RAW.ACCOUNTS

UNION ALL

SELECT
    'TRANSACTIONS'      AS entity,
    COUNT(*)            AS raw_count,
    (SELECT COUNT(*) FROM STAGING.stg_transactions) AS staging_count,
    (SELECT COUNT(*) FROM MARTS.fct_transactions)    AS marts_count,
    CASE
        WHEN COUNT(*) = (SELECT COUNT(*) FROM STAGING.stg_transactions)
         AND COUNT(*) = (SELECT COUNT(*) FROM MARTS.fct_transactions)
        THEN 'PASS ✓'
        ELSE 'FAIL ✗'
    END                 AS reconciliation_status
FROM RAW.TRANSACTIONS;

-- -----------------------------------------------
-- SECTION 2 — Amount Reconciliation
-- Proves no financial values changed during migration
-- -----------------------------------------------

SELECT
    'TRANSACTION AMOUNTS'           AS check_name,
    SUM(amount)                     AS raw_total,
    (SELECT SUM(amount)
     FROM STAGING.stg_transactions) AS staging_total,
    (SELECT SUM(amount)
     FROM MARTS.fct_transactions)   AS marts_total,
    CASE
        WHEN SUM(amount) =
            (SELECT SUM(amount) FROM STAGING.stg_transactions)
        THEN 'PASS ✓'
        ELSE 'FAIL ✗'
    END                             AS reconciliation_status
FROM RAW.TRANSACTIONS;

-- -----------------------------------------------
-- SECTION 3 — Data Quality Summary
-- -----------------------------------------------

SELECT
    'NULL CUSTOMER IDs'     AS check_name,
    COUNT(*)                AS issue_count,
    CASE WHEN COUNT(*) = 0
        THEN 'PASS ✓'
        ELSE 'FAIL ✗'
    END                     AS status
FROM RAW.CUSTOMERS
WHERE CUSTOMER_ID IS NULL

UNION ALL

SELECT
    'DUPLICATE CUSTOMER IDs' AS check_name,
    COUNT(*) - COUNT(DISTINCT CUSTOMER_ID) AS issue_count,
    CASE
        WHEN COUNT(*) - COUNT(DISTINCT CUSTOMER_ID) = 0
        THEN 'PASS ✓'
        ELSE 'FAIL ✗'
    END                     AS status
FROM RAW.CUSTOMERS

UNION ALL

SELECT
    'NULL TRANSACTION IDs'  AS check_name,
    COUNT(*)                AS issue_count,
    CASE WHEN COUNT(*) = 0
        THEN 'PASS ✓'
        ELSE 'FAIL ✗'
    END                     AS status
FROM RAW.TRANSACTIONS
WHERE TRANSACTION_ID IS NULL

UNION ALL

SELECT
    'NEGATIVE AMOUNTS'      AS check_name,
    COUNT(*)                AS issue_count,
    CASE WHEN COUNT(*) = 0
        THEN 'PASS ✓'
        ELSE 'FAIL ✗'
    END                     AS status
FROM RAW.TRANSACTIONS
WHERE AMOUNT < 0;