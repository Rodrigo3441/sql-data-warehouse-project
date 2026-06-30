-- Which categories contribute the most to overall sales
WITH categories_sales_overview AS 
(
	SELECT
		dp.category,
		SUM(fs.sales_amount) AS total_sales
	FROM gold.fact_sales AS fs
	LEFT JOIN gold.dim_products AS dp
		ON fs.product_key = dp.product_key
	GROUP BY dp.category
)

SELECT
	category,
	total_sales,
	SUM(total_sales) OVER() AS overall_sales,
	CONCAT(ROUND((CAST(total_sales AS FLOAT)/ SUM(total_sales) OVER()) * 100, 2), '%') AS percentage_of_total
FROM categories_sales_overview
ORDER BY total_sales DESC