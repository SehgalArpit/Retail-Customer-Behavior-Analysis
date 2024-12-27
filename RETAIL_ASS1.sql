CREATE DATABASE RETAIL_ANA
USE RETAIL_ANA

SELECT TOP 1 * FROM Customer
SELECT TOP 1 * FROM prod_cat_info
SELECT TOP 1 * FROM Transactions

--DATA PREPERATION AND UNDERSTANDING
--Q1.
--BEGIN
   SELECT COUNT(*) AS TOTAL_ROWS FROM Customer
   SELECT COUNT(*) AS TOTAL_ROWS FROM prod_cat_info
   SELECT COUNT(*) AS TOTAL_ROWS FROM Transactions
--END

--Q2.
--BEGIN
SELECT COUNT(*) AS TRANSACTION_HAVE_RETURN FROM Transactions
WHERE Rate < 0
--END

--Q3.
--BEGIN
SELECT A.*,CONVERT(VARCHAR(10),DOB,105) AS FORMATED_DTE FROM Customer AS A
SELECT A.*,CONVERT(VARCHAR(10),tran_date,105) AS FORMATED_DTE FROM Transactions AS A
--END

--Q4.
--BEGIN
SELECT *,DATEDIFF(DAY,T.MIN_DTE,T.MAX_DTE) AS DAYS_RANGE,
         DATEDIFF(MONTH,T.MIN_DTE,T.MAX_DTE) AS MONTH_RANGE,
		 DATEDIFF(YEAR,T.MIN_DTE,T.MAX_DTE) AS YEAR_RANGE FROM
  (SELECT MAX(A.tran_date) AS MAX_DTE,MIN(A.tran_date) AS MIN_DTE FROM Transactions AS A) AS T
--END

--Q5.
--BEGIN
  SELECT A.prod_cat FROM prod_cat_info AS A
  WHERE A.prod_subcat = 'DIY'
--END

--DATA ANALYSIS
--Q1.
--BEGIN
SELECT TOP 1 A.Store_type FROM Transactions AS A
GROUP BY A.Store_type
ORDER BY COUNT(*) DESC 
--END

--Q2.
--BEGIN
SELECT A.Gender,COUNT(A.GENDER) AS CNT_ FROM CUSTOMER AS A
WHERE A.Gender IN ('M','F')
GROUP BY A.Gender
--END

--Q3.
--BEGIN
SELECT TOP 1 A.city_code,COUNT(*) AS CUST_CNT FROM Customer AS A
GROUP BY A.city_code
ORDER BY COUNT(*) DESC
--END

--Q4.
--BEGIN
SELECT COUNT(*) AS CNT_OF_SUBCAT_UNDER_BOOKS FROM prod_cat_info AS A
WHERE A.prod_cat = 'Books'
--END

--Q5.
--BEGIN
SELECT  A.prod_cat,SUM(B.Qty) AS CNT_PRODUCT FROM prod_cat_info AS A
INNER JOIN Transactions AS B
ON A.prod_cat_code = B.prod_cat_code
  AND A.prod_sub_cat_code = B.prod_subcat_code
GROUP BY A.prod_cat
ORDER BY SUM(B.Qty) DESC
--END

--Q6.
--BEGIN
SELECT B.prod_cat,SUM(A.total_amt) AS TOTAL_REVENUE FROM Transactions AS A
INNER JOIN prod_cat_info AS B
ON A.prod_cat_code = B.prod_cat_code
   AND
   A.prod_subcat_code = B.prod_sub_cat_code
WHERE B.prod_cat IN ('Electronics','Books')
GROUP BY B.prod_cat
--END


--Q7.
--BEGIN
SELECT COUNT(*) AS CUST_CNT FROM (
SELECT A.customer_Id,COUNT(B.transaction_id) AS TRANS_CNT FROM Customer AS A 
INNER JOIN Transactions AS B
ON A.customer_Id = B.cust_id
WHERE B.Rate > 0 
GROUP BY A.customer_Id
HAVING COUNT(B.transaction_id) < 10) AS T
--END

