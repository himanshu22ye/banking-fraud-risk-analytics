/*
=========================================================
Project : Banking Fraud Risk Analytics
File    : 09_create_views.sql
Author  : Himanshu Ranjan
Purpose : Create reporting views for Power BI dashboards.
=========================================================
*/

USE FraudRiskAnalytics;
GO

/*=========================================================
View 1 : Dashboard Summary
Purpose:
Provide overall business KPIs for the Executive Dashboard.

Power BI Uses:
• KPI Cards
• Executive Overview
=========================================================*/

CREATE VIEW dbo.vw_dashboard_summary
AS

SELECT

    COUNT(*) AS total_transactions,

    SUM(amount_paid) AS total_transaction_amount,

    AVG(amount_paid) AS average_transaction_amount,

    SUM(
        CASE
            WHEN is_laundering = 1 THEN 1
            ELSE 0
        END
    ) AS fraud_transactions,

    SUM(
        CASE
            WHEN is_laundering = 0 THEN 1
            ELSE 0
        END
    ) AS genuine_transactions,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN is_laundering = 1 THEN 1
                ELSE 0
            END
        )
        / COUNT(*),
        2
    ) AS fraud_rate_percent

FROM dbo.transactions;
GO


/*=========================================================
View 2 : Bank Performance
Purpose:
Provide transaction statistics for each bank.

Power BI Uses:
• Top Banks
• Fraud by Bank
• Fraud Rate by Bank
• Transaction Volume by Bank
=========================================================*/

CREATE OR ALTER VIEW dbo.vw_bank_performance
AS

SELECT

    t.from_bank AS bank_id,
    b.bank_name,

    COUNT(*) AS total_transactions,

    SUM(t.amount_paid) AS total_transaction_amount,

    AVG(t.amount_paid) AS average_transaction_amount,

    SUM(
        CASE
            WHEN t.is_laundering = 1 THEN 1
            ELSE 0
        END
    ) AS fraud_transactions,

    SUM(
        CASE
            WHEN t.is_laundering = 0 THEN 1
            ELSE 0
        END
    ) AS genuine_transactions,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN t.is_laundering = 1 THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS fraud_rate_percent

FROM dbo.transactions AS t

INNER JOIN
(
    SELECT DISTINCT
        bank_id,
        bank_name
    FROM dbo.accounts
) AS b
ON t.from_bank = b.bank_id

GROUP BY
    t.from_bank,
    b.bank_name;
GO

/*=========================================================
View 3 : Account Performance
Purpose:
Provide transaction statistics for each sender account.

Power BI Uses:
• Top Sender Accounts
• Suspicious Accounts
• Fraud Rate by Account
• Account Investigation
=========================================================*/

CREATE OR ALTER VIEW dbo.vw_account_performance
AS

SELECT

    t.sender_account,

    a.bank_id,

    a.bank_name,

    a.entity_id,

    a.entity_name,

    COUNT(*) AS total_transactions,

    SUM(t.amount_paid) AS total_transaction_amount,

    AVG(t.amount_paid) AS average_transaction_amount,

    SUM(
        CASE
            WHEN t.is_laundering = 1 THEN 1
            ELSE 0
        END
    ) AS fraud_transactions,

    SUM(
        CASE
            WHEN t.is_laundering = 0 THEN 1
            ELSE 0
        END
    ) AS genuine_transactions,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN t.is_laundering = 1 THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS fraud_rate_percent

FROM dbo.transactions AS t

INNER JOIN dbo.accounts AS a
    ON t.sender_account = a.account_number

GROUP BY

    t.sender_account,
    a.bank_id,
    a.bank_name,
    a.entity_id,
    a.entity_name;
GO


/*=========================================================
View 4 : Currency Performance
Purpose:
Provide transaction and fraud statistics by payment currency.

Power BI Uses:
• Transaction Volume by Currency
• Fraud Rate by Currency
• Total Amount by Currency
• Currency Distribution
=========================================================*/

CREATE OR ALTER VIEW dbo.vw_currency_performance
AS

SELECT

    payment_currency,

    COUNT(*) AS total_transactions,

    SUM(amount_paid) AS total_transaction_amount,

    AVG(amount_paid) AS average_transaction_amount,

    SUM(
        CASE
            WHEN is_laundering = 1 THEN 1
            ELSE 0
        END
    ) AS fraud_transactions,

    SUM(
        CASE
            WHEN is_laundering = 0 THEN 1
            ELSE 0
        END
    ) AS genuine_transactions,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN is_laundering = 1 THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS fraud_rate_percent

FROM dbo.transactions

GROUP BY payment_currency;
GO

