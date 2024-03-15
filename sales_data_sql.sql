-- Creating Database
CREATE DATABASE salesbloomacre;

-- Creating Tables
CREATE TABLE customers(
company_name VARCHAR(36) PRIMARY KEY,
address VARCHAR(30),
city VARCHAR(16),
state_code VARCHAR(2),
zip_code INT);

CREATE TABLE customer_location(
company_name VARCHAR(36),
address VARCHAR(30),
city VARCHAR(16),
state_code VARCHAR(2),
zip_code INT,
FOREIGN KEY (company_name) REFERENCES customers(company_name));

CREATE TABLE transactions(
transaction_id INT PRIMARY KEY,
salesperson VARCHAR(9),
transaction_date DATE,
payment_month VARCHAR(3),
status VARCHAR(8),
revenue NUMERIC(10,2),
company_name VARCHAR(36),
FOREIGN KEY(company_name) REFERENCES customers(company_name));

-- Importing Data
COPY customers(company_name)
FROM 'C:\Users\Public\Public Doc4SQL\customers_name.csv'
DELIMITER ','
CSV HEADER;

COPY transactions(transaction_id, salesperson, transaction_date, payment_month,status,revenue,company_name)
FROM 'C:\Users\Public\Public Doc4SQL\transaction_data.csv'
DELIMITER ','
CSV HEADER;

COPY customer_location(company_name, address, city, state_code, zip_code)
FROM 'C:\Users\Public\Public Doc4SQL\customers_data.csv'
DELIMITER ','
CSV HEADER;

-- Showcasing Potential for Data Querys

-- Showing Entire Dataset
SELECT *
FROM transactions
JOIN customers ON transactions.company_name = customers.company_name
JOIN customer_location ON customers.company_name = customer_location.company_name;


-- Displaying the top 5 performing sales managers
SELECT salesperson, SUM(revenue)
FROM transactions
JOIN customers ON transactions.company_name = customers.company_name
GROUP BY salesperson
ORDER BY SUM DESC
LIMIT 5;

-- Displaying the amount of new revenue generated each month
SELECT payment_month, SUM(revenue) as total_new_revenue
FROM transactions
WHERE status = 'New'
GROUP BY payment_month
ORDER BY total_new_revenue DESC;

-- Displaying average revenue by customer and state
SELECT state_code, transactions.company_name, AVG(revenue)
FROM customers
JOIN transactions ON customers.company_name = transactions.company_name
JOIN customer_location ON customers.company_name = customer_location.company_name
GROUP BY state_code, transactions.company_name;

-- Showing total amount of lapsed revenue by state
SELECT state_code, SUM(revenue)
FROM customers
JOIN transactions ON customers.company_name = transactions.company_name
JOIN customer_location ON customers.company_name = customer_location.company_name
WHERE transactions.status = 'Lapsed'
GROUP BY state_code
ORDER BY SUM DESC;