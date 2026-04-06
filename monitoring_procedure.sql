-- Description: Automated monitoring procedure

CREATE PROCEDURE sp_Monitor_Failed_Jobs
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        j.name AS JobName,
        COUNT(*) AS FailureCount
    INTO #FailedJobs
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobhistory h 
        ON j.job_id = h.job_id
    WHERE h.run_status = 0
    GROUP BY j.name;

    SELECT F.JobName, F.FailureCount
    INTO #FinalJobs
    FROM #FailedJobs F
    JOIN JobAlertConfig C 
        ON F.JobName = C.JobName
    WHERE F.FailureCount >= C.FailureThreshold;

    IF EXISTS (SELECT 1 FROM #FinalJobs)
    BEGIN
        DECLARE @Body VARCHAR(MAX);

        SET @Body = '⚠️ Job Alert:' + CHAR(13) + CHAR(10);

        SELECT @Body = @Body + 
            JobName + ' - Fail Count: ' + CAST(FailureCount AS VARCHAR)
            + CHAR(13) + CHAR(10)
        FROM #FinalJobs;

        EXEC msdb.dbo.sp_send_dbmail
            @profile_name = 'DBA_Mail_Profile',
            @recipients = 'your-email@gmail.com',
            @subject = 'SQL Job Alert',
            @body = @Body;
    END
END;
