# BankVault — Oracle to Snowflake Banking Migration

![Snowflake](https://img.shields.io/badge/Snowflake-29B5E8?style=flat&logo=snowflake&logoColor=white)
![dbt](https://img.shields.io/badge/dbt-FF694B?style=flat&logo=dbt&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-4479A1?style=flat&logo=mysql&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat&logo=github&logoColor=white)

## Project Overview

End-to-end banking data migration project simulating a real-world 
Oracle to Snowflake migration for a retail banking domain. Built using 
Snowflake as the cloud data warehouse and dbt for data transformation, 
this project covers the complete data engineering lifecycle — from raw 
ingestion to dimensional modelling, data quality testing, security 
setup, and data recovery.

---

## Architecture


Source CSVs (Oracle Simulated)
↓
Snowflake RAW Schema      → 4 tables, 4,000 records loaded via COPY INTO
↓
dbt Staging Layer         → 4 views, cleaned and standardised
↓
dbt Marts Layer           → Star schema (1 fact + 3 dimensions)
↓
Reconciliation Report     → 100% accuracy validated across all layers



---

## Tech Stack

| Tool | Purpose |
|---|---|
| Snowflake | Cloud data warehouse |
| dbt Cloud | Data transformation and testing |
| SQL | Data modelling and validation |
| GitHub | Version control and portfolio |

---

## Dataset

| Table | Rows | Description |
|---|---|---|
| customers | 1,000 | Retail banking customers |
| accounts | 1,000 | Customer bank accounts |
| transactions | 1,000 | Financial transactions |
| loans | 1,000 | Customer loan records |

---

## Project Structure


bankvault-migration/
├── models/
│   ├── staging/
│   │   ├── sources.yml          # Source definitions and tests
│   │   ├── stg_customers.sql    # Cleaned customer data
│   │   ├── stg_accounts.sql     # Cleaned accounts data
│   │   ├── stg_transactions.sql # Cleaned transactions data
│   │   └── stg_loans.sql        # Cleaned loans data
│   └── marts/
│       ├── dim_customer.sql     # Customer dimension
│       ├── dim_account.sql      # Account dimension
│       ├── dim_date.sql         # Date dimension
│       └── fct_transactions.sql # Transaction fact table
├── scripts/
│   ├── 01_raw_setup.sql         # RAW layer setup and data load
│   ├── 02_reconciliation_report.sql  # Migration accuracy validation
│   ├── 03_rbac_setup.sql        # Role based access control
│   └── 04_time_travel_recovery.sql   # Data recovery demonstration
└── docs/
└── reconciliation_results.png    # Screenshot proof

---

## Data Pipeline

### Layer 1 — RAW
- Loaded 4,000 banking records from CSV sources
- Used Snowflake internal stages and COPY INTO
- Created file formats for CSV parsing

### Layer 2 — STAGING (dbt)
- Built 4 dbt staging models with cleaning logic
- Applied UPPER/LOWER standardisation
- Added derived columns — age, account_age_days, amount_category
- Implemented 15+ dbt schema tests — not_null, unique, accepted_values
- All tests passing with zero failures

### Layer 3 — MARTS (dbt)
- Designed star schema with 1 fact table and 3 dimension tables
- dim_customer — 1,000 rows
- dim_account — 1,000 rows  
- dim_date — 1,095 rows (3 years of dates)
- fct_transactions — 1,000 rows

---

## Reconciliation Results

| Entity | RAW | STAGING | MARTS | Status |
|---|---|---|---|---|
| Customers | 1,000 | 1,000 | 1,000 | PASS |
| Accounts | 1,000 | 1,000 | 1,000 | PASS |
| Transactions | 1,000 | 1,000 | 1,000 | PASS |
| Transaction Amounts | 49,557.00 | 49,557.00 | 49,557.00 | PASS |

**Migration accuracy: 100% — zero data loss across all layers**

---

## Data Quality Checks

| Check | Issues Found | Status |
|---|---|---|
| NULL Customer IDs | 0 | PASS |
| Duplicate Customer IDs | 0 | PASS |
| NULL Transaction IDs | 0 | PASS |
| Negative Amounts | 0 | PASS |

---

## Security — RBAC Implementation

Created 4 roles following least privilege principles:

| Role | Access Level |
|---|---|
| BANKVAULT_ADMIN | Full access to all schemas |
| BANKVAULT_DE | Read and write all schemas |
| BANKVAULT_ANALYST | Read only — MARTS schema |
| BANKVAULT_REPORTING | Read only — specific mart tables |

---

## Snowflake Time Travel — Data Recovery

Simulated accidental deletion of 100 customer records and 
recovered all data using Snowflake Time Travel BEFORE STATEMENT 
syntax — full recovery achieved in under 5 seconds.

| Stage | Row Count |
|---|---|
| Before deletion | 1,000 |
| After accidental deletion | 900 |
| After Time Travel recovery | 1,000 |

---

## Key Learnings

- Designed and implemented a 3-layer data architecture 
  (RAW → STAGING → MARTS) following medallion architecture principles
- Built production-grade dbt models with incremental logic and 
  comprehensive data quality tests
- Implemented banking-grade RBAC security with least-privilege access
- Demonstrated Snowflake advanced features — Time Travel, 
  Zero-Copy Cloning concepts, clustering keys
- Delivered 100% reconciliation accuracy across all migration layers

---

## Author

**Jothiyeaswar R**  
Data Engineer | Snowflake | dbt | SQL  
📧 jothiyeaswar.r1tcs@gmail.com
