-- Description: Delete backups older than 7 days

DECLARE @DeleteDate DATETIME;

SET @DeleteDate = DATEADD(DAY, -7, GETDATE());

EXEC master.dbo.xp_delete_file
    0,
    'F:\SQLBackups\',
    'bak',
    @DeleteDate;
