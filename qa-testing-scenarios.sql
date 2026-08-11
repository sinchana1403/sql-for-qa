-- ================================================
-- SQL QUERIES FOR REAL QA TESTING SCENARIOS
-- Prepared By: Sinchana
-- Date: August 2026
-- Purpose: Database validation queries used during
--          actual software testing to verify data
--          integrity, business rules, and correctness
-- ================================================


-- ================================================
-- SCENARIO 1: USER REGISTRATION TESTING
-- ================================================

-- After registering a new user through the UI,
-- verify the record was saved correctly
-- QA Use: Post-registration database verification
SELECT * FROM CUSTOMERS
WHERE email = 'newuser@gmail.com';

-- Verify mandatory fields are not stored as NULL
-- QA Use: Mandatory field validation check
-- Expected: 0 rows returned
-- If rows returned = mandatory field stored as NULL = bug
SELECT * FROM CUSTOMERS
WHERE email = 'newuser@gmail.com'
AND (name IS NULL
     OR email IS NULL
     OR city IS NULL);

-- Verify no duplicate emails exist after registration
-- QA Use: Unique email constraint verification
SELECT email,
       COUNT(*) AS count
FROM CUSTOMERS
GROUP BY email
HAVING COUNT(*) > 1;
-- Expected: 0 rows returned

-- Verify total customer count increased by 1
-- after registration
-- QA Use: Run before and after registration
--         compare counts
SELECT COUNT(*) AS total_customers
FROM CUSTOMERS;


-- ================================================
-- SCENARIO 2: ORDER PLACEMENT TESTING
-- ================================================

-- After placing an order through the UI,
-- verify order was created in database
-- QA Use: Post-order database verification
SELECT * FROM ORDERS
WHERE customer_id = 1
ORDER BY order_id DESC
LIMIT 1;

-- Verify order amount stored matches
-- what was shown on UI
-- QA Use: Amount accuracy verification
SELECT amount FROM ORDERS
WHERE order_id = 101;
-- Compare this value with what UI displayed

-- Verify order status is set correctly
-- after placement
-- QA Use: Initial order status verification
SELECT status FROM ORDERS
WHERE order_id = 101;
-- Expected: 'Pending' or 'Confirmed'

-- Verify order is linked to correct customer
-- QA Use: Foreign key relationship verification
SELECT c.name,
       c.email,
       o.order_id,
       o.product_name,
       o.amount,
       o.status
FROM CUSTOMERS c
INNER JOIN ORDERS o
ON c.customer_id = o.customer_id
WHERE o.order_id = 101;


-- ================================================
-- SCENARIO 3: PAYMENT TESTING
-- ================================================

-- After successful payment,
-- verify order status updated correctly
-- QA Use: Payment status verification
SELECT status FROM ORDERS
WHERE order_id = 101;
-- Expected: 'Confirmed' or 'Processing'

-- Verify only one order created per payment
-- QA Use: Duplicate order prevention check
-- (catches double-click payment bug)
SELECT customer_id,
       product_name,
       amount,
       order_date,
       COUNT(*) AS duplicate_count
FROM ORDERS
GROUP BY customer_id,
         product_name,
         amount,
         order_date
HAVING COUNT(*) > 1;
-- Expected: 0 rows returned
-- Any rows = duplicate order bug found

-- Verify failed payment does not create order
-- QA Use: Run after intentionally failing payment
SELECT COUNT(*) AS order_count
FROM ORDERS
WHERE customer_id = 1
AND order_date = CURDATE();
-- Count should not increase after failed payment


-- ================================================
-- SCENARIO 4: ORDER CANCELLATION TESTING
-- ================================================

-- After cancelling an order,
-- verify status updated to Cancelled
-- QA Use: Cancellation status verification
SELECT status FROM ORDERS
WHERE order_id = 103;
-- Expected: 'Cancelled'

-- Verify cancelled order count is accurate
-- QA Use: Cancelled orders report verification
SELECT COUNT(*) AS cancelled_orders
FROM ORDERS
WHERE status = 'Cancelled';

