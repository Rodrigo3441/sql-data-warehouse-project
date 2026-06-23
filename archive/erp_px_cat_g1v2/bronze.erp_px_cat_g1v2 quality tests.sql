-- Check for unwanted Spaces
SELECT
	cat,
	subcat,
	maintenance
FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat)
OR subcat != TRIM(subcat)
OR maintenance != TRIM(maintenance)

-- Data Standardizations and Consistency
SELECT DISTINCT
	cat
FROM bronze.erp_px_cat_g1v2;

SELECT DISTINCT
	subcat
FROM bronze.erp_px_cat_g1v2;

SELECT DISTINCT
	maintenance
FROM bronze.erp_px_cat_g1v2;
