-- Find the date of the first and last order
-- How many years of sales are available
SELECT
	*,
	DATEDIFF(YEAR, oldest_order, most_recent_order) AS order_range_years
FROM
(
	SELECT
		MIN(order_date) AS oldest_order,
		MAX(order_date) AS most_recent_order
	FROM gold.fact_sales
) AS sub

-- Find the youngest and oldest customer
SELECT
	MIN(birthdate) AS oldest_customer,
	MAX(birthdate) AS youngest_customer,
	DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_customer_age,
	DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngest_customer_age
FROM gold.dim_customers