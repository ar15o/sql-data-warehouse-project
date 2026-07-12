/* Analyze the yearly performance of products by comparing their sales to both the average sales performance of the
product and the previous year’s sales */

WITH yearly_sales AS (
SELECT 
	d.product_name,
	EXTRACT(year FROM f.order_date)::INT AS order_year,
	SUM(f.sales_amount) total_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products d
ON d.product_key = f.product_key
WHERE f.order_date IS NOT NULL
GROUP BY product_name, order_year
)
SELECT 
	product_name,
	order_year,
	total_sales,
	AVG(total_sales) OVER(partition by product_name)::INT AS avg_sales,
	total_sales - AVG(total_sales) OVER(PARTITION BY product_name)::INT AS diff_avg,
	CASE WHEN total_sales - AVG(total_sales) OVER(PARTITION BY product_name)::INT > 0 THEN 'ABOVE AVERAGE'
		WHEN total_sales - AVG(total_sales) OVER(PARTITION BY product_name)::INT < 0 THEN 'BELOW AVERAGE'
		ELSE 'AVG'
	END avg_change,
	-- YEAR OVR YEAR ANALYSIS --
	LAG(total_sales) OVER(partition by product_name ORDER BY order_year) AS prior_years_sales,
	total_sales - LAG(total_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS diff_prior_year,
	CASE WHEN total_sales - LAG(total_sales) OVER(PARTITION BY product_name)::INT > 0 THEN 'INCREASING'
		WHEN total_sales - LAG(total_sales) OVER(PARTITION BY product_name)::INT < 0 THEN 'DECREASING'
		ELSE 'NO CHANGE'
	END prior_year_change
FROM yearly_sales
ORDER BY product_name, order_year
