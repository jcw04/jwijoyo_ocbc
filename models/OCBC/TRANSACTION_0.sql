{{
    config(
            materialized = 'table'
         )
}}

SELECT
    `activity_date` AS ACTIVITY_DATE,
    `transaction_method` AS TRANSACTION_METHOD,
    `transaction_type` AS TRANSACTION_TYPE,
    CASE
        WHEN TRIM(` transaction_amount`) = '-' THEN CAST('0' AS NUMERIC)
        ELSE
            CAST(
                REPLACE(
                    REPLACE(TRIM(` transaction_amount`), ',', ''), '- ', '-'
                ) AS NUMERIC
            )
    END AS TRANSACTION_AMOUNT,
    CAST(`customerid` AS STRING) AS CUSTOMER_ID
FROM `ocbc-441122.jwijoyo_ocbc.Transaction`
