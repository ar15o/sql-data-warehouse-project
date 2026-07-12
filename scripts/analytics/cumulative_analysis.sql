/* Calculate the total sales per month and the running total of sales over time */

/* Calculate the total sales per month */

SELECT
DATE_TRUNC('month', order_date)::DATE AS OrderMonth,
SUM(sales_amount) TotalSales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY OrderMonth
ORDER BY OrderMonth

/* The running total of sales over time */
SELECT 
OrderMonth,
TotalSales,
SUM(TotalSales) OVER(ORDER BY OrderMonth) AS RunningTotalSales
FROM (
	SELECT
	DATE_TRUNC('month', order_date)::DATE AS OrderMonth,
	SUM(sales_amount)  AS TotalSales
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY OrderMonth) 
ORDER BY OrderMonth

/* The running total of sales over time separated by year */

SELECT 
OrderMonth,
TotalSales,
SUM(TotalSales) OVER(PARTITION BY EXTRACT(YEAR FROM OrderMonth) ORDER BY OrderMonth) AS RunningTotalSales
FROM (
	SELECT
	DATE_TRUNC('month', order_date)::DATE AS OrderMonth,
	SUM(sales_amount)  AS TotalSales
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY OrderMonth) 
ORDER BY OrderMonth
