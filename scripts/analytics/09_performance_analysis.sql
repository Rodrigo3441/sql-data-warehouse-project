/* Analyze the yearly performance of products by comparing each product's sales
to both its average sales performance and the previous year's sales */
WITH yearly_product_sales AS
(
SELECT
	YEAR(fs.order_date) AS order_year,
	dp.product_name,
	SUM(fs.sales_amount) total_sales
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_products AS dp
	ON fs.product_key = dp.product_key
WHERE order_date IS NOT NULL
GROUP BY YEAR(fs.order_date), dp.product_name
)

SELECT
	order_year,
	product_name,
	total_sales,
	AVG(total_sales) OVER (PARTITION BY product_name) AS avg_sales,
	total_sales - AVG(total_sales) OVER (PARTITION BY product_name) AS diff_avg,
	CASE
		WHEN (total_sales - AVG(total_sales) OVER (PARTITION BY product_name)) > 0 THEN 'Above Average'
		WHEN (total_sales - AVG(total_sales) OVER (PARTITION BY product_name)) < 0 THEN 'Below Average'
		ELSE 'Average'
	END AS avg_change,
	-- Year-over_Year analysis
	LAG(total_sales) OVER(PARTITION BY product_name ORDER BY order_year ASC) AS previous_yearly_sales,
	total_sales - LAG(total_sales) OVER(PARTITION BY product_name ORDER BY order_year ASC) AS diff_previous_year,
	CASE
		WHEN (total_sales - LAG(total_sales) OVER(PARTITION BY product_name ORDER BY order_year ASC)) > 0 THEN 'Increasing'
		WHEN (total_sales - LAG(total_sales) OVER(PARTITION BY product_name ORDER BY order_year ASC)) < 0 THEN 'Decreasing'
		ELSE 'No Change'
	END AS previous_year_change
FROM yearly_product_sales
ORDER BY product_name, order_year