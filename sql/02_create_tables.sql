/*
=========================================================
Project : Banking Fraud Risk Analytics
File    : 02_create_tables.sql
Author  : Himanshu Ranjan
Purpose : Create accounts and transactions tables
=========================================================
*/

USE FraudRiskAnalytics;


----------------------------------------------------------
-- Accounts Table
----------------------------------------------------------

CREATE TABLE accounts (
    bank_name VARCHAR(100) NOT NULL,
    bank_id INT NOT NULL,
    account_number VARCHAR(20) PRIMARY KEY,
    entity_id VARCHAR(50) NOT NULL,
    entity_name VARCHAR(255) NOT NULL
);


----------------------------------------------------------
-- Transactions Table
----------------------------------------------------------
CREATE TABLE dbo.transactions
(
    transaction_id BIGINT IDENTITY(1,1) PRIMARY KEY,

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

    same_bank_transfer BIT NOT NULL,
    same_currency_transaction BIT NOT NULL
);

