-- Clean and load crm_cust_info
SELECT
*
FROM bronze.crm_cust_info;

-- Check for Nulls or Duplicates in Primary Key
-- Expectation: No Results
SELECT
	cst_id,
	COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for unwanted Spaces
-- Expectation: No Results
SELECT
	cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT
	cst_lastname
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

-- Data Standardization and Consistency
SELECT DISTINCT
	cst_gndr
FROM bronze.crm_cust_info;

SELECT DISTINCT
	cst_marital_status
FROM bronze.crm_cust_info

