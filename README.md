# Retail Customer Behavior Analysis

## Overview

The **Retail Customer Behavior Analysis** project provides insights into customer behavior based on transactional data collected from a retail store. The dataset contains records across three tables: **Customers**, **Transactions**, and **Product Categories**. The goal of this analysis is to generate valuable business insights, including transaction trends, customer demographics, product category performance, and more.

This project aims to help retail stores optimize their operations and enhance their decision-making process by understanding patterns in sales, returns, and customer demographics.

## Business Context

A retail store wants to understand customer behavior using their **Point of Sale (POS)** data, which includes:

- **Customer Data**: Customer demographics like age, gender, and location.
- **Transaction Data**: Details of each purchase, including item details, store type, transaction date, and amount spent.
- **Product Category Data**: Information about product categories and their subcategories.

The analysis of this data can help businesses make better-informed decisions about inventory management, marketing strategies, and customer engagement.

## Objectives

The project will focus on answering key business questions, such as:

1. How to track the number of transactions with returns.
2. Understanding customer demographics such as age, gender, and location.
3. Analyzing product category performance, including sales, returns, and top-selling subcategories.
4. Exploring transactional trends, including the frequency of transactions and the most popular sales channels.
5. Identifying high-value customers and customer segments.
6. Generating insights on sales trends, product categories, and revenue from various store types.

## Data Tables

The dataset contains three main tables:

1. **Customer**: Customer demographics such as customer ID, name, age, gender, city, etc.
2. **Transactions**: Transaction details, including transaction ID, customer ID, product category, amount spent, transaction date, store type, and whether the transaction is a return.
3. **Product Category**: Product category and subcategory details for items sold.

## Key SQL Sample Queries

The project includes various SQL queries designed to answer specific business questions based on the dataset. Below are some of the SQL queries that are part of the analysis:

### Data Preparation & Understanding

1. **Total number of rows in each table:**

    ```sql
    SELECT 
        (SELECT COUNT(*) FROM Customer) AS Customer_Count,
        (SELECT COUNT(*) FROM Transactions) AS Transaction_Count,
        (SELECT COUNT(*) FROM ProductCategory) AS ProductCategory_Count;
    ```

2. **Total number of transactions with returns:**

    ```sql
    SELECT COUNT(*) 
    FROM Transactions
    WHERE return_flag = 'Y';
    ```
    
### Data Analysis

1. **Most frequently used transaction channel:**

    ```sql
    SELECT TOP 1 channel, COUNT(*) AS transaction_count
    FROM Transactions
    GROUP BY channel
    ORDER BY transaction_count DESC;
    ```

2. **Count of Male and Female customers:**

    ```sql
    SELECT gender, COUNT(*) AS customer_count
    FROM Customer
    GROUP BY gender;
    ```
    
## Conclusion

This project highlights the powerful insights that can be derived from retail transactional data. By analyzing patterns in customer demographics, sales, and product categories, businesses can gain a deeper understanding of customer behavior and improve decision-making processes. Through the use of SQL queries, this project demonstrates how to extract relevant information and make data-driven conclusions.

## Setup & Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/SehgalArpit/Retail-Customer-Behavior-Analysis.git
    ```

2. Set up a local SQL Server or any other database system.

3. Import the dataset into your database.

4. Run the SQL queries to perform the analysis and obtain insights.

---

Feel free to contribute or reach out if you have any questions.

