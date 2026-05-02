WITH stg_accounts AS (

    SELECT * FROM {{ ref('stg_accounts') }}

),

final AS (

    SELECT
        ACCOUNT_ID                          AS account_key,
        ACCOUNT_ID,
        CUSTOMER_ID,
        ACCOUNT_NUMBER,
        ACCOUNT_TYPE,
        BRANCH_CODE,
        OPEN_DATE,
        ACCOUNT_AGE_DAYS,
        BALANCE,
        BALANCE_CATEGORY,
        CURRENCY,
        STATUS,
        CURRENT_TIMESTAMP()                 AS dbt_loaded_at

    FROM stg_accounts

)

SELECT * FROM final