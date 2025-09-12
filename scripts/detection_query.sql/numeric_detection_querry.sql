-- 2. NUMERIC COLUMNS 🔢
-- (Examples: prices, quantities, IDs, scores)


-- Step 1 → Missing Values
SELECT *
FROM silver.my_table
WHERE col IS NULL;


-- Step 2 → Duplicates
SELECT col, COUNT(*)
FROM silver.my_table
GROUP BY col
HAVING COUNT(*) > 1;


-- Step 3 → Validate Data Types
-- Detect numbers stored as text or corrupted entries
SELECT *
FROM silver.my_table
WHERE col::TEXT !~ '^[0-9]+$';


-- Step 4 → Validate Value Ranges
-- Example: check prices
SELECT *
FROM silver.my_table
WHERE col < 0 OR col > 1000000;


-- Step 5 → Standardize Formats
-- Check inconsistent decimal precision
SELECT DISTINCT LENGTH(SPLIT_PART(col::TEXT,'.',2)) AS decimal_places
FROM silver.my_table
WHERE col::TEXT LIKE '%.%';


-- Step 6 → Cross-Table Integrity
-- Example: product_id in sales must exist in products table
SELECT s.product_id
FROM silver.sales s
LEFT JOIN silver.products p
       ON s.product_id = p.product_id
WHERE p.product_id IS NULL;
