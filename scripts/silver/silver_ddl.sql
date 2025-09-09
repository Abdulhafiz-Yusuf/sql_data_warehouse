DROP TABLE IF EXISTS silver.silver_erp_loc_a101;
DROP TABLE IF EXISTS silver.silver_crm_sales_details;
DROP TABLE IF EXISTS silver.silver_erp_cust_az12;
DROP TABLE IF EXISTS silver.silver_crm_prd_info;
DROP TABLE IF EXISTS silver.silver_erp_px_cat_g1v2;
DROP TABLE IF EXISTS silver.silver_crm_cust_info;

CREATE TABLE silver.silver_crm_cust_info AS
SELECT
	cst_id AS customer_id,
	cst_key AS customer_key,
	cst_firstname AS first_name,
	cst_lastname AS last_name,
	cst_marital_status AS marital_status,
	cst_gndr,
	cst_create_date,
	( 
	SELECT ROW_NUMBER() 
	OVER (PARTITION BY customer_id ORDER BY cst_create_date DESC) row_number
	FROM bronze.bronze_crm_cust_info 
	WHERE row_number != 1 
	) AS deduplicate_count
FROM bronze.bronze_crm_cust_info;


CREATE TABLE silver.silver_crm_prd_info AS
SELECT 
	prd_id AS product_id,
	prd_key AS product_key,
	prd_nm AS product_number,
	prd_cost AS product_cost,
	prd_line AS prodcut_line,
	prd_start_dt AS prod_start_date,
	prd_end_dt AS prod_end_date
FROM bronze.bronze_crm_prd_info;


CREATE TABLE silver.silver_crm_sales_details AS
SELECT
	sls_ord_num AS sales_order_number,
	sls_prd_key AS sales_prod_key,
	sls_cust_id AS sales_cust_id,
	sls_order_dt AS sales_order_date,
	sls_ship_dt AS sales_ship_date,
	sls_due_dt AS sales_due_date,
	sls_sales AS sales,
	sls_quantity AS sales_qty,
	sls_price AS sales_price
FROM bronze.bronze_crm_sales_details;



CREATE TABLE silver.silver_erp_loc_a101 AS
SELECT
	cid AS country_id,
	cntry as country
FROM bronze.bronze_erp_loc_a101;



CREATE TABLE silver.silver_erp_cust_az12 AS
SELECT
	cid AS customer_id,
	bdate AS customer_dob,
	gen AS gender
FROM bronze.bronze_erp_cust_az12;


CREATE TABLE silver.silver_erp_px_cat_g1v2 AS
SELECT
	id AS product_id,
	cat AS category,
	subcat AS sub_category,
	maintenance AS maintenance
FROM bronze.bronze_erp_px_cat_g1v2;


ALTER TABLE silver.silver_crm_cust_info
ADD CONSTRAINT pk_customer_id PRIMARY KEY (customer_id);

ALTER TABLE silver.silver_crm_sales
ADD CONSTRAINT fk_customer
FOREIGN KEY (customer_id)
REFERENCES silver.silver_crm_cust_info(customer_id);
