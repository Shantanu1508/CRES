


CREATE PROCEDURE [dbo].[usp_AddUpdateEmailNotification] 
(
@XMLEmailNotificationFile XML
)
AS
BEGIN
	SET NOCOUNT ON;

	create table #EmailNotificationFile 
	(
		ID int identity,
	    EmailNotificationID int,
		EmailId  nvarchar(256),
		ModuleId int,
		[Status] int
	)
	
	INSERT INTO #EmailNotificationFile
	--Remove space and newline from the input 
	select 
	REPLACE(REPLACE(RTRIM(LTRIM(Pers.value('(EmailNotificationID)[1]', 'varchar(256)'))), CHAR(13), ''), CHAR(10), '') as EmailNotificationID,
	REPLACE(REPLACE(RTRIM(LTRIM(Pers.value('(Email)[1]', 'varchar(256)'))), CHAR(13), ''), CHAR(10), '') as EmailId,  
	REPLACE(REPLACE(RTRIM(LTRIM(Pers.value('(ModuleId)[1]', 'varchar(256)'))), CHAR(13), ''), CHAR(10), '') as ModuleId,
	REPLACE(REPLACE(RTRIM(LTRIM(Pers.value('(StatusID)[1]', 'varchar(256)'))), CHAR(13), ''), CHAR(10), '') as [Status]
	FROM @XMLEmailNotificationFile.nodes('/ArrayOfUserDataContract/UserDataContract') as t(Pers);
	

IF EXISTS(SELECT enf.EmailId from #EmailNotificationFile enf 
          left join [App].[User] u  ON enf.EmailId = u.Email
		  WHERE enf.EmailId = u.Email AND enf.EmailNotificationID <> 0) 
BEGIN
	
INSERT INTO [APP].[EmailNotification]
	 (EmailId,ModuleId,[Status])
SELECT [EmailId],[ModuleId],1 FROM  #EmailNotificationFile
WHERE [EmailNotificationID] = 0

UPDATE [APP].[EmailNotification]
SET [APP].[EmailNotification].EmailId = tblemailnotification.EmailId,
	[APP].[EmailNotification].ModuleId = tblemailnotification.ModuleId,
	[APP].[EmailNotification].Status = '1'
from(
	Select EmailNotificationID, EmailID,ModuleId FROM #EmailNotificationFile
	) as tblemailnotification
WHERE [APP].[EmailNotification].[EmailNotificationID] = tblemailnotification.EmailNotificationID AND tblemailnotification.[EmailNotificationID] IS NOT NULL
			  
IF OBJECT_ID('tempdb..#EmailNotificationFile') IS NOT NULL 
DROP TABLE #EmailNotificationFile;
END

END
