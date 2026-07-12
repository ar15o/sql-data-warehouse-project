/* Which categories contribute the most to overall sales? */

SELECT 
	p.category AS ProductCategory,
	SUM(s.sales_amount) AS TotalSales,
	CONCAT((SUM(s.sales_amount) * 100 / SUM(SUM(s.sales_amount)) OVER())::INT,'%') AS PercentageOfSales,
	RANK() OVER(ORDER BY SUM(s.sales_amount) DESC) AS SalesRank
FROM gold.dim_products p
LEFT JOIN gold.fact_sales s
ON p.product_key = s.product_key
WHERE s.order_date IS NOT NULL
GROUP BY p.category