-- Verify cancellation does not affect other orders
-- QA Use: Regression check after cancellation
SELECT * FROM ORDERS
WHERE customer_id = 1
AND status != 'Cancelled';
-- Other orders should remain unaffected


-- ================================================
-- SCENARIO 5: DATA INTEGRITY CHECKS
-- ================================================

-- Verify no orders exist without valid customer
-- QA Use: Foreign key integrity check
-- Expected: 0 rows returned
SELECT * FROM ORDERS
WHERE customer_id NOT IN (
    SELECT customer_id FROM CUSTOMERS
);

-- Verify no customers have NULL email
-- QA Use: Critical field integrity check
-- Expected: 0 rows returned
SELECT * FROM CUSTOMERS
WHERE email IS NULL;

-- Verify no products have NULL stock
-- QA Use: Inventory integrity check
-- Expected: 0 rows returned
SELECT * FROM PRODUCTS
WHERE stock IS NULL;

-- Verify no orders have NULL amount
-- QA Use: Payment amount integrity check
-- Expected: 0 rows returned
SELECT * FROM ORDERS
WHERE amount IS NULL;

-- Verify no orders have amount of zero or negative
-- QA Use: Business rule validation
-- Expected: 0 rows returned
SELECT * FROM ORDERS
WHERE amount <= 0;

-- Verify all order statuses are valid values
-- QA Use: Status field validation
-- Expected: Only Delivered/Pending/Cancelled/Returned
SELECT DISTINCT status FROM ORDERS;

-- Find any invalid status values
-- QA Use: Data quality check
SELECT * FROM ORDERS
WHERE status NOT IN (
    'Delivered',
    'Pending',
    'Cancelled',
    'Returned'
);
-- Expected: 0 rows returned


-- ================================================
-- SCENARIO 6: BUSINESS RULE VALIDATION
-- ================================================

-- Verify total revenue calculation matches dashboard
-- QA Use: Revenue figure accuracy check
SELECT SUM(amount) AS total_revenue
FROM ORDERS
WHERE status = 'Delivered';
-- Compare with revenue shown on admin dashboard

-- Verify customer total spent matches profile page
-- QA Use: Customer spending accuracy check
SELECT SUM(o.amount) AS total_spent
FROM CUSTOMERS c
INNER JOIN ORDERS o
ON c.customer_id = o.customer_id
WHERE c.name = 'Rahul Kumar';
-- Compare with total shown on Rahul's profile

-- Verify returning customer count is correct
-- QA Use: Returning customer badge verification
SELECT COUNT(*) AS returning_customers
FROM (
    SELECT customer_id
    FROM ORDERS
    GROUP BY customer_id
    HAVING COUNT(*) > 1
) AS returning;

-- Verify top spender identification is correct
-- QA Use: Top spender badge assignment check
SELECT c.name,
       SUM(o.amount) AS total_spent
FROM CUSTOMERS c
INNER JOIN ORDERS o
ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY total_spent DESC
LIMIT 1;

-- Verify Electronics average price matches UI display
-- QA Use: Category average price accuracy check
SELECT AVG(price) AS electronics_avg_price
FROM PRODUCTS
WHERE category = 'Electronics';
-- Compare with value shown on category page


-- ================================================
-- SCENARIO 7: REGRESSION TESTING QUERIES
-- ================================================

-- Run these queries before and after every
-- new feature deployment to verify nothing broke

-- Check 1: Total customer count unchanged
SELECT COUNT(*) AS customer_count FROM CUSTOMERS;

-- Check 2: Total order count correct
SELECT COUNT(*) AS order_count FROM ORDERS;

-- Check 3: Order status distribution unchanged
SELECT status,
       COUNT(*) AS count
FROM ORDERS
GROUP BY status;

-- Check 4: No new NULL values introduced
SELECT COUNT(*) AS null_emails
FROM CUSTOMERS
WHERE email IS NULL;

SELECT COUNT(*) AS null_amounts
FROM ORDERS
WHERE amount IS NULL;

