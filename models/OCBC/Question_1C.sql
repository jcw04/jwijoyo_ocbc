WITH ranked_data AS (
    SELECT
        product,
        SUM(amount) AS total_amount,
        ROW_NUMBER() OVER (ORDER BY SUM(amount) DESC) AS rank
    FROM {{ ref('PORTO_0') }}
    GROUP BY product
)

SELECT
    product,
    total_amount
FROM ranked_data
WHERE total_amount = (SELECT MAX(total_amount) FROM ranked_data)
