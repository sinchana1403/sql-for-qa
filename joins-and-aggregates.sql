-- ================================================
-- JOINS AND AGGREGATE FUNCTIONS FOR QA ENGINEERS
-- Prepared By: Sinchana
-- Date: August 2026
-- Topics: COUNT, SUM, AVG, MIN, MAX, GROUP BY,
--         HAVING, INNER JOIN, LEFT JOIN, RIGHT JOIN
-- ================================================


-- ================================================
-- SECTION 1: AGGREGATE FUNCTIONS
-- ================================================

-- COUNT — Total number of customers
-- QA Use: Verify dashboard shows correct total customer count
SELECT COUNT(*) AS total_customers
FROM CUSTOMERS;

-- COUNT — Total number of orders
-- QA Use: Verify total order count shown on admin dashboard
SELECT COUNT(*) AS total_orders
FROM ORDERS;

-- COUNT — Total delivered orders
-- QA Use: Verify delivered orders count on reports page
SELECT COUNT(*) AS delivered_orders
FROM ORDERS
WHERE status = 'Delivered';

-- COUNT(*) vs COUNT(column_name)
-- COUNT(*) includes NULL rows, COUNT(column) excludes NULLs
SELECT COUNT(*) AS total_rows,
       COUNT(city) AS non_null_city_count
FROM CUSTOMERS;

-- SUM — Total revenue from all orders
-- QA Use: Verify total revenue figure shown on dashboard
SELECT SUM(amount) AS total_revenue
FROM ORDERS;

-- SUM — Total revenue from delivered orders only
-- QA Use: Verify confirmed revenue excludes cancelled orders
SELECT SUM(amount) AS confirmed_revenue
FROM ORDERS
WHERE status = 'Delivered';

-- AVG — Average order amount
-- QA Use: Verify average order value metric on dashboard
SELECT AVG(amount) AS average_order_value
FROM ORDERS;

-- AVG — Average price of Electronics products
-- QA Use: Verify category average price displayed correctly
SELECT AVG(price) AS avg_electronics_price
FROM PRODUCTS
WHERE category = 'Electronics';

-- MIN — Cheapest product price
-- QA Use: Verify minimum price shown in price range filter
SELECT MIN(price) AS cheapest_product
FROM PRODUCTS;

-- MAX — Most expensive product price
-- QA Use: Verify maximum price shown in price range filter
SELECT MAX(price) AS most_expensive_product
FROM PRODUCTS;

-- MIN and MAX order amounts together
-- QA Use: Verify price range filter boundaries are correct
SELECT MIN(amount) AS lowest_order,
       MAX(amount) AS highest_order
FROM ORDERS;

-- All aggregates together with aliases
-- QA Use: Verify complete order summary report on dashboard
SELECT COUNT(*) AS total_orders,
       SUM(amount) AS total_revenue,
       AVG(amount) AS average_order_value,
       MIN(amount) AS smallest_order,
       MAX(amount) AS largest_order
FROM ORDERS;


-- ================================================
-- SECTION 2: GROUP BY
-- ================================================

-- Count orders by status
-- QA Use: Verify order status summary on admin dashboard
SELECT status,
       COUNT(*) AS order_count
FROM ORDERS
GROUP BY status;

-- Total revenue by customer
-- QA Use: Verify total spent shown on each customer profile
SELECT customer_id,
       SUM(amount) AS total_spent
FROM ORDERS
GROUP BY customer_id;

-- Count customers by city
-- QA Use: Verify city-wise customer distribution report
SELECT city,
       COUNT(*) AS customer_count
FROM CUSTOMERS
GROUP BY city;

-- Count products by category
-- QA Use: Verify category product count on category page
SELECT category,
       COUNT(*) AS product_count
FROM PRODUCTS
GROUP BY category;

-- Average order amount by status
-- QA Use: Verify average value differs by order status
SELECT status,
       AVG(amount) AS avg_amount
FROM ORDERS
GROUP BY status;

-- Total revenue by product name
-- QA Use: Verify best selling products by revenue
SELECT product_name,
       SUM(amount) AS total_revenue,
       COUNT(*) AS times_ordered
FROM ORDERS
GROUP BY product_name
ORDER BY total_revenue DESC;


-- ================================================
-- SECTION 3: HAVING
-- ================================================

