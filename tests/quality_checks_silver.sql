/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
	This script performs various quality checks for data consistency, accuracy,
	and standardization across the 'silver' schemas. It includes checks for:
		- NULL or duplicate primary keys.
		- Unwanted spaces in string fields.
		- Data standardization and consistency.
		- Invalid data ranges and orders.
		- Data consistency between related fields.

Usage Notes:
	- Run these checks after data loading Silver Layer.
	- Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- =================================================================
-- Checking silver.crm_cust_info
-- =================================================================
-- Check for Nulls or Duplicates in Primary Key
-- Expectation: No Results
SELECT
	cst_id,
	COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for unwanted Spaces
-- Expectation: No Results
-- Column: cst_firstname
SELECT
	cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

-- Column: cst_lastname
SELECT
	cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

-- Data Standardization and Consistency
-- Column: cst_gndr
SELECT DISTINCT
	cst_gndr
FROM silver.crm_cust_info;

-- Column: cst_marital_status
SELECT DISTINCT
	cst_marital_status
FROM silver.crm_cust_info


-- =================================================================
-- Checking silver.crm_prd_info
-- =================================================================
-- Check for Nulls or Duplicates in Primary Key
-- Expectation: No Results
SELECT
	prd_id,
	COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check for unwanted Spaces
-- Expectation: No Results
SELECT
	prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check for NULLs or Negative Numbers
-- Expectation: No Results
SELECT
	prd_cost
FROM silver.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost < 0

-- Data Standardization and Consistency
SELECT DISTINCT
	prd_line
FROM silver.crm_prd_info

-- Check for Invalid Date Orders
SELECT
*
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt


-- =================================================================
-- Checking silver.crm_sales_details
-- =================================================================
-- Check for Invalid dates
-- sls_order_dt
SELECT
	NULLIF(sls_order_dt, 0)
FROM silver.crm_sales_details
WHERE sls_order_dt <= 0
	OR LEN(sls_order_dt) != 8
	OR sls_order_dt > 20500101
	OR sls_order_dt < 19000101;

-- sls_ship_dt
SELECT
	NULLIF(sls_ship_dt, 0)
FROM silver.crm_sales_details
WHERE sls_ship_dt <= 0
	OR LEN(sls_ship_dt) != 8
	OR sls_ship_dt > 20500101
	OR sls_ship_dt < 19000101;

-- sls_due_dt
SELECT
	NULLIF(sls_due_dt, 0)
FROM silver.crm_sales_details
WHERE sls_due_dt <= 0
	OR LEN(sls_due_dt) != 8
	OR sls_due_dt > 20500101
	OR sls_due_dt < 19000101;

-- Check for Invalid Date Orders
SELECT
*
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
	OR sls_order_dt > sls_due_dt;

-- Check Data Consistency: Between Sales, Quantity and Price
-- >> Sales = Quantity * Price
-- >> Values must not be NULL, zero or negative
SELECT
	sls_sales,
	sls_quantity,
	sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
	OR sls_sales IS NULL OR sls_sales <= 0
	OR sls_quantity IS NULL OR sls_quantity <= 0
	OR sls_price IS NULL OR sls_price <= 0;

-- handling nulls, negative and wrong calculations
SELECT
	sls_sales AS old_sls_sales,
	sls_quantity,
	sls_price AS old_sls_price,
	CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
	     THEN sls_quantity * ABS(sls_price)
		 ELSE sls_sales
	END AS sls_sales,
	CASE WHEN sls_price IS NULL OR sls_price <= 0
		 THEN sls_sales / NULLIF(sls_quantity, 0)
		 ELSE sls_price
	END AS sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_sales <= 0
OR sls_quantity IS NULL OR sls_quantity <= 0
OR sls_price IS NULL OR sls_price <= 0;


-- =================================================================
-- Checking silver.erp_cust_az12
-- =================================================================
-- Identify Out-of-Range Dates
SELECT DISTINCT
	bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE();

-- Data Standardization and Consistency
SELECT DISTINCT
	gen
FROM silver.erp_cust_az12


-- =================================================================
-- Checking silver.erp_loc_a101
-- =================================================================
-- Data Standardization and Consistency
SELECT DISTINCT
	cntry AS old_cntry,
	CASE
		WHEN UPPER(TRIM(cntry)) IN ('USA', 'US')
			THEN 'United States'
		WHEN UPPER(TRIM(cntry)) = 'DE'
			THEN 'Germany'
		WHEN TRIM(cntry) = '' OR cntry IS NULL
			THEN 'n/a'
		ELSE TRIM(cntry)
	END AS cntry
FROM silver.erp_loc_a101
ORDER BY cntry;


-- =================================================================
-- Checking silver.erp_px_cat_g1v2
-- =================================================================
-- Check for unwanted Spaces
SELECT
	cat,
	subcat,
	maintenance
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat)
	OR subcat != TRIM(subcat)
	OR maintenance != TRIM(maintenance)

-- Data Standardizations and Consistency
-- Column: cat
SELECT DISTINCT
	cat
FROM silver.erp_px_cat_g1v2;

-- Column: subcat
SELECT DISTINCT
	subcat
FROM silver.erp_px_cat_g1v2;

-- Column: maintenance
SELECT DISTINCT
	maintenance
FROM silver.erp_px_cat_g1v2;
