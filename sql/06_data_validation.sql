/*
=========================================================
Project : Banking Fraud Risk Analytics
File    : 06_data_validation.sql
Author  : Himanshu Ranjan
Purpose : Perform data quality validation including
          NULL checks, duplicate detection, record counts
          and business rule verification.
=========================================================
*/


/*=========================================================
  1. Total Record Validation
=========================================================*/

SELECT COUNT(*) AS total_accounts
FROM accounts;

SELECT COUNT(*) AS total_transactions
FROM transactions

/*=========================================================
  2. NULL Value Validation
=========================================================*/

SELECT
SUM(CASE WHEN sender_account IS NULL THEN 1 ELSE 0 END) AS sender_nulls,
SUM(CASE WHEN receiver_account IS NULL THEN 1 ELSE 0 END) AS receiver_nulls,
SUM(CASE WHEN amount_received IS NULL THEN 1 ELSE 0 END) AS amount_received_nulls,
SUM(CASE WHEN amount_paid IS NULL THEN 1 ELSE 0 END) AS amount_paid_nulls
FROM transactions;

/*=========================================================
  3. Duplicate Transaction IDs
=========================================================*/

SELECT
transaction_id,
COUNT(*)
FROM transactions
GROUP BY transaction_id
HAVING COUNT(*) > 1;

/*=========================================================
  4. Laundering distribution
=========================================================*/

SELECT
is_laundering,
COUNT(*) AS total_transactions
FROM transactions
GROUP BY is_laundering;

/*=========================================================
  5. Currency distribution
=========================================================*/

SELECT
payment_currency,
COUNT(*) AS total
FROM transactions
GROUP BY payment_currency
ORDER BY total DESC;

/*=========================================================
  6. Amount Statistics
=========================================================*/

SELECT
MIN(amount_received) AS min_received,
MAX(amount_received) AS max_received,
AVG(amount_received) AS avg_received
FROM transactions;


/*=========================================================
  7. Date Range
=========================================================*/

SELECT
MIN([timestamp]) AS first_transaction,
MAX([timestamp]) AS last_transaction
FROM transactions;

/*=========================================================
  8. Orphan Account Validation
  Verify that every sender account exists in the
  accounts master table.
=========================================================*/

SELECT COUNT(*)
FROM transactions t
LEFT JOIN accounts a
ON t.sender_account = a.account_number
WHERE a.account_number IS NULL;