-- View all records
SELECT * FROM sales;

-- Total Revenue
SELECT SUM(price * quantity) AS total_revenue
FROM sales;

-- Revenue by Category
SELECT category, SUM(price * quantity) AS revenue
FROM sales
GROUP BY category
ORDER BY revenue DESC;

-- Top Selling Products
SELECT product, SUM(quantity) AS total_units_sold
FROM sales
GROUP BY product
ORDER BY total_units_sold DESC;

-- Total Customers (unique)
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM sales;

-- Sales by City
SELECT city, SUM(price * quantity) AS total_sales
FROM sales
GROUP BY city
ORDER BY total_sales DESC;

-- Monthly Sales Trend
SELECT 
    DATE_TRUNC('month', order_date) AS month,
    SUM(price * quantity) AS revenue
FROM sales
GROUP BY month
ORDER BY month;
