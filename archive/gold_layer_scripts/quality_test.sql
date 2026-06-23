-- Foreign Key Integrity (Dimensions)
SELECT *
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_customers AS ct
	ON ct.customer_key = fs.customer_key
LEFT JOIN gold.dim_products AS pr
	ON pr.product_key = fs.product_key
WHERE ct.customer_key IS NULL;