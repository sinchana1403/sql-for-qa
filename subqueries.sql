-- ================================================
-- Prepared By: Sinchana
-- Date: August 2026
-- Topics: Subqueries with WHERE, IN, NOT IN,
--         EXISTS, NOT EXISTS, FROM clause,
--         Second Highest, nth Highest
-- ================================================


-- ================================================
-- SECTION 1: SUBQUERY WITH = (SINGLE VALUE)
-- ================================================

-- Find all orders placed by Rahul Kumar
-- QA Use: Verify specific customer order history
SELECT * FROM ORDERS
WHERE customer_id = (
    SELECT customer_id
    FROM CUSTOMERS
    WHERE name = 'Rahul Kumar'
);

-- Find all orders placed by Kavya Nair
-- QA Use: Verify customer-specific order details
SELECT * FROM ORDERS
WHERE customer_id = (
    SELECT customer_id
    FROM CUSTOMERS
    WHERE name = 'Kavya Nair'
);

-- Find products priced above average price
-- QA Use: Verify premium products section shows
--         only above-average priced items
SELECT product_name, price
FROM PRODUCTS
WHERE price > (
    SELECT AVG(price)
    FROM PRODUCTS
);

-- Find orders above average order amount
-- QA Use: Verify high value order flagging is correct
SELECT * FROM ORDERS
WHERE amount > (
    SELECT AVG(amount)
    FROM ORDERS
);


-- ================================================
-- SECTION 2: SUBQUERY WITH IN (MULTIPLE VALUES)
-- ================================================

-- Find all orders placed by customers from Bengaluru
-- QA Use: Verify city-based order report is correct
SELECT * FROM ORDERS
WHERE customer_id IN (
    SELECT customer_id
    FROM CUSTOMERS
    WHERE city = 'Bengaluru'
);

-- Find all orders placed by customers from Delhi
-- QA Use: Verify region-specific order data
SELECT * FROM ORDERS
WHERE customer_id IN (
    SELECT customer_id
    FROM CUSTOMERS
    WHERE city = 'Delhi'
);

-- Find names of customers who have placed at least one order
-- QA Use: Verify active customer list is correct
SELECT name FROM CUSTOMERS
WHERE customer_id IN (
    SELECT DISTINCT customer_id
    FROM ORDERS
);

-- Find customers who placed orders above 20000
-- QA Use: Verify high value customer identification
SELECT name, city FROM CUSTOMERS
WHERE customer_id IN (
    SELECT customer_id
    FROM ORDERS
    WHERE amount > 20000
);

-- Find customers who have placed delivered orders
-- QA Use: Verify loyal customer report
SELECT name FROM CUSTOMERS
WHERE customer_id IN (
    SELECT customer_id
    FROM ORDERS
    WHERE status = 'Delivered'
);


-- ================================================
-- SECTION 3: SUBQUERY WITH NOT IN
-- ================================================

-- Find customers who have NEVER placed an order
-- QA Use: Verify first order reminder targets correct users
SELECT name, email FROM CUSTOMERS
WHERE customer_id NOT IN (
    SELECT DISTINCT customer_id
    FROM ORDERS
);

-- Find customers who have NOT placed any delivered orders
-- QA Use: Verify customers without completed purchases
SELECT name FROM CUSTOMERS
WHERE customer_id NOT IN (
    SELECT customer_id
    FROM ORDERS
    WHERE status = 'Delivered'
);

-- Find customers who placed orders but are NOT from Bengaluru
-- QA Use: Verify non-Bengaluru active customers
SELECT * FROM CUSTOMERS
WHERE customer_id IN (
    SELECT customer_id FROM ORDERS
)
AND customer_id NOT IN (
    SELECT customer_id
    FROM CUSTOMERS
    WHERE city = 'Bengaluru'
);

-- Verify no orphaned orders exist
-- QA Use: Critical data integrity check
SELECT * FROM ORDERS
WHERE customer_id NOT IN (
    SELECT customer_id
    FROM CUSTOMERS
);
-- Expected: 0 rows returned
-- Any rows returned = data integrity bug


-- ================================================
-- SECTION 4: EXISTS AND NOT EXISTS
-- ================================================

-- Find customers who have placed at least one order
-- QA Use: Identify active customers efficiently
SELECT name FROM CUSTOMERS c
WHERE EXISTS (
    SELECT 1 FROM ORDERS o
    WHERE o.customer_id = c.customer_id
);

-- Find customers who have never placed an order
-- QA Use: Target inactive customers for re-engagement
SELECT name FROM CUSTOMERS c
WHERE NOT EXISTS (
    SELECT 1 FROM ORDERS o
    WHERE o.customer_id = c.customer_id
);

