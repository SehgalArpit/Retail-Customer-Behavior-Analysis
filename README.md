# Retail-Customer-Behavior-Analysis
Overview
The Retail Customer Behavior Analysis project provides insights into customer behavior based on transactional data collected from a retail store. The dataset contains records across three tables: Customers, Transactions, and Product Categories. The goal of this analysis is to generate valuable business insights, including transaction trends, customer demographics, product category performance, and more.

This project aims to help retail stores optimize their operations and enhance their decision-making process by understanding patterns in sales, returns, and customer demographics.

Business Context
A retail store wants to understand customer behavior using their Point of Sale (POS) data, which includes:

Customer Data: Customer demographics like age, gender, and location.
Transaction Data: Details of each purchase, including item details, store type, transaction date, and amount.
Product Category Data: Information about product categories and their subcategories.
The analysis of this data can help businesses make better-informed decisions about inventory management, marketing strategies, and customer engagement.

Objectives
The project will focus on answering key business questions, such as:

How to track the number of transactions with returns.
Understanding customer demographics such as age, gender, and location.
Analyzing product category performance, including sales, returns, and top-selling subcategories.
Exploring transactional trends, including the frequency of transactions and the most popular sales channels.
Identifying high-value customers and customer segments.
Generating insights on sales trends, product categories, and revenue from various store types.
Data Tables
The dataset contains three main tables:

Customer: Customer demographics such as customer ID, name, age, gender, city, etc.
Transactions: Transaction details, including transaction ID, customer ID, product category, amount spent, transaction date, store type, and whether the transaction is a return.
Product Category: Product category and subcategory details for items sold.
Key SQL Queries
The project includes various SQL queries designed to answer specific business questions based on the dataset. Here are some of the SQL queries that are part of the analysis:

Data Preparation & Understanding
Total number of rows in each table:

sql
Copy code
SELECT 
    (SELECT COUNT(*) FROM Customer) AS Customer_Count,
    (SELECT COUNT(*) FROM Transactions) AS Transaction_Count,
    (SELECT COUNT(*) FROM ProductCategory) AS ProductCategory_Count;
Total number of transactions with returns:

sql
Copy code
SELECT COUNT(*) 
FROM Transactions
WHERE return_flag = 'Y';
Converting dates to a valid format:

sql
Copy code
UPDATE Transactions
SET transaction_date = CONVERT(DATE, transaction_date, 103);
Transaction time range:

sql
Copy code
SELECT 
    DATEDIFF(DAY, MIN(transaction_date), MAX(transaction_date)) AS Days,
    DATEDIFF(MONTH, MIN(transaction_date), MAX(transaction_date)) AS Months,
    DATEDIFF(YEAR, MIN(transaction_date), MAX(transaction_date)) AS Years
FROM Transactions;
Product category for sub-category "DIY":

sql
Copy code
SELECT product_category
FROM ProductCategory
WHERE sub_category = 'DIY';
Data Analysis
Most frequently used transaction channel:

sql
Copy code
SELECT TOP 1 channel, COUNT(*) AS transaction_count
FROM Transactions
GROUP BY channel
ORDER BY transaction_count DESC;
Count of Male and Female customers:

sql
Copy code
SELECT gender, COUNT(*) AS customer_count
FROM Customer
GROUP BY gender;
City with the maximum number of customers:

sql
Copy code
SELECT city, COUNT(*) AS customer_count
FROM Customer
GROUP BY city
ORDER BY customer_count DESC
LIMIT 1;
Subcategories under the "Books" category:

sql
Copy code
SELECT COUNT(DISTINCT sub_category) AS sub_category_count
FROM ProductCategory
WHERE product_category = 'Books';
Maximum quantity of products ordered in a transaction:

sql
Copy code
SELECT MAX(quantity) AS max_quantity
FROM Transactions;
Net total revenue for Electronics and Books categories:

