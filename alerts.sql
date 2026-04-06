-- Description: Alert configuration

CREATE TABLE JobAlertConfig
(
    JobName VARCHAR(100),
    FailureThreshold INT
);

INSERT INTO JobAlertConfig
VALUES
('DBA_Full_Backup_Job', 1),
('DBA_Failing_Job', 5);

CREATE TABLE AlertLog
(
    AlertID INT IDENTITY PRIMARY KEY,
    AlertTime DATETIME DEFAULT GETDATE(),
    AlertType VARCHAR(50),
    JobName VARCHAR(100),
    Details VARCHAR(500)
);
