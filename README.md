# Enterprise Database Administration & Automated Monitoring System

## 👥 Project Team
* Developed as a collaborative group project for our university database module (**SCOA031**).

## 🔍 Project Overview
This project is a full hands-on implementation of Database Administration (DBA) practices using **Microsoft SQL Server** and the **AdventureWorks2022** sample database. 

Instead of just running basic queries, we built a secure, automated production environment. The system handles everything a real-world DBA would look after: automating messy business tasks, setting up strict user permissions, tracking unauthorized changes with database triggers, configuring email alerts for critical events, and handling disaster recovery backups.



## 📁 Repository Structure
We’ve organized our files into numbered folders so they are easy to navigate:
* **`1 Project Description/`** – The original project guidelines and requirements.
* **`2 Database_Scripts/`** – All our working T-SQL scripts broken down by task (Stored procedures, Roles, Triggers, Backups).
* **`3 System_Documentation/`** – Our final team technical manual and project report (PDF format).



## 🛠️ What We Built (Technical Breakdown)

### 1. Database Automation (Stored Procedures)
We wrote modular stored procedures to handle regular business actions safely. To make sure bad inputs wouldn't crash the database or mess up data integrity, we wrapped our scripts in strict error handling (`BEGIN TRY...CATCH`) and transaction boundaries (`BEGIN TRANSACTION` / `COMMIT`).
* **Data Management:** Built procedures to safely add new customers, update pricing details, and automatically archive inactive accounts that haven't ordered in over a year.
* **Reports:** Wrote optimized aggregation reports to pull top-selling products, calculate monthly revenue trends, and track employee sales performance.

### 2. User Security & Permissions (RBAC)
To prevent unauthorized users from viewing or changing sensitive company files, we applied the rule of least privilege. 
* We created three distinct roles: `SalesRole`, `HRRole`, and `DBA_Role`.
* We assigned explicit access boundaries using `GRANT` and `DENY` commands (e.g., stopping the sales team from viewing HR employee salaries and vice versa).
* We created specific test logins (`SalesUser`, `HRUser`, `DBAUser`) to test and prove that the security rules work perfectly under different permissions.

### 3. Performance & Query Tuning
To speed up slow database lookups, we ran performance tests using execution statistics.
* **Indexes:** Created targeted non-clustered indexes on heavily searched columns like `OrderQty` to cut down on resource scanning times.
* **Query Optimization:** Refactored poorly written queries. For example, we replaced slow functions like `YEAR(OrderDate) = 2014` with a clean date-range check (`OrderDate >= '2014-01-01' AND ...`) so SQL Server could use the indexes properly instead of doing a full table scan.

### 4. Relational Data Auditing & Automated Email Alerts
* **Audit Logs:** We created an active history tracker. By deploying `AFTER INSERT, UPDATE, DELETE` triggers on core tables (`Customer` and `Product`), any data modification is instantly logged into a master `AuditTable` along with the username and timestamp.
* **Email System:** We configured SQL Server's Database Mail via SMTP. We then hooked this up to custom alert triggers so that if someone alters sensitive info or changes a product's price by more than 10%, an automated emergency alert email is instantly sent to the DBA's inbox.

### 5. Maintenance Plans & Backup Recovery Strategies
Data safety is a massive priority, so we scripted an end-to-end backup and recovery strategy to handle system crashes:
* **Backups:** Wrote automated maintenance scripts to take Full database backups (`.bak`), Differential backups (`_DIFF.bak`), and Transaction Log backups (`_LOG.trn`).
* **Restoration:** Put together a complete recovery sequence step-by-step using the `NORECOVERY` and `RECOVERY` flags to restore data smoothly during emergencies.
* **Index Upkeep:** Built an advanced maintenance stored procedure using a fast-forward cursor loop. It automatically scans index fragmentation levels across the whole system and decides whether to lightly reorganize or fully rebuild them depending on how messy they are.
