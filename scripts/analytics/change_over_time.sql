-- Change over time analysis
SELECT 
    DATE_TRUNC('month', order_date)::DATE AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY DATE_TRUNC('month', order_date);

-- New customers added each year
SELECT 
    DATE_TRUNC('year', create_date)::DATE AS CreateDate,
    COUNT(DISTINCT customer_key) AS TotalCustomer
FROM gold.dim_customers
GROUP BY DATE_TRUNC('year', create_date)
ORDER BY CreateDate;
