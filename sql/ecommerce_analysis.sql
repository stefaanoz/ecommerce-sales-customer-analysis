-- E-COMMERCE SALES & CUSTOMER ANALYTICS
-- MySQL Portfolio Project

CREATE DATABASE IF NOT EXISTS ecommerce_project;
USE ecommerce_project;

-- TABLES
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    signup_date DATE
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(150),
    category VARCHAR(100),
    price DECIMAL(10,2)
);

CREATE TABLE sellers (
    seller_id INT PRIMARY KEY,
    seller_name VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    seller_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (seller_id) REFERENCES sellers(seller_id)
);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_type VARCHAR(50),
    payment_value DECIMAL(10,2),
    payment_date DATE,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Q1: List all customers from Kochi
SELECT * FROM customers WHERE city = 'Kochi';

-- Q2: Show all orders placed in the last 30 days
SELECT * FROM orders
WHERE order_date >= CURDATE() - INTERVAL 30 DAY;

-- Q3: Find the 10 most expensive products
SELECT * FROM products ORDER BY price DESC LIMIT 10;

-- Q4: List all delivered orders
SELECT * FROM orders WHERE status = 'delivered';

-- Q5: Find customers who signed up in 2025
SELECT * FROM customers
WHERE signup_date BETWEEN '2025-01-01' AND '2025-12-31';

-- Q6: Find the total revenue generated so far
SELECT ROUND(SUM(quantity * unit_price), 2) AS total_revenue
FROM order_items;

-- Q7: Find the product category that sold the most units
SELECT p.category, SUM(oi.quantity) AS total_units_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_units_sold DESC;

-- Q8: Find the top 5 customers by total amount spent
SELECT c.customer_id, c.customer_name,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC
LIMIT 5;

-- Q9: Find sellers who generated more than ₹10 lakh in revenue
SELECT s.seller_id, s.seller_name,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue
FROM sellers s
JOIN order_items oi ON s.seller_id = oi.seller_id
GROUP BY s.seller_id, s.seller_name
HAVING SUM(oi.quantity * oi.unit_price) > 1000000
ORDER BY total_revenue DESC;

-- Q10: Find the average order value for each city
SELECT c.city, ROUND(AVG(order_total), 2) AS average_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN (
    SELECT order_id, SUM(quantity * unit_price) AS order_total
    FROM order_items
    GROUP BY order_id
) oi ON o.order_id = oi.order_id
GROUP BY c.city
ORDER BY average_order_value DESC;

-- Q11: Find number of orders and average payment value by payment type
SELECT payment_type,
       COUNT(order_id) AS number_of_orders,
       ROUND(AVG(payment_value), 2) AS average_payment_value
FROM payments
GROUP BY payment_type
ORDER BY number_of_orders DESC;

-- Q12: Rank products by total revenue within each category
SELECT p.category, p.product_id, p.product_name,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue,
       DENSE_RANK() OVER (
           PARTITION BY p.category
           ORDER BY SUM(oi.quantity * oi.unit_price) DESC
       ) AS revenue_rank
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.category, p.product_id, p.product_name
ORDER BY p.category, revenue_rank;

-- Q13: Customers who spent more than the average
SELECT customer_id, total_spent
FROM (
    SELECT o.customer_id,
           SUM(oi.quantity * oi.unit_price) AS total_spent
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
) AS customer_spending
WHERE total_spent > (
    SELECT AVG(total_spent)
    FROM (
        SELECT o.customer_id,
               SUM(oi.quantity * oi.unit_price) AS total_spent
        FROM orders o
        JOIN order_items oi ON o.order_id = oi.order_id
        GROUP BY o.customer_id
    ) AS spending
);

-- Q14: Find repeat customers with more than 20 orders
SELECT c.customer_id, c.customer_name,
       COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) > 20
ORDER BY total_orders DESC;

-- Q15: Create monthly sales summary view
CREATE VIEW monthly_sales_summary AS
SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_sales
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m');

SELECT * FROM monthly_sales_summary;

-- Q16: Create stored procedure for customer history
DELIMITER //

CREATE PROCEDURE get_customer_history(IN p_customer_id INT)
BEGIN
    SELECT c.customer_id, c.customer_name,
           o.order_id, o.order_date, o.status,
           oi.product_id, p.product_name,
           oi.quantity, oi.unit_price
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    WHERE c.customer_id = p_customer_id
    ORDER BY o.order_date DESC;
END //

DELIMITER ;

CALL get_customer_history(1);

-- Q17: Find the top 10 products by quantity sold
SELECT p.product_id, p.product_name,
       SUM(oi.quantity) AS total_quantity
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity DESC
LIMIT 10;

-- Q18: Find the top 10 products by revenue
SELECT p.product_id, p.product_name, p.category,
       SUM(oi.quantity) AS total_units_sold,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_revenue DESC
LIMIT 10;

-- Q19: Find cities where average customer spending is greater than ₹50,000
SELECT c.city,
       ROUND(AVG(customer_spent), 2) AS average_spending
FROM customers c
JOIN (
    SELECT o.customer_id,
           SUM(oi.quantity * oi.unit_price) AS customer_spent
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
) AS spending ON c.customer_id = spending.customer_id
GROUP BY c.city
HAVING AVG(customer_spent) > 50000
ORDER BY average_spending DESC;

-- Q20: Find sellers with high sales volume and revenue
SELECT s.seller_id, s.seller_name,
       SUM(oi.quantity) AS total_units_sold,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue
FROM sellers s
JOIN order_items oi ON s.seller_id = oi.seller_id
GROUP BY s.seller_id, s.seller_name
HAVING SUM(oi.quantity) > 100
   AND SUM(oi.quantity * oi.unit_price) > 500000
ORDER BY total_revenue DESC;

-- Q21: Find the top 5 cities by total sales revenue
SELECT c.city,
       COUNT(DISTINCT o.order_id) AS total_orders,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.city
ORDER BY total_revenue DESC
LIMIT 5;
