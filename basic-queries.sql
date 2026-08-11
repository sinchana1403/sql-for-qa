-- ================================================
-- BASIC SQL QUERIES FOR QA ENGINEERS
-- Prepared By: Sinchana
-- Date: August 2026
-- Topics: SELECT, WHERE, ORDER BY, LIMIT, DISTINCT
-- ================================================


-- ================================================
-- SECTION 1: SELECT STATEMENTS
-- ================================================

-- Fetch all columns from CUSTOMERS table
-- QA Use: Verify all customer records after bulk registration test
SELECT * FROM CUSTOMERS;

-- Fetch specific columns only
-- QA Use: Verify only required fields without unnecessary data
SELECT name, email, city FROM CUSTOMERS;

-- Fetch all orders
-- QA Use: Verify all orders exist after placing multiple test orders
SELECT * FROM ORDERS;

-- Fetch all products
-- QA Use: Verify product catalogue is complete
SELECT * FROM PRODUCTS;


-- ================================================
-- SECTION 2: WHERE CLAUSE — FILTERING ROWS
-- ================================================

-- Find all customers from Bengaluru
-- QA Use: Verify city-based filtering feature works correctly
SELECT * FROM CUSTOMERS
WHERE city = 'Bengaluru';

-- Find all delivered orders
-- QA Use: Verify order status filter shows correct results
SELECT * FROM ORDERS
WHERE status = 'Delivered';

-- Find all pending orders
-- QA Use: Verify pending orders appear in admin dashboard
SELECT * FROM ORDERS
WHERE status = 'Pending';

-- Find all cancelled orders
-- QA Use: Verify cancelled orders are tracked correctly
SELECT * FROM ORDERS
WHERE status = 'Cancelled';

-- Find all orders with amount greater than 10000
-- QA Use: Verify high-value order flagging feature
SELECT * FROM ORDERS
WHERE amount > 10000;

-- Find all customers aged 25 or below
-- QA Use: Verify age-based eligibility filter
SELECT name, age FROM CUSTOMERS
WHERE age <= 25;

-- Find all products priced below 5000
-- QA Use: Verify budget product filter on UI
SELECT * FROM PRODUCTS
WHERE price < 5000;


-- ================================================
-- SECTION 3: LOGICAL OPERATORS — AND, OR, NOT
-- ================================================

-- Find customers from Bengaluru aged above 25
-- QA Use: Verify combined filter — city AND age
SELECT * FROM CUSTOMERS
WHERE city = 'Bengaluru' AND age > 25;

-- Find customers from Mumbai or Chennai
-- QA Use: Verify multi-city filter works correctly
SELECT * FROM CUSTOMERS
WHERE city = 'Mumbai' OR city = 'Chennai';

-- Find orders that are NOT delivered
-- QA Use: Verify non-delivered orders appear in pending report
SELECT * FROM ORDERS
WHERE status != 'Delivered';

-- Find Electronics products priced above 5000
-- QA Use: Verify category and price combined filter
SELECT * FROM PRODUCTS
WHERE category = 'Electronics' AND price > 5000;


-- ================================================
-- SECTION 4: BETWEEN, IN, NOT IN
-- ================================================

-- Find orders with amount between 1000 and 15000
-- QA Use: Verify price range filter on order history page
SELECT * FROM ORDERS
WHERE amount BETWEEN 1000 AND 15000;

-- Find customers from multiple cities using IN
-- QA Use: Verify multi-select city filter
SELECT * FROM CUSTOMERS
WHERE city IN ('Bengaluru', 'Mumbai', 'Delhi');

-- Find orders that are not delivered or cancelled
-- QA Use: Verify active orders report
SELECT * FROM ORDERS
WHERE status NOT IN ('Delivered', 'Cancelled');

-- Find products in Electronics category
-- QA Use: Verify category filter returns correct products
SELECT * FROM PRODUCTS
WHERE category IN ('Electronics');


-- ================================================
-- SECTION 5: LIKE — PATTERN MATCHING
-- ================================================

-- Find customers whose name starts with R
-- QA Use: Verify name-based search autocomplete
SELECT * FROM CUSTOMERS
WHERE name LIKE 'R%';

