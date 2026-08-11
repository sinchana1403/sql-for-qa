# SQL for QA — Database Testing Queries

**Prepared By:** Sinchana  
**Date:** August 2026  
**Purpose:** SQL queries used for database testing,
data validation, and QA testing scenarios

---

## About This Repository

This repository contains SQL queries written from a
QA Engineer's perspective. Every query solves a real
database testing scenario that a QA engineer encounters
during software testing.

---

## Repository Structure
sql-for-qa/
├── basic-queries.sql
├── joins-and-aggregates.sql
├── subqueries.sql
└── qa-testing-scenarios.sql

---

## Database Schema Used

All queries are written against this e-commerce database:

### CUSTOMERS Table
| Column | Type | Description |
|---|---|---|
| customer_id | INT | Primary Key |
| name | VARCHAR | Customer full name |
| email | VARCHAR | Customer email |
| city | VARCHAR | Customer city |
| age | INT | Customer age |
| registration_date | DATE | Date of registration |

### ORDERS Table
| Column | Type | Description |
|---|---|---|
| order_id | INT | Primary Key |
| customer_id | INT | Foreign Key — CUSTOMERS |
| product_name | VARCHAR | Name of product ordered |
| amount | DECIMAL | Order amount in INR |
| order_date | DATE | Date order was placed |
| status | VARCHAR | Delivered/Pending/Cancelled/Returned |

### PRODUCTS Table
| Column | Type | Description |
|---|---|---|
| product_id | INT | Primary Key |
| product_name | VARCHAR | Name of product |
| category | VARCHAR | Product category |
| price | DECIMAL | Product price in INR |
| stock | INT | Available stock quantity |

---

## Topics Covered

- SELECT, WHERE, ORDER BY, LIMIT, DISTINCT
- Aggregate Functions — COUNT, SUM, AVG, MIN, MAX
- GROUP BY and HAVING
- INNER JOIN, LEFT JOIN, RIGHT JOIN
- Subqueries — WHERE, IN, EXISTS, FROM clause
- NULL handling — IS NULL, IS NOT NULL
- INSERT, UPDATE, DELETE
- Real QA testing scenarios

---

## Tools Used

- MySQL / SQLite compatible syntax
- Practice platform — https://sqliteonline.com

---

## Certifications

- SQL Basic — HackerRank (2026)
