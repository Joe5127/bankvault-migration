WITH date_spine AS (

    SELECT
        DATEADD(DAY, SEQ4(), '2022-01-01')  AS date_day
    FROM TABLE(GENERATOR(ROWCOUNT => 1095))

),

final AS (

    SELECT
        date_day                                        AS date_key,
        date_day,
        YEAR(date_day)                                  AS year,
        MONTH(date_day)                                 AS month,
        DAY(date_day)                                   AS day,
        DAYOFWEEK(date_day)                             AS day_of_week,
        DAYNAME(date_day)                               AS day_name,
        MONTHNAME(date_day)                             AS month_name,
        QUARTER(date_day)                               AS quarter,
        CASE
            WHEN DAYOFWEEK(date_day) IN (1, 7)
            THEN FALSE
            ELSE TRUE
        END                                             AS is_weekday

    FROM date_spine

)

SELECT * FROM final