--Q8.
--BEGIN
SELECT SUM(A.total_amt) AS COMBINED_TOTAL_REVENUE FROM Transactions AS A
INNER JOIN prod_cat_info AS B
ON A.prod_cat_code = B.prod_cat_code AND A.prod_subcat_code = B.prod_sub_cat_code
 WHERE A.Store_type = 'Flagship store' AND B.prod_cat IN ('Electronics','Clothing')
 --END

 --Q9.
 --BEGIN
 SELECT C.prod_subcat,SUM(B.total_amt) AS TOTAL_REVENUE FROM Customer AS A
 INNER JOIN Transactions AS B
 ON A.customer_Id = B.cust_id
 INNER JOIN prod_cat_info AS C
 ON B.prod_cat_code = C.prod_cat_code
 AND B.prod_subcat_code = C.prod_sub_cat_code
 WHERE A.Gender = 'M' AND C.prod_cat = 'Electronics'
 GROUP BY C.prod_subcat
 --END

 --Q10.
 --BEGIN
 --TOP 5 SALES PERCENTAGE
 SELECT M.prod_subcat_code,M.SALES_PERC,H.RETURN_PERC FROM
 (SELECT TOP 5 * FROM
 (SELECT T.prod_subcat_code,(T.SALES/(SELECT SUM(B.total_amt) FROM Transactions AS B WHERE B.total_amt > 0))*100 SALES_PERC FROM 
 (SELECT A.prod_subcat_code,SUM(A.total_amt) AS SALES FROM Transactions AS A
 WHERE A.total_amt > 0
 GROUP BY A.prod_subcat_code) AS T) AS G
 ORDER BY G.SALES_PERC DESC) AS M
 INNER JOIN
 --TOP 5 RETURN PERCENTAGE
 (SELECT TOP 5 * FROM
 (SELECT T.prod_subcat_code,(T.RETURN_/(SELECT ABS(SUM(B.total_amt)) FROM Transactions AS B WHERE B.total_amt < 0))*100 RETURN_PERC FROM 
 (SELECT A.prod_subcat_code,ABS(SUM(A.total_amt)) AS RETURN_ FROM Transactions AS A
 WHERE A.total_amt < 0
 GROUP BY A.prod_subcat_code) AS T) AS G
 ORDER BY G.RETURN_PERC DESC) AS H
 ON M.prod_subcat_code = H.prod_subcat_code
 --END

--Q11.
--BEGIN
SELECT T.customer_Id,SUM(T.total_amt) AS TOTAL_REVENUE FROM
(SELECT * FROM Customer AS A
INNER JOIN Transactions AS B
ON A.customer_Id = B.cust_id
WHERE (DATEPART(YEAR,B.tran_date) - DATEPART(YEAR,A.DOB)) BETWEEN 25 AND 35) AS T 
INNER JOIN
(SELECT * FROM Transactions AS C
WHERE C.tran_date BETWEEN (SELECT DATEADD(DAY,-30,MAX(B.tran_date)) FROM Transactions AS B) AND (SELECT MAX(B.tran_date) FROM Transactions AS B)) AS F
ON T.cust_id = F.cust_id
GROUP BY T.customer_Id
--END

--Q12.
--BEGIN
SELECT TOP 1 C.prod_cat_code,ABS(SUM(C.Qty)) AS RETURNS_QTY FROM Transactions AS C
WHERE C.Qty < 0 
   AND C.tran_date BETWEEN (SELECT DATEADD(MONTH,-3,MAX(B.tran_date)) FROM Transactions AS B) AND (SELECT MAX(A.tran_date) FROM Transactions AS A)
GROUP BY C.prod_cat_code
ORDER BY ABS(SUM(C.Qty)) DESC
--END

--Q13.
--BEGIN
SELECT TOP 1 A.Store_type,SUM(A.Qty) AS QUANTITY_SOLD,SUM(A.total_amt) AS SALES_AMT FROM Transactions AS A
GROUP BY A.Store_type
ORDER BY SUM(A.Qty) DESC
--END

--Q14.
--BEGIN
SELECT A.prod_cat_code,AVG(A.total_amt) AS AVG_REVENUE FROM Transactions AS A
GROUP BY A.prod_cat_code
HAVING AVG(A.total_amt) > (SELECT AVG(A.total_amt) AS OVERALL_AVG_REVENUE FROM Transactions AS A)
ORDER BY AVG(A.total_amt) DESC
--END

--Q15.
--BEGIN
SELECT A.prod_subcat_code,SUM(A.total_amt) AS TOT,AVG(A.total_amt) AS AV FROM Transactions AS A
 INNER JOIN (SELECT TOP 5 A.prod_cat_code from Transactions AS A 
             GROUP BY A.prod_cat_code
			 ORDER BY SUM(A.Qty) DESC ) AS B
			 ON A.prod_cat_code = B.prod_cat_code
			 GROUP BY A.prod_subcat_code
--END


      
	 