-- *******************************************
-- 🔹 Step 1 — Detect Missing Values (Completeness Check) ✅
-- Goal: Find NULL, blank, or "unknown" values
-- *******************************************

-- Find NULL or empty values in a specific column
SELECT *
FROM silver.my_table
WHERE col IS NULL OR TRIM(col) = '';

-- Count missing per column (dynamic)
SELECT 
    COUNT(*) FILTER (WHERE col IS NULL OR TRIM(col) = '') AS col_missing
FROM silver.my_table;

-- *******************************************
-- 🔹 Step 2 — Detect Duplicates (Uniqueness Check) 🧍‍♂️🧍‍♀️
-- Goal: Find duplicate rows or duplicate business keys.
-- *******************************************

-- Detect full duplicate rows
SELECT *, COUNT(*) 
FROM silver.my_table
GROUP BY col1, col2, col3
HAVING COUNT(*) > 1;

-- Detect duplicate IDs
SELECT id, COUNT(*) 
FROM silver.my_table
GROUP BY id
HAVING COUNT(*) > 1;



-- *******************************************
-- 🔹 Step 3 — Validate Data Types (Correctness Check) 🔤🔢📅
-- Goal: Ensure each column has the expected type.
-- *******************************************

-- For Numeric Columns
-- Detect non-numeric values in a supposed numeric column
SELECT *
FROM silver.my_table
WHERE col !~ '^[0-9]+$';

-- For Date Columns
-- Detect invalid date formats
SELECT *
FROM silver.my_table
WHERE TO_DATE(col, 'YYYY-MM-DD') IS NULL;

-- For Boolean Columns
-- Detect unexpected boolean values
SELECT DISTINCT col
FROM silver.my_table
WHERE col NOT IN ('TRUE', 'FALSE', '1', '0', 'Y', 'N');

-- *******************************************
-- 🔹 Step 4 — Validate Value Ranges (Accuracy Check) 🎯
-- Goal: Ensure values make business sense.
-- *******************************************

-- For Numeric Ranges 
-- Detect negative or unrealistic numbers
SELECT *
FROM silver.my_table
WHERE amount < 0 OR amount > 1000000;

-- For Date Ranges
-- Detect future or impossible dates
SELECT *
FROM silver.my_table
WHERE order_date > NOW()
   OR order_date < '2000-01-01';

-- For Categorical Columns
-- Detect unexpected values
SELECT DISTINCT col
FROM silver.my_table
WHERE col NOT IN ('Single', 'Married', 'Divorced', 'Widowed');


-- *******************************************
-- 🔹 Step 5 — Standardize Formats (Consistency Check) 🎨
-- Goal: Ensure consistent representation.
-- *******************************************
-- For Strings
-- Detect leading/trailing spaces
SELECT *
FROM silver.my_table
WHERE col <> TRIM(col);

-- Detect multiple spaces between words
SELECT *
FROM silver.my_table
WHERE col ~ '  +';


-- For Emails
-- Detect invalid email formats
SELECT *
FROM silver.my_table
WHERE col !~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';

-- For Dates
-- Detect inconsistent date formats (string stored instead of date)
SELECT col, COUNT(*) 
FROM silver.my_table
GROUP BY col
ORDER BY col;


-- *******************************************
-- 🔹 Step 6 — Check Cross-Table Integrity (Relationship Check) 🔗
--  Goal: Ensure referential integrity and business rule consistency.
-- *******************************************

-- Foreign Key Validation
-- Find orders with customer_id not in customers table
SELECT o.*
FROM silver.orders o
LEFT JOIN silver.customers c
       ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

--Orphaned Records
-- Payments without matching orders
SELECT p.*
FROM silver.payments p
LEFT JOIN silver.orders o
       ON p.order_id = o.order_id
WHERE o.order_id IS NULL;


-- Aggregated Value Mismatch
-- Invoice total mismatch with line items
SELECT i.invoice_id, i.total_amount, SUM(l.line_amount) AS line_sum
FROM silver.invoice i
JOIN silver.invoice_lines l
     ON i.invoice_id = l.invoice_id
GROUP BY i.invoice_id, i.total_amount
HAVING i.total_amount <> SUM(l.line_amount);