-- Check 5: No new duplicate emails
SELECT COUNT(*) AS duplicate_emails
FROM (
    SELECT email
    FROM CUSTOMERS
    GROUP BY email
    HAVING COUNT(*) > 1
) AS duplicates;
-- Expected: 0

-- Check 6: No orphaned orders
SELECT COUNT(*) AS orphaned_orders
FROM ORDERS
WHERE customer_id NOT IN (
    SELECT customer_id FROM CUSTOMERS
);
-- Expected: 0


-- ================================================
-- SCENARIO 8: PERFORMANCE AND LOAD TEST SUPPORT
-- ================================================

-- Count records after load test
-- QA Use: Verify correct number of records
--         created during performance test
SELECT COUNT(*) AS total_orders_after_load_test
FROM ORDERS;

-- Find duplicate records created during load test
-- QA Use: Verify no duplicate transactions
--         occurred during concurrent user test
SELECT customer_id,
       product_name,
       amount,
       COUNT(*) AS count
FROM ORDERS
GROUP BY customer_id,
         product_name,
         amount
HAVING COUNT(*) > 1;

-- Verify data consistency after load test
-- QA Use: All orders should have valid status
SELECT COUNT(*) AS invalid_status_count
FROM ORDERS
WHERE status NOT IN (
    'Delivered',
    'Pending',
    'Cancelled',
    'Returned'
);
-- Expected: 0


-- ================================================
-- SCENARIO 9: TEST DATA MANAGEMENT
-- ================================================

-- Insert test customer for testing
INSERT INTO CUSTOMERS
(customer_id, name, email, city, age, registration_date)
VALUES
(99, 'QA Test User', 'qatest@gmail.com',
 'Bengaluru', 25, '2026-08-01');

-- Insert test order for testing
INSERT INTO ORDERS
(order_id, customer_id, product_name, amount,
 order_date, status)
VALUES
(999, 99, 'Test Product', 100,
 '2026-08-01', 'Pending');

-- Verify test data was inserted correctly
SELECT c.name,
       o.order_id,
       o.product_name,
       o.amount,
       o.status
FROM CUSTOMERS c
INNER JOIN ORDERS o
ON c.customer_id = o.customer_id
WHERE c.customer_id = 99;

-- Clean up test data after test run
DELETE FROM ORDERS
WHERE order_id = 999;

DELETE FROM CUSTOMERS
WHERE customer_id = 99;

-- Verify cleanup was successful
SELECT * FROM CUSTOMERS WHERE customer_id = 99;
SELECT * FROM ORDERS WHERE order_id = 999;
-- Both expected: 0 rows returned


-- ================================================
-- SCENARIO 10: QUICK REFERENCE — TOP INTERVIEW
--              QUERIES FOR QA ENGINEERS
-- ================================================

-- 1. Find duplicate records
SELECT email, COUNT(*) FROM CUSTOMERS
GROUP BY email HAVING COUNT(*) > 1;

-- 2. Find second highest value
SELECT MAX(amount) FROM ORDERS
WHERE amount < (SELECT MAX(amount) FROM ORDERS);

-- 3. Find records in A not in B
SELECT name FROM CUSTOMERS
WHERE customer_id NOT IN
(SELECT DISTINCT customer_id FROM ORDERS);

-- 4. Find NULL values
SELECT * FROM CUSTOMERS WHERE email IS NULL;

-- 5. Find top spender
SELECT c.name, SUM(o.amount) AS total
FROM CUSTOMERS c
JOIN ORDERS o ON c.customer_id = o.customer_id
GROUP BY c.name ORDER BY total DESC LIMIT 1;

-- 6. Count by category
SELECT status, COUNT(*) FROM ORDERS
GROUP BY status;

-- 7. Find records created today
SELECT * FROM ORDERS
WHERE order_date = CURDATE();

-- 8. Find above average values
SELECT * FROM ORDERS
WHERE amount > (SELECT AVG(amount) FROM ORDERS);
