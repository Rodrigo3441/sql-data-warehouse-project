/*
============================================================================
Product Report
============================================================================
Purpose:
	- This report consolidates key product metrics and behaviors.

Highlights:
	1. Gathers essential fields such as product name, category, subcategory, and cost.
	2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
	3. Aggregates product-level metrics:
		- total orders
		- total sales
		- total quantity sold
		- total customers (unique)
		- lifespan (in months)
	4. Calculates valuable KPIs:
		- recency (months since last sale)
		- average order revenue (AOR)
		- average monthly revenue
============================================================================
*/
CREATE OR ALTER VIEW gold.report_products AS
WITH basic_informations AS
-- =======================================================
-- basic_informations: retrieves core columns from tables
-- =======================================================
(
SELECT
	fs.order_number,
	fs.product_key,
	fs.customer_key,
	fs.order_date,
	fs.sales_amount,
	fs.quantity,
	dp.product_name,
	dp.category,
	dp.subcategory,
	dp.product_cost
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_products AS dp
	ON fs.product_key = dp.product_key
WHERE fs.order_date IS NOT NULL
)
, product_aggregation AS 
-- ===================================================================
-- product_aggregation: summarizes key metrics at the product level
-- ===================================================================
(
SELECT
	product_key,
	product_name,
	category,
	subcategory,
	product_cost,
	MAX(order_date) AS last_sale_date,
	COUNT(DISTINCT order_number) AS total_orders,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)),1) AS avg_selling_price
FROM basic_informations
GROUP BY
		product_key,
		product_name,
		category,
		subcategory,
		product_cost
)

SELECT
	product_key,
	product_name,
	category,
	subcategory,
	product_cost,
	last_sale_date,
	DATEDIFF(MONTH, last_sale_date, GETDATE()) AS months_since_last_order,
	CASE
		WHEN total_sales > 50000 THEN 'High-Performer'
		WHEN total_sales >= 10000 THEN 'Mid_Range'
		ELSE 'Low-Performer'
	END AS product_segment,
	total_orders,
	total_sales,
	total_quantity,
	total_customers,
	avg_selling_price,

	-- Average Order Revenue
	CASE
		WHEN total_orders = 0 THEN 0
		ELSE total_sales / total_orders
	END AS avg_order_revenue
FROM product_aggregation