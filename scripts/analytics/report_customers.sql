/* 
Purpose:
	-This report consolidates key customer metrics and behaviors

Highlights:
	1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customer into categories (VIP, Regular, New) and age groups.
	3. Aggregates customer-level metrics:
		-total orders
		- total sales
		- total quantity purchased
		- total products
		lifespan (in months)
	4. Calculates valuable KPI’s
		- recency (months since last order)
		- average order value
		- average monthly spend
*/


WITH base_query AS ( 
/* Base query: Retrieves core columns from tables */
SELECT 
	CONCAT(c.first_name,' ',c.last_name) Customer_Name,
	EXTRACT(YEAR FROM AGE(c.birthdate))::INT AS Age,
	c.customer_key,
	c.customer_number,
	s.order_number,
	s.product_key,
	s.order_date,
	s.sales_amount,
	s.quantity
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON s.customer_key = c.customer_key
WHERE order_date IS NOT NULL
)

, customer_aggregation AS (
	/* Aggregates customer-level metrics:
		-total orders
		- total sales
		- total quantity purchased
		- total products
		lifespan (in months) */
SELECT 
	customer_key,
	customer_number,
	customer_name,
	age,
	COUNT(DISTINCT order_number) total_orders,
	SUM(sales_amount) total_sales,
	SUM(quantity) total_quantity,
	COUNT(product_key) total_products,
	MAX(order_date) last_order,
	EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) * 12
	+ EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date))) AS lifespan
FROM base_query
GROUP BY 
	customer_key,
	customer_number,
	customer_name,
	age
)

SELECT 
	customer_key,
	customer_number,
	customer_name,
	age,
CASE
	WHEN age < 20 THEN 'Under 20'
	WHEN age between 20 and 29 THEN '20-29'
	WHEN age between 30 and 39 THEN '30-39'
	WHEN age between 40 and 49 THEN '40-49'
	ELSE '50 and above'
END AS age_group,
CASE 
	WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
	WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
	ELSE 'New'
END AS Customer_segment,
	total_orders,
	total_sales,
	total_quantity,
	total_products,
	last_order,
	lifespan,
	-- recency: months since last order, relative to today
	EXTRACT(YEAR FROM AGE(NOW(), last_order)) * 12
		+ EXTRACT(MONTH FROM AGE(NOW(), last_order)) AS recency,
	-- average order value
	CASE WHEN total_orders = 0 THEN 0 
		 ELSE total_sales / total_orders
	END AS avg_order_value,
	-- average monthly spend
	ROUND(CASE WHEN lifespan = 0 THEN total_sales 
		 ELSE total_sales / lifespan 
	END, 2) AS avg_monthly_spend
FROM customer_aggregation
