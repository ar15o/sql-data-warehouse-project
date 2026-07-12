/* Group customers into three segments based on their spending behavior.

-VIP: at least 12 months of history and spending more than 5,000
-Regular: at least 12 months of history but spending 5,000 or less
-New: lifespan less than 12 months
AND find the total number of customer by each group */
WITH customer_sales AS (
SELECT
	c.first_name,
	c.last_name,
	c.customer_id,
	SUM(s.sales_amount) AS total_sales,
	EXTRACT(YEAR FROM AGE(MAX(s.order_date), MIN(s.order_date))) * 12 + 
	EXTRACT(MONTH FROM AGE(MAX(s.order_date), MIN(s.order_date))) AS lifespan_months
FROM gold.dim_customers c
LEFT JOIN gold.fact_sales s
ON c.customer_key = s.customer_key
GROUP BY first_name, last_name, customer_id
),
customer_tiers AS (
SELECT 
	first_name,
	last_name,
	customer_id,
	total_sales,
	lifespan_months,
	CASE WHEN lifespan_months >= 12 AND total_sales > 5000 THEN 'VIP'
	WHEN lifespan_months >= 12 AND total_sales <= 5000 THEN 'Regular'
	ELSE 'New'
	END AS Customer_Spending_tier
FROM customer_sales
)
SELECT
    first_name,
    last_name,
    customer_id,
    total_sales,
    lifespan_months,
    customer_spending_tier,
    COUNT(customer_id) OVER(PARTITION BY customer_spending_tier) AS total_in_tier
FROM customer_tiers
ORDER BY customer_spending_tier
