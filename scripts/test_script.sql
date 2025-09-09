
SELECT * 
FROM (
SELECT 
customer_id, 
cst_create_date,
ROW_NUMBER() 
OVER (PARTITION BY customer_id ORDER BY cst_create_date DESC) AS row_number
FROM silver.silver_crm_cust_info
) AS deduplicate_count
WHERE row_number != 1;



SELECT customer_id, COUNT(*) 
FROM silver.silver_crm_cust_info
GROUP BY customer_id
HAVING COUNT(*) > 1 ;

SELECT * FROM silver.silver_crm_cust_info
LIMIT 100;
