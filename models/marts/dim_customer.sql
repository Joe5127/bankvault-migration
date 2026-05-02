WITH stg_customers AS (

    SELECT * FROM {{ ref('stg_customers') }}

),

final AS (

    SELECT
        CUSTOMER_ID                         AS customer_key,
        CUSTOMER_ID,
        FIRST_NAME,
        LAST_NAME,
        FIRST_NAME || ' ' || LAST_NAME      AS full_name,
        EMAIL,
        PHONE,
        CITY,
        GENDER,
        CUSTOMER_SEGMENT,
        DATE_OF_BIRTH,
        AGE,
        CREATED_DATE,
        IS_ACTIVE,
        CURRENT_TIMESTAMP()                 AS dbt_loaded_at

    FROM stg_customers

)

SELECT * FROM final