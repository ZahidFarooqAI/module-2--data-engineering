CREATE TABLE IF NOT EXISTS sales (
    order_id INT PRIMARY KEY,
    customer_id VARCHAR(10),
    customer_name VARCHAR(100),
    product VARCHAR(100),
    category VARCHAR(50),
    price NUMERIC(10,2),
    quantity INT,
    order_date DATE,
    city VARCHAR(1000),
    country VARCHAR(50),
    payment_method VARCHAR(50)
);