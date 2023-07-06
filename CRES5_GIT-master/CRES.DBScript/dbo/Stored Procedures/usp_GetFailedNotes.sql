
CREATE PROCEDURE [dbo].[usp_GetFailedNotes] --'Deal','C10F3372-0FC2-4861-A9F5-148F1F80804F'
	
	@Title nvarchar(256),
	@UserID UNIQUEIDENTIFIER
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
 SET FMTONLY OFF;
 
 Select
		ff.Module,
		'00000000-0000-0000-0000-000000000000' as CREID,
		'' as CREName,
		ff.[CreatedDate] as RequestTime,	
		ff.ObjectID 	,
		CAST(ff.[Message_stacktrace] AS NVARCHAR(MAX)) as [ErrorMessage] ,
		CAST(ff.[Message] AS NVARCHAR(MAX)) as [Message] 
		 from App.Logger ff 
		where ff.Severity ='Error' and ff.Module  =@title
		and ff.[CreatedDate] >= cast(dateadd(day, -1, getdate()) as date)
		order by ff.[CreatedDate]  desc
END


