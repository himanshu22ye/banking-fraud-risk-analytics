/*
=========================================================
Project : Banking Fraud Risk Analytics
File    : 03_create_staging_tables.sql
Author  : Himanshu Ranjan
Purpose : Create staging tables used for bulk importing
          cleaned and feature-engineered datasets before
          loading them into production tables.
=========================================================
*/


USE FraudRiskAnalytics;

CREATE TABLE dbo.transactions_stage
(
    [timestamp] DATETIME NOT NULL,
    from_bank INT NOT NULL,
    sender_account VARCHAR(20) NOT NULL,
    to_bank INT NOT NULL,
    receiver_account VARCHAR(20) NOT NULL,
    amount_received DECIMAL(28,8) NOT NULL,
    receiving_currency VARCHAR(50) NOT NULL,
    amount_paid DECIMAL(28,8) NOT NULL,
    payment_currency VARCHAR(50) NOT NULL,
    payment_format VARCHAR(50) NOT NULL,
    is_laundering BIT NOT NULL,
    transaction_hour TINYINT NOT NULL,
    day_of_week VARCHAR(20) NOT NULL,
    transaction_month VARCHAR(20) NOT NULL,
    amount_category VARCHAR(20) NOT NULL,
    same_bank_transfer VARCHAR(5),
same_currency_transaction VARCHAR(5)
);


BULK INSERT dbo.transactions_stage
FROM 'D:\fraud_risk_analytics\data\processed\feature_engineered_transactions.csv'
WITH
(
    FORMAT='CSV',
    FIRSTROW=2,
    FIELDQUOTE='"',
    TABLOCK
);

