-- Description: Monitoring queries

-- Failed Jobs
SELECT j.name, h.run_status, h.message
FROM msdb.dbo.sysjobs j
JOIN msdb.dbo.sysjobhistory h 
ON j.job_id = h.job_id
WHERE h.run_status = 0;

-- Running Jobs
SELECT j.name, a.start_execution_date
FROM msdb.dbo.sysjobactivity a
JOIN msdb.dbo.sysjobs j 
ON a.job_id = j.job_id
WHERE a.stop_execution_date IS NULL;

-- Long Running Jobs
SELECT j.name,
DATEDIFF(MINUTE, a.start_execution_date, GETDATE()) AS TimeRunning
FROM msdb.dbo.sysjobactivity a
JOIN msdb.dbo.sysjobs j 
ON a.job_id = j.job_id
WHERE a.stop_execution_date IS NULL
AND DATEDIFF(MINUTE, a.start_execution_date, GETDATE()) > 1;