SELECT *
FROM dbo.vw_currency_performance
ORDER BY total_transaction_amount DESC;
GO


/*=========================================================
View 5 : Payment Performance
Purpose:
Provide transaction and fraud statistics by payment method.

Power BI Uses:
• Transactions by Payment Method
• Fraud Rate by Payment Method
• Total Amount by Payment Method
• Average Transaction Amount
=========================================================*/

CREATE OR ALTER VIEW dbo.vw_payment_performance
AS

SELECT

    payment_format,

    COUNT(*) AS total_transactions,

    SUM(amount_paid) AS total_transaction_amount,

    AVG(amount_paid) AS average_transaction_amount,

    SUM(
        CASE
            WHEN is_laundering = 1 THEN 1
            ELSE 0
        END
    ) AS fraud_transactions,

    SUM(
        CASE
            WHEN is_laundering = 0 THEN 1
            ELSE 0
        END
    ) AS genuine_transactions,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN is_laundering = 1 THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS fraud_rate_percent

FROM dbo.transactions

GROUP BY payment_format;
GO


/*=========================================================
View 6 : Time Performance
Purpose:
Provide transaction and fraud statistics by
hour, day of week, and month.

Power BI Uses:
• Fraud by Hour
• Fraud by Day
• Monthly Trends
• Peak Transaction Hours
• Time-based Fraud Analysis
=========================================================*/

CREATE OR ALTER VIEW dbo.vw_time_performance
AS

SELECT

    transaction_month,

    day_of_week,

    transaction_hour,

    COUNT(*) AS total_transactions,

    SUM(amount_paid) AS total_transaction_amount,

    AVG(amount_paid) AS average_transaction_amount,

    SUM(
        CASE
            WHEN is_laundering = 1 THEN 1
            ELSE 0
        END
    ) AS fraud_transactions,

    SUM(
        CASE
            WHEN is_laundering = 0 THEN 1
            ELSE 0
        END
    ) AS genuine_transactions,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN is_laundering = 1 THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS fraud_rate_percent

FROM dbo.transactions

GROUP BY

    transaction_month,
    day_of_week,
    transaction_hour;
GO


/*=========================================================
View 7 : High Risk Transactions
Purpose:
Provide detailed information for all
transactions flagged as laundering.

Power BI Uses:
• Fraud Investigation
• Drill-through Reports
• High Risk Transaction Table
=========================================================*/

CREATE OR ALTER VIEW dbo.vw_high_risk_transactions
AS

SELECT

    t.transaction_id,

    t.[timestamp],

    t.from_bank,
    sender.bank_name AS sender_bank_name,

    t.sender_account,
    sender.entity_id AS sender_entity_id,
    sender.entity_name AS sender_entity_name,

    t.to_bank,
    receiver.bank_name AS receiver_bank_name,

    t.receiver_account,
    receiver.entity_id AS receiver_entity_id,
    receiver.entity_name AS receiver_entity_name,

    t.amount_paid,
    t.payment_currency,

    t.amount_received,
    t.receiving_currency,

    t.payment_format,

    t.transaction_hour,
    t.day_of_week,
    t.transaction_month,

    t.same_bank_transfer,
    t.same_currency_transaction,

    t.is_laundering

FROM dbo.transactions AS t

LEFT JOIN dbo.accounts AS sender
    ON t.sender_account = sender.account_number

LEFT JOIN dbo.accounts AS receiver
    ON t.receiver_account = receiver.account_number

WHERE t.is_laundering = 1;
GO
/*=========================================================
View 8 : Monthly Trends
Purpose:
Provide monthly transaction and fraud trends.

Power BI Uses:
• Monthly Transaction Trend
• Monthly Fraud Trend
• Executive Dashboard
• Trend Analysis
=========================================================*/

CREATE OR ALTER VIEW dbo.vw_monthly_trends
AS

SELECT

    YEAR([timestamp]) AS transaction_year,

    MONTH([timestamp]) AS month_number,

    transaction_month,

    COUNT(*) AS total_transactions,

    SUM(amount_paid) AS total_transaction_amount,

    AVG(amount_paid) AS average_transaction_amount,

    SUM(
        CASE
            WHEN is_laundering = 1 THEN 1
            ELSE 0
        END
    ) AS fraud_transactions,

    SUM(
        CASE
            WHEN is_laundering = 0 THEN 1
            ELSE 0
        END
    ) AS genuine_transactions,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN is_laundering = 1 THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS fraud_rate_percent

FROM dbo.transactions

GROUP BY

    YEAR([timestamp]),
    MONTH([timestamp]),
    transaction_month;
GO