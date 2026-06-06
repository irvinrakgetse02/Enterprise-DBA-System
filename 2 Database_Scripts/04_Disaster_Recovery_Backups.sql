--======= PART D: LOGICAL RECOVERY & REPOSITORY DISASTER STRATEGIES ========

-- ENFORCING DATA PROTECTION BACKUPS
-- Full Backup Policy Execution
BACKUP DATABASE AdventureWorks2022
TO DISK = 'C:\SQLBackups\AdventureWorks2022_Full.bak'
WITH INIT, FORMAT;

-- Differential Backup Policy Execution
BACKUP DATABASE AdventureWorks2022
TO DISK = 'C:\SQLBackups\AdventureWorks2022_DIFF.bak'
WITH DIFFERENTIAL;

-- Transactional Log Ingestion Guard
BACKUP LOG AdventureWorks2022
TO DISK = 'C:\SQLBackups\AdventureWorks2022_LOG.trn';
GO


-- FULL LOGICAL ARCHITECTURE RESTORATION SEQUENCE
-- Note: Run these verification chains during localized data mitigation failures

/* RESTORE DATABASE AdventureWorks2022
FROM DISK = 'C:\SQLBackups\AdventureWorks2022_Full.bak'
WITH NORECOVERY;

RESTORE DATABASE AdventureWorks2022
FROM DISK = 'C:\SQLBackups\AdventureWorks2022_DIFF.bak'
WITH NORECOVERY;

RESTORE LOG AdventureWorks2022
FROM DISK = 'C:\SQLBackups\AdventureWorks2022_LOG.trn'
WITH RECOVERY;
*/