-- Find cities with more than 1 customer
-- QA Use: Verify group discount eligibility by city
SELECT city,
       COUNT(*) AS customer_count
FROM CUSTOMERS
GROUP BY city
HAVING COUNT(*) > 1;

-- Find customers who placed more than 1 order
-- QA Use: Verify returning customer badge logic
SELECT customer_id,
       COUNT(*) AS order_count
FROM ORDERS
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Find order statuses with total revenue above 10000
-- QA Use: Verify high revenue status categories
SELECT status,
       SUM(amount) AS total_revenue
FROM ORDERS
GROUP BY status
HAVING SUM(amount) > 10000;

-- Find duplicate email addresses
-- QA Use: Critical data integrity check — emails must be unique
SELECT email,
       COUNT(*) AS duplicate_count
FROM CUSTOMERS
GROUP BY email
HAVING COUNT(*) > 1;

-- WHERE and HAVING used together
-- Find customers with more than 1 delivered order
-- QA Use: Verify loyal customer identification logic
SELECT customer_id,
       COUNT(*) AS delivered_order_count
FROM ORDERS
WHERE status = 'Delivered'
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- ================================================
-- SECTION 4: INNER JOIN
-- ================================================

-- Get customer name with each order
-- QA Use: Verify order history shows correct customer details
SELECT c.name,
       c.city,
       o.order_id,
       o.product_name,
       o.amount,
       o.status
FROM CUSTOMERS c
INNER JOIN ORDERS o
ON c.customer_id = o.customer_id;

-- Get customer name with delivered orders only
-- QA Use: Verify delivered orders report shows correct customers
SELECT c.name,
       o.order_id,
       o.product_name,
       o.amount
FROM CUSTOMERS c
INNER JOIN ORDERS o
ON c.customer_id = o.customer_id
WHERE o.status = 'Delivered';

-- Get customer name with pending orders
-- QA Use: Verify pending orders notification targets correct users
SELECT c.name,
       c.email,
       o.order_id,
       o.product_name
FROM CUSTOMERS c
INNER JOIN ORDERS o
ON c.customer_id = o.customer_id
WHERE o.status = 'Pending';

-- Total spending per customer with name
-- QA Use: Verify total spent shown on customer profile page
SELECT c.name,
       SUM(o.amount) AS total_spent
FROM CUSTOMERS c
INNER JOIN ORDERS o
ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY total_spent DESC;

-- Find top spending customer
-- QA Use: Verify Top Spender badge assigned to correct customer
SELECT c.name,
       SUM(o.amount) AS total_spent
FROM CUSTOMERS c
INNER JOIN ORDERS o
ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY total_spent DESC
LIMIT 1;

-- Count orders per city
-- QA Use: Verify city-wise order distribution on analytics page
SELECT c.city,
       COUNT(o.order_id) AS total_orders
FROM CUSTOMERS c
INNER JOIN ORDERS o
ON c.customer_id = o.customer_id
GROUP BY c.city
ORDER BY total_orders DESC;


-- ================================================
-- SECTION 5: LEFT JOIN
-- ================================================

-- Get all customers with their orders
-- Including customers who have never placed an order
-- QA Use: Verify customer list shows all customers regardless of order history
SELECT c.name,
       c.city,
       o.order_id,
       o.product_name,
       o.amount
FROM CUSTOMERS c
LEFT JOIN ORDERS o
ON c.customer_id = o.customer_id;

-- Find customers who have NEVER placed an order
-- QA Use: Verify first order reminder email targets correct customers
SELECT c.name,
       c.email
FROM CUSTOMERS c
LEFT JOIN ORDERS o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Find orphaned orders (orders with no matching customer)
-- QA Use: Critical data integrity check — no order should exist
--         without a valid customer
SELECT o.order_id,
       o.product_name,
       o.amount
FROM CUSTOMERS c
RIGHT JOIN ORDERS o
ON c.customer_id = o.customer_id
WHERE c.customer_id IS NULL;

-- Verify no orphaned orders exist
-- QA Use: Data integrity validation query
SELECT COUNT(*) AS orphaned_orders
FROM ORDERS
WHERE customer_id NOT IN (
    SELECT customer_id FROM CUSTOMERS
);
-- Expected result: 0
-- If result is not 0 — data integrity bug found
