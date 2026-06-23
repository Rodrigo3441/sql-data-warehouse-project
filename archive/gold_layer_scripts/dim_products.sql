
CREATE OR ALTER VIEW gold.dim_products AS
SELECT
	ROW_NUMBER() OVER (ORDER BY pinfo.prd_start_dt, pinfo.prd_key) AS product_key,
	pinfo.prd_id AS product_id,
	pinfo.prd_key AS product_number,
	pinfo.prd_nm AS product_name,
	pinfo.cat_id AS category_id,
	pcat.cat AS category,
	pcat.subcat AS subcategory,
	pcat.maintenance,
	pinfo.prd_cost AS product_cost,
	pinfo.prd_line AS product_line,
	pinfo.prd_start_dt AS product_start_date
FROM silver.crm_prd_info AS pinfo
LEFT JOIN silver.erp_px_cat_g1v2 AS pcat
	ON pinfo.cat_id = pcat.id
WHERE pinfo.prd_end_dt IS NULL; -- Removes historical data,