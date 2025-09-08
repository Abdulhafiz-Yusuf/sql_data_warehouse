/* * note: to use COPY on Ubuntu copy your entire datasets folder into /tmp/csv to avoid "Permission Denied issue". 
 * Because your $HOME/... path had restricted permissions for other users and psql could not traverse the folders. 
 
 
 sudo rm -rf /tmp/csv # optional 
 mkdir -p /tmp/csv 
 cp -r  "/home/abuammar/Documents/practice_DE_PROJECT/sql-data-warehouse-project-main/datasets" /tmp/csv/ 
 chmod -R 755 /tmp/csv 

 */

/*
 
 * 
 * 
 * * Stored Procedure: bronze.load_bronze
 * Purpose: Truncate bronze tables & bulk load CSV data
 * Note:
 *   - Copy datasets to /tmp/csv before running
 *   - Ensure PostgreSQL has read permissions on /tmp/csv
 */

CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
DECLARE
    set_time TIMESTAMP;
    end_time TIMESTAMP;
BEGIN
    -- Step 1: Truncate bronze tables
    RAISE NOTICE 'Truncating bronze tables...';
    set_time := NOW();
    TRUNCATE TABLE
        bronze.bronze_crm_cust_info,
        bronze.bronze_crm_prd_info,
        bronze.bronze_crm_sales_details,
        bronze.bronze_erp_loc_a101,
        bronze.bronze_erp_cust_az12,
        bronze.bronze_erp_px_cat_g1v2
    RESTART IDENTITY;
    end_time := NOW();
    RAISE NOTICE '✅ Truncation completed in % seconds.', EXTRACT(EPOCH FROM end_time - set_time);

    -- Step 2: Load CRM customer info
    RAISE NOTICE 'Loading bronze_crm_cust_info...';
    set_time := NOW();
    COPY bronze.bronze_crm_cust_info
    FROM '/tmp/csv/datasets/source_crm/cust_info.csv'
    DELIMITER ',' CSV HEADER;
    end_time := NOW();
    RAISE NOTICE '✅ bronze_crm_cust_info loaded in % seconds.', EXTRACT(EPOCH FROM end_time - set_time);

    -- Step 3: Load CRM product info
    RAISE NOTICE 'Loading bronze_crm_prd_info...';
    set_time := NOW();
    COPY bronze.bronze_crm_prd_info
    FROM '/tmp/csv/datasets/source_crm/prd_info.csv'
    DELIMITER ',' CSV HEADER;
    end_time := NOW();
    RAISE NOTICE '✅ bronze_crm_prd_info loaded in % seconds.', EXTRACT(EPOCH FROM end_time - set_time);

    -- Step 4: Load CRM sales details
    RAISE NOTICE 'Loading bronze_crm_sales_details...';
    set_time := NOW();
    COPY bronze.bronze_crm_sales_details
    FROM '/tmp/csv/datasets/source_crm/sales_details.csv'
    DELIMITER ',' CSV HEADER;
    end_time := NOW();
    RAISE NOTICE '✅ bronze_crm_sales_details loaded in % seconds.', EXTRACT(EPOCH FROM end_time - set_time);

    -- Step 5: Load ERP locations
    RAISE NOTICE 'Loading bronze_erp_loc_a101...';
    set_time := NOW();
    COPY bronze.bronze_erp_loc_a101
    FROM '/tmp/csv/datasets/source_erp/LOC_A101.csv'
    DELIMITER ',' CSV HEADER;
    end_time := NOW();
    RAISE NOTICE '✅ bronze_erp_loc_a101 loaded in % seconds.', EXTRACT(EPOCH FROM end_time - set_time);

    -- Step 6: Load ERP customers
    RAISE NOTICE 'Loading bronze_erp_cust_az12...';
    set_time := NOW();
    COPY bronze.bronze_erp_cust_az12
    FROM '/tmp/csv/datasets/source_erp/CUST_AZ12.csv'
    DELIMITER ',' CSV HEADER;
    end_time := NOW();
    RAISE NOTICE '✅ bronze_erp_cust_az12 loaded in % seconds.', EXTRACT(EPOCH FROM end_time - set_time);

    -- Step 7: Load ERP PX categories
    RAISE NOTICE 'Loading bronze_erp_px_cat_g1v2...';
    set_time := NOW();
    COPY bronze.bronze_erp_px_cat_g1v2
    FROM '/tmp/csv/datasets/source_erp/PX_CAT_G1V2.csv'
    DELIMITER ',' CSV HEADER;
    end_time := NOW();
    RAISE NOTICE '✅ bronze_erp_px_cat_g1v2 loaded in % seconds.', EXTRACT(EPOCH FROM end_time - set_time);

    -- Step 8: Log success
    RAISE NOTICE '🎉 Bronze data successfully loaded at %', NOW();

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '❌ Error during bronze data load: %', SQLERRM;
        RAISE;
END;
$$;
