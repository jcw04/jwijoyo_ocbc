WITH join_data AS (SELECT
    profile.customer_income,
    porto.product_category,
    porto.product,
    COUNT(trans.customer_id) AS total_interaction,
    SUM(trans.transaction_amount) AS total_transaction_amount,
    SUM(porto.amount) AS total_revenue,
    CASE
        WHEN
            SUM(porto.amount) > 0
            THEN SUM(trans.transaction_amount) / SUM(porto.amount)
    END AS transaction_to_revenue_ratio,
    ROW_NUMBER() OVER (ORDER BY COUNT(trans.customer_id) DESC) AS rank
FROM {{ ref('PORTO_0') }} AS porto
INNER JOIN {{ ref('PROFILE_0') }} AS profile
    ON porto.customer_id = profile.customer_id
INNER JOIN {{ ref('TRANSACTION_0') }} AS trans
    ON porto.customer_id = trans.customer_id
WHERE profile.customer_income = '>100 Juta'
GROUP BY profile.customer_income, porto.product_category, porto.product
)

SELECT
    total_interaction,
    customer_income,
    product_category,
    product,
    total_transaction_amount,
    total_revenue,
    transaction_to_revenue_ratio
FROM join_data
WHERE total_interaction = (SELECT MAX(total_interaction) FROM join_data)