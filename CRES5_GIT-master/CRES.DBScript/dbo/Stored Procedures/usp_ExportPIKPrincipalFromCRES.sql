-- Procedure

CREATE PROCEDURE [dbo].[usp_ExportPIKPrincipalFromCRES] 
(
	@NoteID nvarchar(256),
	@CreatedBy nvarchar(256),
	@UpdatedBy nvarchar(256)
)
AS
BEGIN

Declare @Cutoffdate date = CAST((select [Value] from app.appconfig where [key] = 'CutOffDate_BackshopExport') as date)


Declare @NoteIDGuid UNIQUEIDENTIFIER
SET @NoteIDGuid = (Select noteid from cre.note n inner join core.Account acc on n.Account_AccountID = acc.AccountID where crenoteid = @NoteID and IsDeleted <> 1)

Delete from [Core].[Exceptions] where ExceptionsAutoID in (Select ExceptionsAutoID from [Core].[Exceptions] where FieldName = 'M61 and Backshop PIK Principal Funding mismatch' and ObjectTypeID = 182 and ObjectID = @NoteIDGuid )


IF((Select top 1 [Value] from app.AppConfig where [Key] = 'AllowBackshopPIKPrincipal') = 1)
BEGIN

	DECLARE @UserName nvarchar(256);			

	IF EXISTS(SELECT 1 WHERE @UpdatedBy LIKE REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]'))
	BEGIN
		SET @UserName = (Select [Login] from [App].[User] where UserID = @UpdatedBy)
	END
	ELSE
	BEGIN
		SET @UserName =  @UpdatedBy
	END

	--Capture the most recent active funding schedule in out_FutureFunding table with status='ReadyForExport'
	DELETE FROM [IO].[out_PIKPrincipalFunding] where [CRENoteID] = @NoteId 

		


	INSERT INTO [IO].[out_PIKPrincipalFunding]
			([CRENoteID]
			,[FundingDate]
			,[FundingAmount]
			,[Comments]
			,[FundingPurpose]
			,[AuditUserName]
			,[ExportTimeStamp]
			,[Status]
			,[Applied]
			,[WireConfirm]
			,[DrawFundingId]
			,WF_CurrentStatus
			,PIKReasonCode)	
		Select 
		n.[CRENoteID]
		,tr.[Date]
		,(tr.[Amount] * -1) as [Amount]
		,tr.Comment as [Comments]		
		
		,(CASE [type]		
		WHEN 'PIKPrincipalFunding' THEN 'PIKNC'	
		WHEN 'PIKPrincipalPaid' THEN 'PIKPP'	
		END
		)as [FundingPurpose]

		,@UserName as [AuditUserName]
		,GETDATE() as [ExportTimeStamp]
		,'ReadyForExport' as [Status]
		,1 as [Applied]
		,1 as [WireConfirm]
		,null as [DrawFundingId]
		,null as WF_CurrentStatus
		,NULLIF((CASE tr.FeeName		
		WHEN 'Contractual' THEN 'CON'	
		WHEN 'COVID' THEN 'COV'	
		WHEN 'Other' THEN 'OTH'	
		ELSE tr.FeeName
		END
		),'')as FeeName
		

		from cre.transactionentry tr
		Inner Join core.account acc on acc.accountid = tr.accountid
		inner join cre.note n on n.account_accountid = acc.AccountID
		where tr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
		and [type] in ('PIKPrincipalFunding','PIKPrincipalPaid') 
		and n.crenoteid = @NoteId
		and acc.AccountTypeID = 1
		and tr.[Date] > @Cutoffdate

		--============Export FF to Backshop==============
		IF EXISTS (SELECT routine_name  FROM   information_schema.routines WHERE  routine_name = 'sp_NoteFundingsDeleteByNoteIdPIK')
		BEGIN	
			IF ((SELECT ISNUMERIC(@NoteId)) = 1) --Because backshop's procedure take crenoteid as int
			BEGIN
					exec [usp_ExportPIKPrincipalToBackshop] @NoteId,@UserName					
					
					exec [usp_VerifyPIKPrincipalM61andBackshop] @NoteId,@UserName,@CreatedBy
			END
		END
		---==============================================





END




END


