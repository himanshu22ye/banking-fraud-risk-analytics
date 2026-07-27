/*
=========================================================
Project : Banking Fraud Risk Analytics
File    : 04_bulk_import.sql
Author  : Himanshu Ranjan
Purpose : Bulk import cleaned account data from CSV
          files into SQL Server tables.
=========================================================
*/


select *from dbo.accounts


BULK INSERT dbo.accounts
FROM 'D:\fraud_risk_analytics\data\processed\cleaned_accounts.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    TABLOCK
);

select *from accounts