WITH source AS (

    SELECT * FROM {{ source('raw', 'loans') }}

),

cleaned AS (

    SELECT
        LOAN_ID,
        CUSTOMER_ID,
        ACCOUNT_ID,
        UPPER(LOAN_TYPE)                    AS loan_type,
        LOAN_AMOUNT,
        INTEREST_RATE,
        TENURE_MONTHS,
        DISBURSEMENT_DATE,
        EMI_AMOUNT,
        CASE
            WHEN LOAN_AMOUNT >= 1000000 THEN 'HIGH VALUE'
            WHEN LOAN_AMOUNT >= 100000  THEN 'MEDIUM VALUE'
            ELSE 'LOW VALUE'
        END                                 AS loan_category,
        ROUND(
            (EMI_AMOUNT * TENURE_MONTHS), 2
        )                                   AS total_repayment_amount,
        CURRENT_TIMESTAMP()                 AS dbt_loaded_at

    FROM source

    WHERE LOAN_ID IS NOT NULL
      AND CUSTOMER_ID IS NOT NULL

)

SELECT * FROM cleaned