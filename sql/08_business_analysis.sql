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

/*=========================================================
18. Accounts with Highest Number of Laundering Transactions
Business Question:
Which sender accounts are involved in the most
laundering transactions?
=========================================================*/

SELECT TOP 10
    sender_account,
    COUNT(*) AS laundering_transactions
FROM dbo.transactions
WHERE is_laundering = 1
GROUP BY sender_account
ORDER BY laundering_transactions DESC;

/*=========================================================
19. Accounts with Highest Transaction Value
Business Question:
Which sender accounts have transferred the highest
total amount (grouped by payment currency)?
=========================================================*/

SELECT TOP 10
    sender_account,
    payment_currency,
    SUM(amount_paid) AS total_amount
FROM dbo.transactions
GROUP BY sender_account, payment_currency
ORDER BY total_amount DESC;

/*=========================================================
20. Fraud Rate by Sender Account
Business Question:
Which sender accounts have the highest percentage
of laundering transactions?
=========================================================*/

SELECT TOP 10
    sender_account,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN is_laundering = 1 THEN 1 ELSE 0 END) AS laundering_transactions,
    ROUND(
        100.0 * SUM(CASE WHEN is_laundering = 1 THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS fraud_rate_percent
FROM dbo.transactions
GROUP BY sender_account
HAVING COUNT(*) >= 10
ORDER BY fraud_rate_percent DESC, total_transactions DESC;

/*=========================================================
SECTION 5 : Currency Analysis
=========================================================*/


/*=========================================================
21. Transaction Count by Payment Currency
Business Question:
Which payment currencies are used most frequently?
=========================================================*/

SELECT
    payment_currency,
    COUNT(*) AS transaction_count
FROM dbo.transactions
GROUP BY payment_currency
ORDER BY transaction_count DESC;

/*=========================================================
22. Total Transaction Amount by Payment Currency
Business Question:
What is the total transaction value for each
payment currency?
=========================================================*/

SELECT
    payment_currency,
    SUM(amount_paid) AS total_transaction_amount
FROM dbo.transactions
GROUP BY payment_currency
ORDER BY total_transaction_amount DESC;

/*=========================================================
23. Average Transaction Amount by Payment Currency
Business Question:
What is the average transaction amount for each
payment currency?
=========================================================*/

SELECT
    payment_currency,
    AVG(amount_paid) AS average_transaction_amount
FROM dbo.transactions
GROUP BY payment_currency
ORDER BY average_transaction_amount DESC;

/*=========================================================
24. Fraud Transactions by Payment Currency
Business Question:
Which payment currencies are involved in the
highest number of laundering transactions?
=========================================================*/

SELECT
    payment_currency,
    COUNT(*) AS laundering_transactions
FROM dbo.transactions
WHERE is_laundering = 1
GROUP BY payment_currency
ORDER BY laundering_transactions DESC;

/*=========================================================
25. Fraud Rate by Payment Currency
Business Question:
Which payment currencies have the highest fraud
rate?
=========================================================*/

SELECT
    payment_currency,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN is_laundering = 1 THEN 1 ELSE 0 END)
        AS laundering_transactions,
    ROUND(
        100.0 *
        SUM(CASE WHEN is_laundering = 1 THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS fraud_rate_percent
FROM dbo.transactions
GROUP BY payment_currency
ORDER BY fraud_rate_percent DESC;

/*=========================================================
SECTION 6 : Payment Method Analysis
=========================================================*/

/*=========================================================
26. Transaction Count by Payment Method
Business Question:
Which payment methods are used most frequently?
=========================================================*/

SELECT
    payment_format,
    COUNT(*) AS transaction_count
FROM dbo.transactions
GROUP BY payment_format
ORDER BY transaction_count DESC;

/*=========================================================
27. Total Transaction Amount by Payment Method
Business Question:
What is the total transaction value for each
payment method?
=========================================================*/

SELECT
    payment_format,
    payment_currency,
    SUM(amount_paid) AS total_transaction_amount
FROM dbo.transactions
GROUP BY payment_format, payment_currency
ORDER BY total_transaction_amount DESC;

/*=========================================================
28. Average Transaction Amount by Payment Method
Business Question:
Which payment methods have the highest average
transaction value?
=========================================================*/

SELECT
    payment_format,
    payment_currency,
    AVG(amount_paid) AS average_transaction_amount
FROM dbo.transactions
GROUP BY payment_format, payment_currency
ORDER BY average_transaction_amount DESC;

/*=========================================================
29. Fraud Transactions by Payment Method
Business Question:
Which payment methods are involved in the highest
number of laundering transactions?
=========================================================*/

SELECT
    payment_format,
    COUNT(*) AS laundering_transactions
FROM dbo.transactions
WHERE is_laundering = 1
GROUP BY payment_format
ORDER BY laundering_transactions DESC;

/*=========================================================
30. Fraud Rate by Payment Method
Business Question:
Which payment methods have the highest fraud rate?
=========================================================*/

SELECT
    payment_format,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN is_laundering = 1 THEN 1 ELSE 0 END)
        AS laundering_transactions,
    ROUND(
        100.0 *
        SUM(CASE WHEN is_laundering = 1 THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS fraud_rate_percent
FROM dbo.transactions
GROUP BY payment_format
ORDER BY fraud_rate_percent DESC;

/*=========================================================
SECTION 7 : Time-Based Analysis
=========================================================*/

/*=========================================================
31. Transactions by Hour
Business Question:
At what hour are the most transactions performed?
=========================================================*/

SELECT
    transaction_hour,
    COUNT(*) AS transaction_count
FROM dbo.transactions
GROUP BY transaction_hour
ORDER BY transaction_hour;

/*=========================================================
32. Fraud Transactions by Hour
Business Question:
At what hour do the most laundering transactions occur?
=========================================================*/

SELECT
    transaction_hour,
    COUNT(*) AS laundering_transactions
FROM dbo.transactions
WHERE is_laundering = 1
GROUP BY transaction_hour
ORDER BY laundering_transactions DESC;

/*=========================================================
33. Transactions by Day of Week
Business Question:
Which day has the highest transaction volume?
=========================================================*/

SELECT
    day_of_week,
    COUNT(*) AS transaction_count
FROM dbo.transactions
GROUP BY day_of_week
ORDER BY transaction_count DESC;

/*=========================================================
34. Fraud Transactions by Day of Week
Business Question:
Which day has the highest number of laundering
transactions?
=========================================================*/

SELECT
    day_of_week,
    COUNT(*) AS laundering_transactions
FROM dbo.transactions
WHERE is_laundering = 1
GROUP BY day_of_week
ORDER BY laundering_transactions DESC;

/*=========================================================
35. Transactions by Month
Business Question:
How are transactions distributed across months?
=========================================================*/

SELECT
    transaction_month,
    COUNT(*) AS transaction_count
FROM dbo.transactions
GROUP BY transaction_month
ORDER BY transaction_count DESC;

/*=========================================================
36. Fraud Transactions by Month
Business Question:
Which month recorded the highest number of
laundering transactions?
=========================================================*/

SELECT
    transaction_month,
    COUNT(*) AS laundering_transactions
FROM dbo.transactions
WHERE is_laundering = 1
GROUP BY transaction_month
ORDER BY laundering_transactions DESC;

/*=========================================================
37. Fraud Rate by Hour
Business Question:
Which hour has the highest percentage of
laundering transactions?
=========================================================*/

SELECT
    transaction_hour,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN is_laundering = 1 THEN 1 ELSE 0 END)
        AS laundering_transactions,
    ROUND(
        100.0 *
        SUM(CASE WHEN is_laundering = 1 THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS fraud_rate_percent
FROM dbo.transactions
GROUP BY transaction_hour
ORDER BY fraud_rate_percent DESC;

/*=========================================================
SECTION 8 : Advanced Fraud Analytics
=========================================================*/

/*=========================================================
38. Top 20 Highest Value Transactions
Business Question:
Identify the highest value transactions across
all currencies.
=========================================================*/

SELECT TOP 20
    transaction_id,
    sender_account,
    receiver_account,
    payment_currency,
    amount_paid,
    payment_format,
    is_laundering
FROM dbo.transactions
ORDER BY amount_paid DESC;

/*=========================================================
39. High-Value Laundering Transactions
Business Question:
Identify the largest laundering transactions.
=========================================================*/

SELECT TOP 20
    transaction_id,
    sender_account,
    receiver_account,
    payment_currency,
    amount_paid,
    payment_format
FROM dbo.transactions
WHERE is_laundering = 1
ORDER BY amount_paid DESC;

/*=========================================================
40. Same Bank vs Cross Bank Transactions
Business Question:
Compare same-bank and cross-bank transactions.
=========================================================*/

SELECT
    CASE
        WHEN same_bank_transfer = 1
            THEN 'Same Bank'
        ELSE 'Cross Bank'
    END AS transfer_type,
    COUNT(*) AS transaction_count
FROM dbo.transactions
GROUP BY same_bank_transfer;

/*=========================================================
41. Fraud by Transfer Type
Business Question:
Which transfer type contains more laundering
transactions?
=========================================================*/

SELECT
    CASE
        WHEN same_bank_transfer = 1
            THEN 'Same Bank'
        ELSE 'Cross Bank'
    END AS transfer_type,
    COUNT(*) AS laundering_transactions
FROM dbo.transactions
WHERE is_laundering = 1
GROUP BY same_bank_transfer;

/*=========================================================
42. Same Currency vs Different Currency Transactions
Business Question:
Compare transactions involving the same currency
and different currencies.
=========================================================*/

SELECT
    CASE
        WHEN same_currency_transaction = 1
            THEN 'Same Currency'
        ELSE 'Different Currency'
    END AS currency_type,
    COUNT(*) AS transaction_count
FROM dbo.transactions
GROUP BY same_currency_transaction;

/*=========================================================
43. Fraud by Currency Type
Business Question:
Compare laundering activity between same-currency
and different-currency transactions.
=========================================================*/

SELECT
    CASE
        WHEN same_currency_transaction = 1
            THEN 'Same Currency'
        ELSE 'Different Currency'
    END AS currency_type,
    COUNT(*) AS laundering_transactions
FROM dbo.transactions
WHERE is_laundering = 1
GROUP BY same_currency_transaction;

/*=========================================================
44. Top Suspicious Sender Accounts
Business Question:
Identify sender accounts involved in the highest
number of laundering transactions.
=========================================================*/

SELECT TOP 20
    sender_account,
    COUNT(*) AS laundering_transactions
FROM dbo.transactions
WHERE is_laundering = 1
GROUP BY sender_account
ORDER BY laundering_transactions DESC;

/*=========================================================
45. Top Suspicious Receiver Accounts
Business Question:
Identify receiver accounts involved in the highest
number of laundering transactions.
=========================================================*/

SELECT TOP 20
    receiver_account,
    COUNT(*) AS laundering_transactions
FROM dbo.transactions
WHERE is_laundering = 1
GROUP BY receiver_account
ORDER BY laundering_transactions DESC;