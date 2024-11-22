-- Create a new database for the store
CREATE DATABASE SCPStore;
USE SCPStore;

-- Step 1: Create tables

-- Customers table to store customer details
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
);

-- Products table to store SCP toys and their prices
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

-- Orders table to store customer orders
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Order Items table to store details of products in each order
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Step 2: Insert sample data

-- Insert customers
INSERT INTO customers (name, email) VALUES
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com'),
('Charlie', 'charlie@example.com');

-- Insert SCP toy products
INSERT INTO products (name, price) VALUES
('SCP-173 Toy', 15.00),
('SCP-049 Action Figure', 25.00),
('SCP-682 Plushie', 40.00),
('SCP-096 Collectible', 30.00),
('SCP-939 Miniature', 20.00);

-- Insert orders
INSERT INTO orders (customer_id, order_date) VALUES
(1, '2024-11-01'),
(2, '2024-11-05'),
(3, '2024-11-10');

-- Insert order items
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 2), -- Alice bought 2 SCP-173 Toys
(1, 3, 1), -- Alice bought 1 SCP-682 Plushie
(2, 2, 3), -- Bob bought 3 SCP-049 Action Figures
(2, 4, 2), -- Bob bought 2 SCP-096 Collectibles
(3, 5, 1), -- Charlie bought 1 SCP-939 Miniature
(3, 1, 1); -- Charlie bought 1 SCP-173 Toy

-- Step 3: Queries

-- Query 1: Get order details with customer information
SELECT 
    o.order_id, o.order_date, c.name AS customer_name, c.email
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

-- Query 2: Get order line items with product details and prices
SELECT 
    oi.order_item_id, o.order_id, c.name AS customer_name, 
    p.name AS product_name, oi.quantity, p.price, (oi.quantity * p.price) AS total_price
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON oi.product_id = p.product_id;

-- Query 3: Calculate total revenue per customer
SELECT 
    c.name AS customer_name, SUM(oi.quantity * p.price) AS total_revenue
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY c.customer_id;

-- Query 4: Calculate total revenue for the store
SELECT 
    SUM(oi.quantity * p.price) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id;

-- Query 5: Calculate average order value
SELECT 
    AVG(order_total) AS average_order_value
FROM (
    SELECT 
        o.order_id, SUM(oi.quantity * p.price) AS order_total
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY o.order_id
) AS order_totals;

-- Query 6: Count the number of orders per customer
SELECT 
    c.name AS customer_name, COUNT(o.order_id) AS order_count
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id;

-- End of script