sql
Copy code
SELECT product_category, SUM(amount) AS total_revenue
FROM Transactions
WHERE product_category IN ('Electronics', 'Books')
GROUP BY product_category;
Customers with more than 10 transactions excluding returns:

sql
Copy code
SELECT customer_id, COUNT(*) AS transaction_count
FROM Transactions
WHERE return_flag = 'N'
GROUP BY customer_id
HAVING COUNT(*) > 10;
Combined revenue from "Electronics" & "Clothing" in Flagship stores:

sql
Copy code
SELECT SUM(amount) AS total_revenue
FROM Transactions
WHERE product_category IN ('Electronics', 'Clothing')
AND store_type = 'Flagship';
Total revenue from Male customers in the Electronics category:

sql
Copy code
SELECT product_sub_category, SUM(amount) AS total_revenue
FROM Transactions
JOIN Customer ON Transactions.customer_id = Customer.customer_id
WHERE product_category = 'Electronics' AND gender = 'Male'
GROUP BY product_sub_category;
Percentage of sales and returns by product subcategory (top 5 subcategories in terms of sales):

sql
Copy code
WITH SalesData AS (
    SELECT sub_category, SUM(amount) AS total_sales
    FROM Transactions
    GROUP BY sub_category
),
ReturnData AS (
    SELECT sub_category, SUM(amount) AS total_returns
    FROM Transactions
    WHERE return_flag = 'Y'
    GROUP BY sub_category
)
SELECT s.sub_category, 
       s.total_sales, 
       r.total_returns, 
       (r.total_returns / s.total_sales) * 100 AS return_percentage
FROM SalesData s
LEFT JOIN ReturnData r ON s.sub_category = r.sub_category
ORDER BY s.total_sales DESC
LIMIT 5;
Net revenue generated by customers aged between 25-35 in the last 30 days:

sql
Copy code
SELECT SUM(amount) AS total_revenue
FROM Transactions
JOIN Customer ON Transactions.customer_id = Customer.customer_id
WHERE Customer.age BETWEEN 25 AND 35
AND transaction_date BETWEEN DATEADD(DAY, -30, (SELECT MAX(transaction_date) FROM Transactions)) AND (SELECT MAX(transaction_date) FROM Transactions);
Product category with the maximum return value in the last 3 months:

sql
Copy code
SELECT product_category, SUM(amount) AS total_returns
FROM Transactions
WHERE return_flag = 'Y'
AND transaction_date > DATEADD(MONTH, -3, GETDATE())
GROUP BY product_category
ORDER BY total_returns DESC
LIMIT 1;
Store type with the maximum sales by value and quantity:

sql
Copy code
SELECT store_type, 
       SUM(amount) AS total_sales, 
       SUM(quantity) AS total_quantity
FROM Transactions
GROUP BY store_type
ORDER BY total_sales DESC, total_quantity DESC
LIMIT 1;
Categories with average revenue above the overall average:

sql
Copy code
WITH CategoryRevenue AS (
    SELECT product_category, AVG(amount) AS avg_revenue
    FROM Transactions
    GROUP BY product_category
),
OverallRevenue AS (
    SELECT AVG(amount) AS overall_avg_revenue
    FROM Transactions
)
SELECT cr.product_category, cr.avg_revenue
FROM CategoryRevenue cr, OverallRevenue or
WHERE cr.avg_revenue > or.overall_avg_revenue;
Conclusion
This project highlights the powerful insights that can be derived from retail transactional data. By analyzing patterns in customer demographics, sales, and product categories, businesses can gain a deeper understanding of customer behavior and improve decision-making processes. Through the use of SQL queries, this project demonstrates how to extract relevant information and make data-driven conclusions.

Setup & Installation
Clone the repository:
bash
Copy code
git clone https://github.com/yourusername/retail-customer-behavior-analysis.git
Set up a local SQL Server or any other database system.
Import the dataset into your database.
Run the SQL queries to perform the analysis and obtain insights.