-- Find products containing the word phone
-- QA Use: Verify search returns all phone-related products
SELECT * FROM PRODUCTS
WHERE product_name LIKE '%phone%';

-- Find customers with gmail email addresses
-- QA Use: Verify email domain filter
SELECT * FROM CUSTOMERS
WHERE email LIKE '%@gmail.com';


-- ================================================
-- SECTION 6: ORDER BY — SORTING RESULTS
-- ================================================

-- Sort customers by age youngest to oldest
-- QA Use: Verify age-based sorting on customer list
SELECT name, age FROM CUSTOMERS
ORDER BY age ASC;

-- Sort orders by amount highest to lowest
-- QA Use: Verify high value order sorting on dashboard
SELECT order_id, product_name, amount FROM ORDERS
ORDER BY amount DESC;

-- Sort products by price lowest to highest
-- QA Use: Verify price sorting feature on product listing page
SELECT product_name, price FROM PRODUCTS
ORDER BY price ASC;

-- Sort customers by city alphabetically
-- QA Use: Verify alphabetical sorting on customer report
SELECT name, city FROM CUSTOMERS
ORDER BY city ASC;


-- ================================================
-- SECTION 7: LIMIT — RESTRICTING RESULTS
-- ================================================

-- Get top 3 most expensive products
-- QA Use: Verify featured products section shows correct items
SELECT product_name, price FROM PRODUCTS
ORDER BY price DESC
LIMIT 3;

-- Get most recent customer registration
-- QA Use: Verify latest registered user appears first
SELECT * FROM CUSTOMERS
ORDER BY registration_date DESC
LIMIT 1;

-- Get top 5 highest value orders
-- QA Use: Verify top orders report on admin dashboard
SELECT * FROM ORDERS
ORDER BY amount DESC
LIMIT 5;


-- ================================================
-- SECTION 8: DISTINCT — REMOVING DUPLICATES
-- ================================================

-- Get all unique cities where customers live
-- QA Use: Verify city dropdown contains correct unique values
SELECT DISTINCT city FROM CUSTOMERS;

-- Get all unique order statuses
-- QA Use: Verify status filter dropdown has correct options
SELECT DISTINCT status FROM ORDERS;

-- Get all unique product categories
-- QA Use: Verify category filter shows correct unique categories
SELECT DISTINCT category FROM PRODUCTS;


-- ================================================
-- SECTION 9: NULL HANDLING
-- ================================================

-- Find customers with missing city information
-- QA Use: Verify mandatory field validation — city should never be NULL
SELECT * FROM CUSTOMERS
WHERE city IS NULL;

-- Find products with no stock information
-- QA Use: Verify stock field is always populated — NULL stock is a bug
SELECT * FROM PRODUCTS
WHERE stock IS NULL;

-- Find customers where email is not null
-- QA Use: Verify all customers have email stored correctly
SELECT * FROM CUSTOMERS
WHERE email IS NOT NULL;

-- Count NULL values in city column
-- QA Use: Data integrity check — count missing city records
SELECT COUNT(*) - COUNT(city) AS null_city_count
FROM CUSTOMERS;


-- ================================================
-- SECTION 10: INSERT, UPDATE, DELETE
-- ================================================

-- Insert a test customer for testing purposes
-- QA Use: Create test data directly in database
INSERT INTO CUSTOMERS (customer_id, name, email, city, age, registration_date)
VALUES (99, 'Test User', 'testuser@gmail.com', 'Bengaluru', 25, '2026-08-01');

-- Verify test customer was inserted correctly
SELECT * FROM CUSTOMERS
WHERE name = 'Test User';

-- Update test customer city
-- QA Use: Verify UPDATE operation works correctly
UPDATE CUSTOMERS
SET city = 'Mumbai'
WHERE customer_id = 99;

-- Verify update was applied
SELECT * FROM CUSTOMERS
WHERE customer_id = 99;

-- Delete test customer after testing
-- QA Use: Clean up test data after test run
DELETE FROM CUSTOMERS
WHERE customer_id = 99;

-- Verify deletion was successful
SELECT * FROM CUSTOMERS
WHERE customer_id = 99;
-- Expected: 0 rows returned
