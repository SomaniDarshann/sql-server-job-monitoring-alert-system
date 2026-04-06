-- Description: SQL Server Agent Job for full backup

EXEC sp_add_job @job_name = 'DBA_Full_Backup_Job';

EXEC sp_add_jobstep
    @job_name = 'DBA_Full_Backup_Job',
    @step_name = 'Full Backup',
    @subsystem = 'TSQL',
    @command = '
    DECLARE @Path VARCHAR(200) = ''F:\SQLBackups\'';
    DECLARE @FileName VARCHAR(200);
    DECLARE @FullPath VARCHAR(500);

    SET @FileName = ''DBA_Monitoring_Lab_'' 
    + CONVERT(VARCHAR(8), GETDATE(), 112) + ''.bak'';

    SET @FullPath = @Path + @FileName;

    BACKUP DATABASE DBA_Monitoring_Lab
    TO DISK = @FullPath
    WITH INIT;
    ';

EXEC sp_add_schedule
    @schedule_name = 'Daily_3AM_Backup',
    @freq_type = 4,
    @freq_interval = 1,
    @active_start_time = 030000;

EXEC sp_attach_schedule
    @job_name = 'DBA_Full_Backup_Job',
    @schedule_name = 'Daily_3AM_Backup';

EXEC sp_add_jobserver @job_name = 'DBA_Full_Backup_Job';
