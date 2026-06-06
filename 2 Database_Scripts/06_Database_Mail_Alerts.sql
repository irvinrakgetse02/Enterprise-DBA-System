--======= PART E (CONTINUED): ASYNCHRONOUS ENGINE ALERT PIPELINES ========

-- Step 1: Enable Database Mail Features
EXEC sp_configure 'show advanced options', 1; RECONFIGURE;
EXEC sp_configure 'Database Mail XPs', 1;    RECONFIGURE;
GO

-- Step 2: Establish Secure Cloud Subsystem Mail Interfaces
-- Replace values below with production service profile settings
EXEC msdb.dbo.sysmail_add_account_sp
    @account_name    = 'SQLAlerts',
    @email_address   = 'placeholder_alert@domain.com',
    @display_name    = 'Enterprise SQL Core Engine Services',
    @mailserver_name = 'smtp.gmail.com',   
    @port            = 587,                
    @enable_ssl      = 1,                  
    @username        = 'placeholder_alert@domain.com',  
    @password        = 'REDACTED_SECURE_TOKEN'; -- Token credentials hidden for security configuration protection
GO

-- Step 3: Link Communication Framework Profiles
EXEC msdb.dbo.sysmail_add_profile_sp @profile_name = 'DBAAlertProfile';

EXEC msdb.dbo.sysmail_add_profileaccount_sp
    @profile_name    = 'DBAAlertProfile',
    @account_name    = 'SQLAlerts',
    @sequence_number = 1;
GO

-- NOTIFICATION THRESHOLD AUTOMATION ALERTS
CREATE TRIGGER trg_Product_PriceChange_Alert
ON Production.Product
AFTER UPDATE
AS
BEGIN
    IF UPDATE(ListPrice)
    BEGIN
        DECLARE @ProductID NVARCHAR(20), @OldPrice MONEY, @NewPrice MONEY, @Body1 NVARCHAR(MAX)

        SELECT TOP 1 @ProductID = CAST(i.ProductID AS NVARCHAR(20)), @OldPrice = d.ListPrice, @NewPrice = i.ListPrice
        FROM inserted i JOIN deleted d ON i.ProductID = d.ProductID

        SET @Body1 = 'System product price modified by ' + SYSTEM_USER + ' | ProductID: ' + @ProductID + ' | Pre-Price: ' + CAST(@OldPrice AS NVARCHAR(20)) + ' | Post-Price: ' + CAST(@NewPrice AS NVARCHAR(20))

        EXEC msdb.dbo.sp_send_dbmail
            @profile_name = 'DBAAlertProfile',
            @recipients   = 'thapelomrk25@gmail.com',
            @subject      = 'ALERT: System Asset Costing Drift Detected',
            @body         = @Body1
    END
END;
GO

CREATE TRIGGER trg_Customer_Delete_Alert
ON Sales.Customer
AFTER DELETE
AS
BEGIN
    DECLARE @CustomerID NVARCHAR(20), @Body2 NVARCHAR(MAX)
    SELECT TOP 1 @CustomerID = CAST(CustomerID AS NVARCHAR(20)) FROM deleted

    SET @Body2 = 'CRITICAL: Structural customer profile purged by ' + SYSTEM_USER + ' | Account Identification: ' + @CustomerID
               
    EXEC msdb.dbo.sp_send_dbmail
        @profile_name = 'DBAAlertProfile',
        @recipients   = 'thapelomrk25@gmail.com',
        @subject      = 'ALERT: Customer Profile Purged',
        @body         = @Body2
END;
GO

CREATE TRIGGER trg_Product_Delete_Alert
ON Production.Product
AFTER DELETE
AS
BEGIN
    DECLARE @ProductID NVARCHAR(20), @Body3 NVARCHAR(MAX)
    SELECT TOP 1 @ProductID = CAST(ProductID AS NVARCHAR(20)) FROM deleted

    SET @Body3 = 'CRITICAL: Inventory profile deleted by ' + SYSTEM_USER + ' | Reference Unit: ' + @ProductID

    EXEC msdb.dbo.sp_send_dbmail
        @profile_name = 'DBAAlertProfile',
        @recipients   = 'thapelomrk25@gmail.com',
        @subject      = 'ALERT: Material Entry Removed',
        @body         = @Body3
END;
GO

-- TRIGGER TO NOTIFY ON CRITICAL PRICE SHIFTS GREATER THAN 10%
CREATE TRIGGER PriceAlert
ON Production.Product
AFTER UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM deleted d JOIN inserted i ON d.ProductID = i.ProductID
        WHERE ABS(i.listprice - d.listprice) > (d.ListPrice * 0.10)
    )
    BEGIN 
        DECLARE @prodid NVARCHAR(20), @Body5 NVARCHAR(MAX)
        SELECT TOP 1 @prodid = CAST(ProductID AS NVARCHAR(20)) FROM inserted

        SET @Body5 = 'WARNING: Price optimization adjustments exceeded a 10% threshold shift by: ' + SYSTEM_USER + ' | Target Reference: ' + @prodid
                   
        EXEC msdb.dbo.sp_send_dbmail
             @profile_name = 'DBAAlertProfile',
             @recipients   = 'thapelomrk25@gmail.com',
             @subject      = 'ALERT: High-Scale Inventory Volatility Detected',
             @body         = @Body5 
    END
END;
GO

CREATE TRIGGER SensitiveData
ON Person.Person
AFTER UPDATE
AS
BEGIN
    DECLARE @businessId NVARCHAR(20), @Body6 NVARCHAR(MAX)
    SELECT TOP 1 @businessId = CAST(BusinessEntityID AS NVARCHAR(20)) FROM inserted

    SET @Body6 = 'CRITICAL LOG: PII or internal entity records modified by: ' + SYSTEM_USER + ' | Identity Reference: ' + @businessId

    EXEC msdb.dbo.sp_send_dbmail
         @profile_name = 'DBAAlertProfile',
         @recipients   = 'thapelomrk25@gmail.com',
         @subject      = 'ALERT: Sensitive Identity Structure Mutation',
         @body         = @Body6
END;
GO
