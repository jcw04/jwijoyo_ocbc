{{
    config(
            materialized = 'table'
         )
}}

WITH CLEAN_DATA AS (
    SELECT
        GENDER,
        CUSTOMER_INCOME,
        CAST(CUSTOMER_ID AS STRING) AS CUSTOMER_ID,
        REPLACE(
            REPLACE(REPLACE(CUSTOMER_INCOME, ' Juta', '000000'), 'sd.', '0 -'),
            '>',
            ''
        ) AS INCOME_RANGE
    FROM `ocbc-441122.jwijoyo_ocbc.Profile`
)

SELECT
    CLEAN_DATA.CUSTOMER_ID,
    CLEAN_DATA.GENDER,
    CLEAN_DATA.CUSTOMER_INCOME,
    CASE
        WHEN STRPOS(CLEAN_DATA.INCOME_RANGE, ' - ') > 0
            THEN
                CAST(
                    TRIM(
                        TRIM(
                            SUBSTRING(
                                CLEAN_DATA.INCOME_RANGE,
                                1,
                                STRPOS(CLEAN_DATA.INCOME_RANGE, ' - ') - 1
                            )
                        )
                    ) AS NUMERIC
                )
                + 1
        ELSE CAST(TRIM(CLEAN_DATA.INCOME_RANGE) AS NUMERIC) + 1
    END AS LOWER_BOUND_INCOME,
    CASE
        WHEN STRPOS(CLEAN_DATA.INCOME_RANGE, ' - ') > 0
            THEN
                CAST(
                    TRIM(
                        SUBSTRING(
                            CLEAN_DATA.INCOME_RANGE,
                            STRPOS(CLEAN_DATA.INCOME_RANGE, ' - ') + 3
                        )
                    ) AS NUMERIC
                )
        ELSE CAST(NULL AS NUMERIC)
    END AS UPPER_BOUND_INCOME
FROM CLEAN_DATA
