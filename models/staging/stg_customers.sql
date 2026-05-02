-- =============================================
-- Model    : stg_customers
-- Schema   : STAGING
-- Purpose  : Clean and standardise raw customer
--            data from source system
-- =============================================

WITH source AS (

    SELECT * FROM {{ source('raw', 'customers') }}

),

cleaned AS (

    SELECT
        CUSTOMER_ID,
        UPPER(FIRST_NAME)                    AS first_name,
        UPPER(LAST_NAME)                     AS last_name,
        LOWER(EMAIL)                         AS email,
        PHONE,
        UPPER(CITY)                          AS city,
        UPPER(GENDER)                        AS gender,
        UPPER(CUSTOMER_SEGMENT)              AS customer_segment,
        DATE_OF_BIRTH,
        DATEDIFF('year',
            DATE_OF_BIRTH,
            CURRENT_DATE())                  AS age,
        CREATED_DATE,
        CASE
            WHEN IS_ACTIVE = 'Y' THEN TRUE
            ELSE FALSE
        END                                  AS is_active,
        CURRENT_TIMESTAMP()                  AS dbt_loaded_at

    FROM source

    WHERE CUSTOMER_ID IS NOT NULL
      AND EMAIL IS NOT NULL

)

SELECT * FROM cleaned