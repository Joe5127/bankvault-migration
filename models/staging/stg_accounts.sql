-- =============================================
-- Model    : stg_accounts
-- Schema   : STAGING
-- Purpose  : Clean and standardise raw accounts
--            data from source system
-- =============================================

WITH source AS (

    SELECT * FROM {{ source('raw', 'accounts') }}

),

cleaned AS (

    SELECT
        ACCOUNT_ID,
        CUSTOMER_ID,
        UPPER(ACCOUNT_NUMBER)               AS account_number,
        UPPER(ACCOUNT_TYPE)                 AS account_type,
        UPPER(BRANCH_CODE)                  AS branch_code,
        OPEN_DATE,
        DATEDIFF('day',
            OPEN_DATE,
            CURRENT_DATE())                 AS account_age_days,
        BALANCE,
        CASE
            WHEN BALANCE >= 100000 THEN 'HIGH'
            WHEN BALANCE >= 10000  THEN 'MEDIUM'
            ELSE 'LOW'
        END                                 AS balance_category,
        UPPER(CURRENCY)                     AS currency,
        UPPER(STATUS)                       AS status,
        CURRENT_TIMESTAMP()                 AS dbt_loaded_at

    FROM source

    WHERE ACCOUNT_ID IS NOT NULL
      AND CUSTOMER_ID IS NOT NULL

)

SELECT * FROM cleaned