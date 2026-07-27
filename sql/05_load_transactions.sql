/*
=========================================================
Project : Banking Fraud Risk Analytics
File    : 05_load_transactions.sql
Author  : Himanshu Ranjan
Purpose : Load validated transaction records from the
          staging table into the production transactions
          table while converting staging data into the
          required production data types.
=========================================================
*/



INSERT INTO dbo.transactions
(
    [timestamp],
    from_bank,
    sender_account,
    to_bank,
    receiver_account,
    amount_received,
    receiving_currency,
    amount_paid,
    payment_currency,
    payment_format,
    is_laundering,
    transaction_hour,
    day_of_week,
    transaction_month,
    amount_category,
    same_bank_transfer,
    same_currency_transaction
)
SELECT
    [timestamp],
    from_bank,
    sender_account,
    to_bank,
    receiver_account,
    amount_received,
    receiving_currency,
    amount_paid,
    payment_currency,
    payment_format,
    is_laundering,
    transaction_hour,
    day_of_week,
    transaction_month,
    amount_category,
    CASE
        WHEN same_bank_transfer = 'True' THEN 1
        ELSE 0
    END,
    CASE
        WHEN same_currency_transaction = 'True' THEN 1
        ELSE 0
    END
FROM dbo.transactions_stage;

select *from transactions