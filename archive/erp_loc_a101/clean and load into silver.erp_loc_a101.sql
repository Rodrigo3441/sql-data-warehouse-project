INSERT INTO silver.erp_loc_a101 (
	cid,
	cntry
)
SELECT
	REPLACE(cid, '-', '') AS cid,
	CASE
		WHEN UPPER(TRIM(cntry)) IN ('USA', 'US')
			THEN 'United States'
		WHEN UPPER(TRIM(cntry)) = 'DE'
			THEN 'Germany'
		WHEN TRIM(cntry) = '' OR cntry IS NULL
			THEN 'n/a'
		ELSE TRIM(cntry)
	END AS cntry -- Normalize and handle missing or blank country codes
FROM bronze.erp_loc_a101;

