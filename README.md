# E-Commerce Sales & Customer Analytics

## Project Overview

This project analyzes e-commerce sales and customer data using **MySQL**. The goal is to answer business questions related to customers, orders, products, sellers, payments, revenue, and sales performance.

The project is designed as a **SQL portfolio project for a Data Analyst** and demonstrates practical SQL skills from beginner to advanced level.

## Objectives

- Analyze customer and order data.
- Calculate total and product-level revenue.
- Identify top customers and products.
- Analyze sales by product category and city.
- Compare payment methods.
- Analyze seller performance.
- Use advanced SQL concepts such as subqueries, window functions, views, and stored procedures.

## Tools & Technologies

- **MySQL**
- **MySQL Workbench**
- **SQL**
- **GitHub**
- **Power BI** for dashboard development

## Database Schema

The database is named:

`ecommerce_project`

It contains 6 tables:

| Table | Description |
|---|---|
| customers | Customer information and signup details |
| products | Product information, category, and price |
| sellers | Seller information |
| orders | Customer order details and status |
| order_items | Products, sellers, quantities, and prices for each order |
| payments | Payment details for orders |

## Table Relationships

- One customer can place many orders.
- One order can contain many order items.
- One product can appear in many order items.
- One seller can be associated with many order items.
- Orders are connected to payments through `order_id`.

## Business Questions

### Beginner Level

1. List all customers from Kochi.
2. Show all orders placed in the last 30 days.
3. Find the 10 most expensive products.
4. List all delivered orders.
5. Find customers who signed up in 2025.

### Intermediate Level

6. Find the total revenue generated so far.
7. Find the product category that sold the most units.
8. Find the top 5 customers by total amount spent.
9. Find sellers who generated more than ₹10 lakh in revenue.
10. Find the average order value for each city.
11. Find the number of orders and average payment value for each payment type.

### Advanced Level

12. Rank products by total revenue within each category.
13. Find customers who spent more than the average customer spend.
14. Find repeat customers with more than 20 orders.
15. Create a monthly sales summary view.
16. Create a stored procedure to get customer history.

### Additional Business Questions

17. Find the top 10 products by quantity sold.
18. Find the top 10 products by revenue.
19. Find cities where average customer spending is greater than ₹50,000.
20. Find sellers with high sales volume and revenue.
21. Find the top 5 cities by total sales revenue.

## SQL Concepts Used

- `SELECT`
- `WHERE`
- `ORDER BY`
- `LIMIT`
- `GROUP BY`
- `HAVING`
- Aggregate functions: `SUM()`, `AVG()`, `COUNT()`
- `JOIN`
- Subqueries
- `COUNT(DISTINCT)`
- Window functions
- `DENSE_RANK()`
- `CREATE VIEW`
- `CREATE PROCEDURE`
- `DELIMITER`
- Date functions

## Project Files

```text
E-Commerce-Sales-Customer-Analytics/
│
├── data/
│   ├── customers.csv
│   ├── products.csv
│   ├── sellers.csv
│   ├── orders.csv
│   ├── order_items.csv
│   └── payments.csv
│
├── sql/
│   └── ecommerce_analysis.sql
│
├── README.md
│
└── ER_Diagram.png
```

## Key Analysis Areas

The analysis focuses on:

- Revenue performance
- Customer spending
- Product sales
- Category performance
- Seller performance
- City-level sales
- Payment method analysis
- Monthly sales trends
- Repeat customer behavior

## ER Diagram

The project includes an ER diagram showing the relationships between customers, orders, order items, products, sellers, and payments.

## Future Dashboard

The SQL analysis can be connected to **Power BI** to create an interactive e-commerce dashboard containing KPIs, sales trends, customer analysis, product performance, seller performance, and city-level analysis.

## Author

**Data Analyst Portfolio Project**

---

*This project was created for learning, portfolio development, and practical SQL analysis.*
