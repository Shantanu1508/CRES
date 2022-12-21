
CREATE PROCEDURE [APP].[usp_WriteLog]
(
    @EventID int, 
    @Priority int, 
    @Severity nvarchar(32), 
    @Title nvarchar(256), 
    @Timestamp datetime,
    @MachineName nvarchar(32), 
    @AppDomainName nvarchar(512),
    @ProcessID nvarchar(256),
    @ProcessName nvarchar(512),
    @ThreadName nvarchar(512),
    @Win32ThreadId nvarchar(128),
    @Message nvarchar(1500),
    @FormattedMessage ntext,
    @LogID int OUTPUT
)
AS 

    INSERT INTO [APP].[Log] (
        EventID,
        Priority,
        Severity,
        Title,
        [Timestamp],
        MachineName,
        AppDomainName,
        ProcessID,
        ProcessName,
        ThreadName,
        Win32ThreadId,
        Message,
        FormattedMessage
    )
    VALUES (
        @EventID, 
        @Priority, 
        @Severity, 
        @Title, 
        @Timestamp,
        @MachineName, 
        @AppDomainName,
        @ProcessID,
        @ProcessName,
        @ThreadName,
        @Win32ThreadId,
        @Message,
        @FormattedMessage)

SET @LogID = @@IDENTITY
RETURN @LogID
