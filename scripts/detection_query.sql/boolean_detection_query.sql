-- 4. BOOLEAN / CATEGORICAL COLUMNS ✅
-- (Examples: gender, marital_status, is_active, has_email)


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
-- Detect unexpected boolean values
SELECT DISTINCT col
FROM silver.my_table
WHERE col NOT IN ('TRUE','FALSE','1','0','Y','N');



-- Step 4 → Validate Value Ranges
-- Detect unexpected categorical values
SELECT DISTINCT col
FROM silver.my_table
WHERE col NOT IN ('Single','Married','Divorced','Widowed');



-- Step 5 → Standardize Formats
-- Enforce lowercase categories
SELECT DISTINCT LOWER(col) AS standardized
FROM silver.my_table;



-- Step 6 → Cross-Table Integrity



-- -- Example: gender values in customers should match HR master table
SELECT c.customer_id, c.gender
FROM silver.customers c
LEFT JOIN silver.hr_gender_reference h
       ON c.gender = h.gender
WHERE h.gender IS NULL;