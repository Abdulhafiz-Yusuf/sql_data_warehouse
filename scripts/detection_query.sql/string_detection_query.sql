-- 1. STRING / TEXT COLUMNS 📜
-- (Examples: names, emails, addresses, IDs)

-- Step 1 → Missing Values
SELECT *
FROM silver.my_table
WHERE col IS NULL OR TRIM(col) = '' OR col ILIKE 'N/A' OR col ILIKE 'UNKNOWN';

-- Step 2 → Duplicates
SELECT col, COUNT(*) 
FROM silver.my_table
GROUP BY col
HAVING COUNT(*) > 1;


-- Step 3 → Validate Data Types
-- Detect unexpected characters (allow only letters, spaces, and hyphens)
SELECT *
FROM silver.my_table
WHERE col ~ '[^A-Za-z -]';

-- Step 4 → Validate Value Ranges
-- Example: name length too short or too long
SELECT *
FROM silver.my_table
WHERE LENGTH(col) < 2 OR LENGTH(col) > 100;


--Step 5 → Standardize Formats
-- Detect leading/trailing spaces
SELECT *
FROM silver.my_table
WHERE col <> TRIM(col);

-- Detect multiple spaces within text
SELECT *
FROM silver.my_table
WHERE col ~ '  +';

-- Detect inconsistent casing
SELECT DISTINCT col FROM silver.my_table;


-- Step 6 → Cross-Table Integrity
-- Example: emails in customers table but not found in marketing table
SELECT c.email
FROM silver.customers c
LEFT JOIN silver.marketing m
       ON c.email = m.email
WHERE m.email IS NULL;
