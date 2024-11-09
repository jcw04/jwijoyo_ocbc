WITH ranked_data AS (
    SELECT
        product_category,
        SUM(amount) AS total_amount,
        ROW_NUMBER() OVER (ORDER BY SUM(amount) DESC) AS rank
    FROM {{ ref('PORTO_0') }}
    GROUP BY product_category
)

SELECT
    product_category,
    total_amount
FROM ranked_data
WHERE total_amount = (SELECT MAX(total_amount) FROM ranked_data)