-- Find customers who have at least one delivered order
-- QA Use: Verify completed purchase customer list
SELECT name FROM CUSTOMERS c
WHERE EXISTS (
    SELECT 1 FROM ORDERS o
    WHERE o.customer_id = c.customer_id
    AND o.status = 'Delivered'
);


-- ================================================
-- SECTION 5: SUBQUERY IN FROM CLAUSE
--            (DERIVED TABLE)
-- ================================================

-- Find customers whose total spending is above 20000
-- QA Use: Verify premium customer tier assignment
SELECT customer_id, total_spent
FROM (
    SELECT customer_id,
           SUM(amount) AS total_spent
    FROM ORDERS
    GROUP BY customer_id
) AS spending_summary
WHERE total_spent > 20000;

-- Find order status categories with
-- average amount above 15000
-- QA Use: Verify high value order category report
SELECT status, avg_amount
FROM (
    SELECT status,
           AVG(amount) AS avg_amount
    FROM ORDERS
    GROUP BY status
) AS status_summary
WHERE avg_amount > 15000;


-- ================================================
-- SECTION 6: MOST IMPORTANT INTERVIEW QUESTIONS
-- ================================================

-- QUESTION 1: Find the second highest order amount
-- Method 1: Using subquery (most common in interviews)
SELECT MAX(amount) AS second_highest_amount
FROM ORDERS
WHERE amount < (
    SELECT MAX(amount)
    FROM ORDERS
);

-- Method 2: Using ORDER BY and LIMIT
SELECT DISTINCT amount
FROM ORDERS
ORDER BY amount DESC
LIMIT 1 OFFSET 1;

-- QUESTION 2: Find the third highest order amount
-- QA Use: Verify top 3 orders report
SELECT MAX(amount) AS third_highest_amount
FROM ORDERS
WHERE amount < (
    SELECT MAX(amount)
    FROM ORDERS
    WHERE amount < (
        SELECT MAX(amount)
        FROM ORDERS
    )
);

-- Method 2: Using OFFSET
SELECT DISTINCT amount
FROM ORDERS
ORDER BY amount DESC
LIMIT 1 OFFSET 2;

-- QUESTION 3: Find duplicate email addresses
-- QA Use: Critical data integrity check
--         Email must be unique per user
SELECT email,
       COUNT(*) AS duplicate_count
FROM CUSTOMERS
GROUP BY email
HAVING COUNT(*) > 1;

-- Get complete details of customers with duplicate emails
SELECT * FROM CUSTOMERS
WHERE email IN (
    SELECT email
    FROM CUSTOMERS
    GROUP BY email
    HAVING COUNT(*) > 1
);

-- QUESTION 4: Find records in Table A
-- that don't exist in Table B
-- Three methods — all give same result

-- Method 1: NOT IN subquery
SELECT name FROM CUSTOMERS
WHERE customer_id NOT IN (
    SELECT DISTINCT customer_id FROM ORDERS
);

-- Method 2: LEFT JOIN with IS NULL
SELECT c.name FROM CUSTOMERS c
LEFT JOIN ORDERS o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Method 3: NOT EXISTS
SELECT name FROM CUSTOMERS c
WHERE NOT EXISTS (
    SELECT 1 FROM ORDERS o
    WHERE o.customer_id = c.customer_id
);

-- QUESTION 5: Find customers registered in last 30 days
-- QA Use: Verify new user badge assignment
SELECT * FROM CUSTOMERS
WHERE registration_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- QUESTION 6: Delete duplicates keeping one copy
-- QA Use: Data cleanup after duplicate registration bug
DELETE FROM CUSTOMERS
WHERE customer_id NOT IN (
    SELECT MIN(customer_id)
    FROM CUSTOMERS
    GROUP BY email
);

-- QUESTION 7: Find top spender with name
-- QA Use: Verify Top Spender badge goes to correct customer
SELECT c.name,
       SUM(o.amount) AS total_spent
FROM CUSTOMERS c
INNER JOIN ORDERS o
ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY total_spent DESC
LIMIT 1;

-- QUESTION 8: Find customers who spent more than 30000
-- QA Use: Verify platinum customer tier eligibility
SELECT c.name,
       SUM(o.amount) AS total_spent
FROM CUSTOMERS c
INNER JOIN ORDERS o
ON c.customer_id = o.customer_id
GROUP BY c.name
HAVING SUM(o.amount) > 30000
ORDER BY total_spent DESC;
