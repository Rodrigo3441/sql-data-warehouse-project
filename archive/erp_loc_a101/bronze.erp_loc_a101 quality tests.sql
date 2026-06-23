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
FROM bronze.erp_loc_a101
ORDER BY cntry;