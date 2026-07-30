/*
=========================================================
Project : Banking Fraud Risk Analytics
File    : 08_business_analysis.sql
Author  : Himanshu Ranjan
Purpose : Perform business analysis using SQL to identify
          fraud patterns, transaction trends and banking
          insights.
=========================================================
*/

USE FraudRiskAnalytics;

/*=========================================================
SECTION 1 : Transaction Overview
=========================================================*/


/*=========================================================
1. Total Number of Transactions
Business Question:
How many transactions are present in the system?
=========================================================*/

SELECT COUNT(*) AS total_transactions
FROM dbo.transactions;


/*=========================================================
2. Total Transaction Amount
Business Question:
What is the total value of all transactions?
=========================================================*/

SELECT
SUM(amount_paid) AS total_transaction_amount
FROM dbo.transactions;

/*=========================================================
3. Average Transaction Amount
Business Question:
What is the average transaction amount?
=========================================================*/

SELECT
AVG(amount_paid) AS average_transaction_amount
FROM dbo.transactions;

/*=========================================================
4. Largest Transaction
Business Question:
What is the highest transaction amount?
=========================================================*/

SELECT
MAX(amount_paid) AS largest_transaction
FROM dbo.transactions;

/*=========================================================
5. Smallest Transaction
Business Question:
What is the smallest transaction amount?
=========================================================*/

SELECT
MIN(amount_paid) AS smallest_transaction
FROM dbo.transactions;


/*=========================================================
SECTION 2 : Fraud Analysis
=========================================================*/


/*=========================================================
6. Total Laundering Transactions
Business Question:
How many transactions are marked as laundering?
=========================================================*/

SELECT
COUNT(*) AS laundering_transactions
FROM dbo.transactions
WHERE is_laundering = 1;


/*=========================================================
7. Fraud Percentage
Business Question:
What percentage of all transactions are laundering?
=========================================================*/

SELECT
ROUND(
100.0 * SUM(CASE WHEN is_laundering = 1 THEN 1 ELSE 0 END)
/
COUNT(*),2
) AS fraud_percentage
FROM dbo.transactions;

/*=========================================================
8. Fraud vs Genuine Transactions
=========================================================*/

SELECT
is_laundering,
COUNT(*) AS total_transactions
FROM dbo.transactions
GROUP BY is_laundering;

/*=========================================================
9. Total Laundering Amount
=========================================================*/

SELECT
SUM(amount_paid) AS total_laundered_amount
FROM dbo.transactions
WHERE is_laundering = 1;

/*=========================================================
10. Average Laundering Transaction Amount
=========================================================*/

SELECT
AVG(amount_paid) AS average_laundered_amount
FROM dbo.transactions
WHERE is_laundering = 1;

/*=========================================================
SECTION 3 : Bank Analysis
=========================================================*/

/*=========================================================
11. Top 10 Sender Banks by Transaction Count
=========================================================*/

SELECT TOP 10

from_bank,

COUNT(*) AS transaction_count

FROM dbo.transactions

GROUP BY from_bank

ORDER BY transaction_count DESC;

/*=========================================================
12. Top 10 Receiver Banks
=========================================================*/

SELECT TOP 10

to_bank,

COUNT(*) AS transaction_count

FROM dbo.transactions

GROUP BY to_bank

ORDER BY transaction_count DESC;


/*=========================================================
13. Banks with Highest Fraud Transactions
=========================================================*/

SELECT TOP 10

from_bank,

COUNT(*) AS fraud_transactions

FROM dbo.transactions

WHERE is_laundering = 1

GROUP BY from_bank

ORDER BY fraud_transactions DESC;


/*=========================================================
14. Banks with Highest Transaction Value
=========================================================*/

SELECT TOP 10

from_bank,

SUM(amount_paid) AS total_amount

FROM dbo.transactions

GROUP BY from_bank

ORDER BY total_amount DESC;


/*=========================================================
15. Fraud Rate by Bank
=========================================================*/

SELECT

from_bank,

COUNT(*) AS total_transactions,

SUM(CASE WHEN is_laundering=1 THEN 1 ELSE 0 END)
AS fraud_transactions,

ROUND(
100.0 *
SUM(CASE WHEN is_laundering=1 THEN 1 ELSE 0 END)
/COUNT(*),2)
AS fraud_rate_percent

FROM dbo.transactions

GROUP BY from_bank

ORDER BY fraud_rate_percent DESC;

/*=========================================================
SECTION 4 : Account Analysis
=========================================================*/

/*=========================================================
16. Top 10 Sender Accounts
Business Question:
Which accounts initiate the highest number of transactions?
=========================================================*/

SELECT TOP 10
    sender_account,
    COUNT(*) AS transaction_count
FROM dbo.transactions
GROUP BY sender_account
ORDER BY transaction_count DESC;

/*=========================================================
17. Top 10 Receiver Accounts
Business Question:
Which accounts receive the highest number of transactions?
=========================================================*/

SELECT TOP 10
    receiver_account,
    COUNT(*) AS transaction_count
FROM dbo.transactions
GROUP BY receiver_account
ORDER BY transaction_count DESC;