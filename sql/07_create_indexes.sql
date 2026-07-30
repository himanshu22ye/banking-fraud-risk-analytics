/*
=========================================================
Project : Banking Fraud Risk Analytics
File    : 07_create_indexes.sql
Author  : Himanshu Ranjan
Purpose : Create indexes to improve query performance
          for fraud detection, business analytics,
          reporting, and Power BI dashboards.
=========================================================
*/

USE FraudRiskAnalytics;
GO

/*=========================================================
1. Index: Sender Account
Purpose:
Speed up searches for all outgoing transactions
from a specific account.
=========================================================*/

CREATE NONCLUSTERED INDEX IX_transactions_sender_account
ON dbo.transactions(sender_account);
GO


/*=========================================================
2. Index: Receiver Account
Purpose:
Speed up searches for all incoming transactions
to a specific account.
=========================================================*/

CREATE NONCLUSTERED INDEX IX_transactions_receiver_account
ON dbo.transactions(receiver_account);
GO


/*=========================================================
3. Index: Transaction Timestamp
Purpose:
Optimize date and time based filtering for
daily, monthly, and yearly transaction analysis.
=========================================================*/

CREATE NONCLUSTERED INDEX IX_transactions_timestamp
ON dbo.transactions([timestamp]);
GO


/*=========================================================
4. Index: Laundering Flag
Purpose:
Quickly retrieve suspicious (laundering)
transactions for fraud investigations.
=========================================================*/

CREATE NONCLUSTERED INDEX IX_transactions_is_laundering
ON dbo.transactions(is_laundering);
GO


/*=========================================================
5. Index: Payment Currency
Purpose:
Improve performance of currency-wise
transaction analysis.
=========================================================*/

CREATE NONCLUSTERED INDEX IX_transactions_payment_currency
ON dbo.transactions(payment_currency);
GO


/*=========================================================
6. Index: Receiving Currency
Purpose:
Optimize reporting and comparison of
receiving currencies.
=========================================================*/

CREATE NONCLUSTERED INDEX IX_transactions_receiving_currency
ON dbo.transactions(receiving_currency);
GO


/*=========================================================
7. Index: From Bank
Purpose:
Speed up queries that analyze transactions
originating from specific banks.
=========================================================*/

CREATE NONCLUSTERED INDEX IX_transactions_from_bank
ON dbo.transactions(from_bank);
GO


/*=========================================================
8. Index: To Bank
Purpose:
Improve lookup performance for transactions
received by specific banks.
=========================================================*/

CREATE NONCLUSTERED INDEX IX_transactions_to_bank
ON dbo.transactions(to_bank);
GO


/*=========================================================
9. Composite Index: Bank + Timestamp
Purpose:
Optimize bank-wise transaction analysis
over a specific time period.

Example:
WHERE from_bank = 12345
AND timestamp >= '2022-01-01'
=========================================================*/

CREATE NONCLUSTERED INDEX IX_transactions_bank_timestamp
ON dbo.transactions
(
    from_bank,
    [timestamp]
);
GO


/*=========================================================
10. Verify Created Indexes
Purpose:
Display all indexes created on the
transactions table.
=========================================================*/

SELECT
    i.name AS index_name,
    i.type_desc AS index_type
FROM sys.indexes AS i
WHERE i.object_id = OBJECT_ID('dbo.transactions')
  AND i.index_id > 0
ORDER BY i.name;