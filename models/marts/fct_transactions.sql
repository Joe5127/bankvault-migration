WITH stg_transactions AS (

    SELECT * FROM {{ ref('stg_transactions') }}

),

final AS (

    SELECT
        TRANSACTION_ID                      AS transaction_key,
        TRANSACTION_ID,
        ACCOUNT_ID,
        TRANSACTION_DATE,
        TRANSACTION_TYPE,
        AMOUNT,
        AMOUNT_CATEGORY,
        CHANNEL,
        MERCHANT_CATEGORY,
        STATUS,
        REMARKS,
        CURRENT_TIMESTAMP()                 AS dbt_loaded_at

    FROM stg_transactions

)

SELECT * FROM final