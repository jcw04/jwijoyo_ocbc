{{
    config(
            materialized = 'table'
         )
}}

SELECT
    product,
    product_category,
    CAST(customerid AS STRING) AS customer_id,
    CASE
        WHEN TRIM(` amount`) = '-' THEN NULL
        ELSE CAST(REPLACE(TRIM(` amount`), ',', '') AS NUMERIC)
    END AS amount
FROM `ocbc-441122.jwijoyo_ocbc.Porto`
