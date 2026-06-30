/*
===========================================================================
Customer Report
===========================================================================
Purpose:
	- This report consolidates key customer metrics and behaviors

Highlights:
	1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
	3. Aggregates customer-level metrics:
		- total orders
		- total sales
		- total quantity purchased
		- total products
		- lifespan (in months)

	4. Calculates valuable KPIs:
		- recency (months since last order)
		- average order value
		- average monthly spend
===========================================================================
*/

CREATE OR ALTER VIEW gold.report_customers AS 
WITH basic_informations AS
-- =======================================================
-- basic_informations: retrieves core columns from tables
-- =======================================================
(
SELECT
	fs.order_number,
	fs.product_key,
	fs.order_date,
	fs.sales_amount,
	fs.quantity,
	dc.customer_key,
	dc.customer_number,
	CONCAT(dc.first_name, ' ', dc.last_name) AS customer_name,
	DATEDIFF(YEAR, dc.birthdate, GETDATE()) AS customer_age
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_customers AS dc
	ON fs.customer_key = dc.customer_key
WHERE fs.order_date IS NOT NULL
)
, customer_aggregation AS 
-- ===================================================================
-- customer_aggregation: summarizes key metrics at the customer level
-- ===================================================================
(
SELECT
	customer_key,
	customer_number,
	customer_name,
	customer_age,
	COUNT(DISTINCT order_number) AS total_orders,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	COUNT(DISTINCT product_key) AS total_products,
	MAX(order_date) AS last_order,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan_in_months
FROM basic_informations
GROUP BY
		customer_key,
		customer_number,
		customer_name,
		customer_age
)

SELECT
	customer_key,
	customer_number,
	customer_name,
	customer_age,
	CASE
		WHEN customer_age < 20 THEN 'Under 20'
		WHEN customer_age BETWEEN 20 AND 29 THEN '20-29'
		WHEN customer_age BETWEEN 30 AND 39 THEN '30-39'
		WHEN customer_age BETWEEN 40 AND 49 THEN '40-49'
		ELSE '50 and above'
	END AS customer_age_segment,
	CASE
		WHEN lifespan_in_months >= 12 AND total_sales > 5000 THEN 'VIP'
		WHEN lifespan_in_months >= 12 AND total_sales <= 5000 THEN 'Regular'
		ELSE 'New'
	END AS customer_segment,
	total_orders,
	total_sales,
	total_quantity,
	total_products,
	last_order,
	DATEDIFF(MONTH, last_order, GETDATE()) AS months_since_last_order,
	-- compute average order value
	CASE
		WHEN total_orders = 0 THEN 0
		ELSE total_sales / total_orders
	END AS avg_order_value,

	-- compute average monthly spend
	CASE
		WHEN lifespan_in_months = 0 THEN total_sales
		ELSE total_sales / lifespan_in_months
	END AS monthly_spend,	
	lifespan_in_months
FROM customer_aggregation