--======= PART E: CHANGE DATA CAPTURE AUDITING SYSTEM ========

CREATE TABLE AuditTable (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    TableName NVARCHAR(100) NOT NULL,
    ActionType NVARCHAR(10) NOT NULL,
    userName NVARCHAR(100) NOT NULL,
    ActionDateTime DATETIME NOT NULL,
    Description NVARCHAR(500) NOT NULL
);
GO

-- CUSTOMER DATA TRANSACTIONS LOGGING AUDITORS
CREATE TRIGGER Customer_Insert_Trigger
ON Sales.Customer
AFTER INSERT
AS 
BEGIN
    INSERT INTO AuditTable (TableName, ActionType, userName, ActionDateTime, Description)
    SELECT 'Sales.Customer', 'insert', SYSTEM_USER, GETDATE(),
           'Record initialized by ' + SYSTEM_USER + ' | CustomerID: ' + CAST(inserted.CustomerID AS VARCHAR) 
    FROM inserted
END;
GO

CREATE TRIGGER Customer_Update_Trigger
ON Sales.Customer
AFTER UPDATE
AS 
BEGIN
    INSERT INTO AuditTable (TableName, ActionType, userName, ActionDateTime, Description)
    SELECT 'Sales.Customer', 'update', SYSTEM_USER, GETDATE(),
           'Record altered by ' + SYSTEM_USER + ' | CustomerID: ' + CAST(inserted.CustomerID AS VARCHAR) 
    FROM inserted
END;
GO

CREATE TRIGGER Customer_Delete_Trigger
ON Sales.Customer
AFTER DELETE
AS 
BEGIN
    INSERT INTO AuditTable (TableName, ActionType, userName, ActionDateTime, Description)
    SELECT 'Sales.Customer', 'delete', SYSTEM_USER, GETDATE(),
           'Record wiped by ' + SYSTEM_USER + ' | CustomerID: ' + CAST(deleted.CustomerID AS VARCHAR) 
    FROM deleted
END;
GO

-- PRODUCTION MATERIAL TRACKING LOGGING AUDITORS
CREATE TRIGGER Product_Insert_Trigger
ON Production.Product
AFTER INSERT
AS 
BEGIN
    INSERT INTO AuditTable (TableName, ActionType, userName, ActionDateTime, Description)
    SELECT 'Production.Product', 'insert', SYSTEM_USER, GETDATE(),
           'Material unit mapped by ' + SYSTEM_USER + ' | ProductID: ' + CAST(inserted.ProductID AS VARCHAR) 
    FROM inserted
END;
GO

CREATE TRIGGER Product_Update_Trigger
ON Production.Product
AFTER UPDATE
AS 
BEGIN
    INSERT INTO AuditTable (TableName, ActionType, userName, ActionDateTime, Description)
    SELECT 'Production.Product', 'update', SYSTEM_USER, GETDATE(),
           'Material configuration altered by ' + SYSTEM_USER + ' | ProductID: ' + CAST(inserted.ProductID AS VARCHAR) 
    FROM inserted
END;
GO

CREATE TRIGGER Product_Delete_Trigger
ON Production.Product
AFTER DELETE
AS 
BEGIN
    INSERT INTO AuditTable (TableName, ActionType, userName, ActionDateTime, Description)
    SELECT 'Production.Product', 'delete', SYSTEM_USER, GETDATE(),
           'Material profile stripped by ' + SYSTEM_USER + ' | ProductID: ' + CAST(deleted.ProductID AS VARCHAR) 
    FROM deleted
END;
GO
