# bankvault-migration
Oracle to Snowflake Banking Data migration Project Using DBT and Snowflake 
# BankVault — Oracle to Snowflake Migration

## Project Overview
End-to-end banking data migration project simulating a 
real-world Oracle to Snowflake migration using dbt 
for transformation and Snowflake for cloud data warehousing.

## Tech Stack
- Snowflake (RAW → STAGING → MARTS)
- dbt (staging models, tests, macros, snapshots)
- SQL (reconciliation, RBAC, performance tuning)

## Architecture
Source CSVs → Snowflake RAW → dbt Staging → dbt Marts → Reconciliation Report

## Datasets
- customers (10,000 rows)
- accounts (15,000 rows)
- transactions (50,000 rows)
- loans (5,000 rows)

## Project Status
🔄 In Progress — Week 1 of 4
