/*
Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than $5000.
	- Regular: Customers with at least 12 months of history but speding $5000 or less.
	- New: Customers with a lifespan less than 12 motnhs.
And find the total number of customers by each group
*/
-- first step: collecting the data about the customer
WITH customer_spending AS 
(
SELECT
	customer_key,
	MIN(order_date) first_order_date,
	MAX(order_date) last_order_date,
	SUM(sales_amount) AS total_spending,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
FROM gold.fact_sales
GROUP BY customer_key
), customer_segmentation AS
( -- second step: deriving the segmentation from customers information
SELECT
	customer_key,
	CASE
		WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
		WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
		ELSE 'New'
	END AS customer_segment
FROM customer_spending
)

-- third step: grouping up the data 
SELECT
	customer_segment,
	COUNT(customer_key) AS total_customers
FROM customer_segmentation
GROUP BY customer_segment
ORDER BY total_customers DESC;