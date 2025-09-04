-- Procedure

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
		CASE WHEN (ff.Module='Deal' OR ff.Module='ExportFutureFunding') Then DL.CREDealID 
			ELSE CASE WHEN (ff.Module='Calculator') THEN N.CRENoteID ELSE '00000000-0000-0000-0000-000000000000' END 
		END as 'CREID',
		CASE WHEN (ff.Module='Deal' OR ff.Module='ExportFutureFunding') Then DL.DealName 
			ELSE  CASE WHEN (ff.Module='Calculator') THEN Acc.[Name] ELSE '' END 
		END as 'CREName',
		ff.[CreatedDate] as RequestTime,	
		ff.ObjectID 	,
		CAST(ff.[Message_stacktrace] AS NVARCHAR(MAX)) as [ErrorMessage] ,
		CAST(ff.[Message] AS NVARCHAR(MAX)) as [Message] 
		 from App.Logger ff 
		 LEFT JOIN [CRE].[Deal] DL ON ff.ObjectID = CAST(DL.DealID as NVARCHAR(256))
		 LEFT JOIN [CRE].[Note] N ON CAST(N.NoteID as NVARCHAR(256))=ff.ObjectID
		 LEFT JOIN [CORE].[Account] Acc ON N.Account_AccountID = CAST(Acc.AccountID as NVARCHAR(256))
		where ff.Severity ='Error' and ff.Module  =@title
		and ff.[CreatedDate] >= cast(dateadd(day, -1, getdate()) as date)
		order by ff.[CreatedDate]  desc
END


