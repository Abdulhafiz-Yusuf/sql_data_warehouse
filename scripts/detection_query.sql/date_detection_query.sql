-- 3. DATE & TIME COLUMNS 📅
-- (Examples: birth_date, order_date, transaction_time)


-- Step 1 → Missing Values
SELECT *
FROM silver.my_table
WHERE date_col IS NULL;



-- Step 2 → Duplicates
SELECT date_col, COUNT(*)
FROM silver.my_table
GROUP BY date_col
HAVING COUNT(*) > 1;



-- Step 3 → Validate Data Types
-- Detect invalid date formats stored as text
SELECT *
FROM silver.my_table
WHERE TO_DATE(date_col::TEXT, 'YYYY-MM-DD') IS NULL;



-- Step 4 → Validate Value Ranges
-- Detect impossible or future dates
SELECT *
FROM silver.my_table
WHERE date_col > NOW()
   OR date_col < '1900-01-01';



-- Step 5 → Standardize Formats
-- Check inconsistent formats (string vs date)
SELECT date_col, COUNT(*)
FROM silver.my_table
GROUP BY date_col
ORDER BY date_col;



-- Step 6 → Cross-Table Integrity
-- Example: ensure shipment_date >= order_date
SELECT *
FROM silver.orders
WHERE shipment_date < order_date;