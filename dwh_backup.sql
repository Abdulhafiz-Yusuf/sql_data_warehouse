--
-- PostgreSQL database dump
--

-- Dumped from database version 14.18 (Ubuntu 14.18-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.18 (Ubuntu 14.18-0ubuntu0.22.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: bronze; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA bronze;


ALTER SCHEMA bronze OWNER TO postgres;

--
-- Name: gold; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA gold;


ALTER SCHEMA gold OWNER TO postgres;

--
-- Name: silver; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA silver;


ALTER SCHEMA silver OWNER TO postgres;

--
-- Name: load_bronze(); Type: PROCEDURE; Schema: bronze; Owner: postgres
--

CREATE PROCEDURE bronze.load_bronze()
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Step 1: Truncate bronze tables
    RAISE NOTICE 'Truncating bronze tables...';
    TRUNCATE TABLE
        bronze.crm_cust_info,
        bronze.crm_prd_info,
        bronze.crm_sales_details,
        bronze.erp_loc_a101,
        bronze.erp_cust_az12,
        bronze.erp_px_cat_g1v2
    RESTART IDENTITY;

    -- Step 2: Load CRM customer info
    RAISE NOTICE 'Loading bronze_crm_cust_info...';
    COPY bronze.crm_cust_info
    FROM '/tmp/csv/datasets/source_crm/cust_info.csv'
    DELIMITER ',' CSV HEADER;

    -- Step 3: Load CRM product info
    RAISE NOTICE 'Loading bronze_crm_prd_info...';
    COPY bronze.crm_prd_info
    FROM '/tmp/csv/datasets/source_crm/prd_info.csv'
    DELIMITER ',' CSV HEADER;

    -- Step 4: Load CRM sales details
    RAISE NOTICE 'Loading bronze_crm_sales_details...';
    COPY bronze.crm_sales_details
    FROM '/tmp/csv/datasets/source_crm/sales_details.csv'
    DELIMITER ',' CSV HEADER;

    -- Step 5: Load ERP locations
    RAISE NOTICE 'Loading bronze_erp_loc_a101...';
    COPY bronze.erp_loc_a101
    FROM '/tmp/csv/datasets/source_erp/LOC_A101.csv'
    DELIMITER ',' CSV HEADER;

    -- Step 6: Load ERP customers
    RAISE NOTICE 'Loading bronze_erp_cust_az12...';
    COPY bronze.erp_cust_az12
    FROM '/tmp/csv/datasets/source_erp/CUST_AZ12.csv'
    DELIMITER ',' CSV HEADER;

    -- Step 7: Load ERP PX categories
    RAISE NOTICE 'Loading bronze_erp_px_cat_g1v2...';
    COPY bronze.erp_px_cat_g1v2
    FROM '/tmp/csv/datasets/source_erp/PX_CAT_G1V2.csv'
    DELIMITER ',' CSV HEADER;

    -- Step 8: Log success
    RAISE NOTICE '✅ Bronze data successfully loaded!';

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '❌ Error during bronze data load: %', SQLERRM;
        RAISE;
END;
$$;


ALTER PROCEDURE bronze.load_bronze() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: crm_cust_info; Type: TABLE; Schema: bronze; Owner: postgres
--

CREATE TABLE bronze.crm_cust_info (
    cst_id integer,
    cst_key character varying(50),
    cst_firstname character varying(50),
    cst_lastname character varying(50),
    cst_marital_status character varying(1),
    cst_gndr character varying(1),
    cst_create_date date
);


ALTER TABLE bronze.crm_cust_info OWNER TO postgres;

--
-- Name: crm_prd_info; Type: TABLE; Schema: bronze; Owner: postgres
--

CREATE TABLE bronze.crm_prd_info (
    prd_id integer,
    prd_key character varying(50),
    prd_nm character varying(50),
    prd_cost character varying(50),
    prd_line character varying(1),
    prd_start_dt date,
    prd_end_dt date
);


ALTER TABLE bronze.crm_prd_info OWNER TO postgres;

--
-- Name: crm_sales_details; Type: TABLE; Schema: bronze; Owner: postgres
--

CREATE TABLE bronze.crm_sales_details (
    sls_ord_num character varying(50),
    sls_prd_key character varying(50),
    sls_cust_id integer,
    sls_order_dt integer,
    sls_ship_dt integer,
    sls_due_dt integer,
    sls_sales integer,
    sls_quantity integer,
    sls_price integer
);


ALTER TABLE bronze.crm_sales_details OWNER TO postgres;

--
-- Name: erp_cust_az12; Type: TABLE; Schema: bronze; Owner: postgres
--

CREATE TABLE bronze.erp_cust_az12 (
    cid character varying(50),
    bdate date,
    gen character varying(50)
);


ALTER TABLE bronze.erp_cust_az12 OWNER TO postgres;

--
-- Name: erp_loc_a101; Type: TABLE; Schema: bronze; Owner: postgres
--

CREATE TABLE bronze.erp_loc_a101 (
    cid character varying(50),
    cntry character varying(50)
);


ALTER TABLE bronze.erp_loc_a101 OWNER TO postgres;

--
-- Name: erp_px_cat_g1v2; Type: TABLE; Schema: bronze; Owner: postgres
--

CREATE TABLE bronze.erp_px_cat_g1v2 (
    id character varying(50),
    cat character varying(50),
    subcat character varying(50),
    maintenance character varying(50)
);


ALTER TABLE bronze.erp_px_cat_g1v2 OWNER TO postgres;

--
-- PostgreSQL database dump complete
--

