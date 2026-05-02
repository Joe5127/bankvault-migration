-- =============================================
-- BankVault Migration Project
-- Script  : 03_rbac_setup.sql
-- Purpose : Implement role based access control
--           following least privilege principles
-- =============================================

USE DATABASE BANK_DW;
USE WAREHOUSE BANK_WH;

-- -----------------------------------------------
-- SECTION 1 — Create Roles
-- -----------------------------------------------

-- Admin role - full access to everything
CREATE ROLE IF NOT EXISTS BANKVAULT_ADMIN;

-- Data engineer role - can read and write all schemas
CREATE ROLE IF NOT EXISTS BANKVAULT_DE;

-- Analyst role - can only read MARTS layer
CREATE ROLE IF NOT EXISTS BANKVAULT_ANALYST;

-- Reporting role - read only access to specific marts tables
CREATE ROLE IF NOT EXISTS BANKVAULT_REPORTING;

-- -----------------------------------------------
-- SECTION 2 — Grant Database Access
-- -----------------------------------------------

-- Admin gets full control
GRANT ALL PRIVILEGES ON DATABASE BANK_DW
    TO ROLE BANKVAULT_ADMIN;

-- Data engineer gets full access to all schemas
GRANT USAGE ON DATABASE BANK_DW
    TO ROLE BANKVAULT_DE;
GRANT USAGE ON ALL SCHEMAS IN DATABASE BANK_DW
    TO ROLE BANKVAULT_DE;
GRANT ALL PRIVILEGES ON ALL TABLES IN DATABASE BANK_DW
    TO ROLE BANKVAULT_DE;

-- Analyst gets read only access to MARTS
GRANT USAGE ON DATABASE BANK_DW
    TO ROLE BANKVAULT_ANALYST;
GRANT USAGE ON SCHEMA BANK_DW.MARTS
    TO ROLE BANKVAULT_ANALYST;
GRANT SELECT ON ALL TABLES IN SCHEMA BANK_DW.MARTS
    TO ROLE BANKVAULT_ANALYST;

-- Reporting gets read only access to specific tables
GRANT USAGE ON DATABASE BANK_DW
    TO ROLE BANKVAULT_REPORTING;
GRANT USAGE ON SCHEMA BANK_DW.MARTS
    TO ROLE BANKVAULT_REPORTING;
GRANT SELECT ON TABLE BANK_DW.MARTS.FCT_TRANSACTIONS
    TO ROLE BANKVAULT_REPORTING;
GRANT SELECT ON TABLE BANK_DW.MARTS.DIM_CUSTOMER
    TO ROLE BANKVAULT_REPORTING;

-- -----------------------------------------------
-- SECTION 3 — Grant Warehouse Access
-- -----------------------------------------------

GRANT USAGE ON WAREHOUSE BANK_WH
    TO ROLE BANKVAULT_DE;
GRANT USAGE ON WAREHOUSE BANK_WH
    TO ROLE BANKVAULT_ANALYST;
GRANT USAGE ON WAREHOUSE BANK_WH
    TO ROLE BANKVAULT_REPORTING;

-- -----------------------------------------------
-- SECTION 4 — Role Hierarchy
-- Admin owns all roles below it
-- -----------------------------------------------

GRANT ROLE BANKVAULT_DE         TO ROLE BANKVAULT_ADMIN;
GRANT ROLE BANKVAULT_ANALYST    TO ROLE BANKVAULT_ADMIN;
GRANT ROLE BANKVAULT_REPORTING  TO ROLE BANKVAULT_ADMIN;

-- -----------------------------------------------
-- SECTION 5 — Verify roles created
-- -----------------------------------------------

SHOW ROLES LIKE 'BANKVAULT%';
