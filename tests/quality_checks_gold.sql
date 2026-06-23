/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
	This script performs quality checks to validate the integrity, consistency,
	and accuracy of the Gold layer. These checks ensure.
	- Uniqueness of surrogate keys in dimension tables.
	- Referential integrity between fact and dimension tables.
	- Validation of relationships in the data model for analytical purposes.

Usage Notes:
	- Run these checks after creating Gold Views.
	- Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- =============================================================
-- Checking gold.dim_customers
-- =============================================================
-- Check for Uniqueness of Product Key in gold.dim_customers
-- Expectation: No Results
SELECT
	customer_key,
	COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;


-- =============================================================
-- Checking gold.dim_products
-- =============================================================
-- Check for Uniqueness of Product Key in gold.dim_products
-- Expectation: No Results
SELECT
	product_key,
	COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;


-- =============================================================
-- Checking gold.fact_sales
-- =============================================================
-- Check the data model connectivity between fact and dimensions
SELECT
	*
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_customers AS ct
	ON ct.customer_key = fs.customer_key
LEFT JOIN gold.dim_products AS pr
	ON pr.product_key = fs.product_key
WHERE pr.product_key IS NULL OR ct.customer_key IS NULL;