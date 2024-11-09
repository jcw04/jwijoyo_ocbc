WITH ranked_data AS (
    SELECT
        product,
        product_category,
        SUM(amount) AS total_amount,
        ROW_NUMBER() OVER (ORDER BY SUM(amount) DESC) AS rank
    FROM {{ ref('PORTO_0') }}
    WHERE
        product_category IN (
            SELECT product_category FROM {{ ref('Question_1A') }}
        )
    GROUP BY product, product_category
)

SELECT
    product,
    product_category,
    total_amount
FROM ranked_data
WHERE total_amount = (SELECT MAX(total_amount) FROM ranked_data)
