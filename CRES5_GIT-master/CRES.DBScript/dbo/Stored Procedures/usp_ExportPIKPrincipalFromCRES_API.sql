-- Procedure
-- Procedure
CREATE PROCEDURE [dbo].[usp_ExportPIKPrincipalFromCRES_API] 
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

Declare @DealID UNIQUEIDENTIFIER;

Select @DealID = n.dealid
from cre.note n
inner join cre.deal d on d.dealid = n.dealid
where n.noteid  = @NoteIDGuid


Delete from [Core].[Exceptions] where ExceptionsAutoID in (Select ExceptionsAutoID from [Core].[Exceptions] where FieldName = 'M61 and Backshop PIK Principal Funding mismatch' and ObjectTypeID = 182 and ObjectID = @NoteIDGuid )


IF((Select top 1 [Value] from app.AppConfig where [Key] = 'AllowBackshopPIKPrincipal') = 1)
BEGIN

IF ((SELECT ISNUMERIC(@NoteId)) = 1) --Because backshop's procedure take crenoteid as int
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

	IF EXISTS(Select top 1 tr.Accountid from cre.transactionentry tr
				Inner Join core.account acc on acc.accountid = tr.accountid
				Inner join cre.note n on n.account_accountid = acc.AccountID
				where tr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
				and [type] in ('PIKPrincipalFunding','PIKPrincipalPaid') 
				and n.crenoteid = @NoteId
				and tr.[Date] > @Cutoffdate
				) 
	BEGIN

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
				,PIKReasonCode
				,DealID
				,IsDeleted)	
			Select Distinct
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
			,(CASE WHEN tr.[Date] <= Cast(getdate() as date) THEN 1 else 0 end) as [WireConfirm]
			,null as [DrawFundingId]
			,null as WF_CurrentStatus
			,NULLIF((CASE tr.FeeName		
			WHEN 'Contractual' THEN 'CON'	
			WHEN 'COVID' THEN 'COV'	
			WHEN 'Deferral Interest Payments' THEN 'DEF'			
			WHEN 'Other' THEN 'OTH'	
			ELSE tr.FeeName
			END
			),'')as FeeName
			,@DealID
			,0 as IsDeleted
			from cre.transactionentry tr
			Inner Join core.account acc on acc.accountid = tr.accountid
			Inner join cre.note n on n.account_accountid = acc.AccountID
			where tr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
			and [type] in ('PIKPrincipalFunding','PIKPrincipalPaid') 
			and n.crenoteid = @NoteId
			and tr.[Date] > @Cutoffdate
		END
		ELSE
		BEGIN
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
				,PIKReasonCode
				,DealID
				,IsDeleted)
			Select 
			@NoteId as [CRENoteID]
			,null as [Date]
			,null as [Amount]
			,null as [Comments]
			,'PIKPP' as [FundingPurpose]
			,null as [AuditUserName]
			,null as [ExportTimeStamp]
			,'ReadyForExport' as  [Status]
			,null as [Applied]
			,null as [WireConfirm]
			,null as [DrawFundingId]
			,null as WF_CurrentStatus
			,null as FeeName
			,@DealID
			,1 as IsDeleted
		END



		----Balloon
		--IF EXISTS(Select top 1 tr.Accountid from cre.transactionentry tr
		--		Inner Join core.account acc on acc.accountid = tr.accountid
		--		Inner join cre.note n on n.account_accountid = acc.AccountID
		--		where tr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
		--		and [type] in ('Balloon') 
		--		and n.crenoteid = @NoteId
		--		and tr.[Date] > @Cutoffdate
		--		) 
		--BEGIN

		--	INSERT INTO [IO].[out_PIKPrincipalFunding]
		--	([CRENoteID]
		--	,[FundingDate]
		--	,[FundingAmount]
		--	,[Comments]
		--	,[FundingPurpose]
		--	,[AuditUserName]
		--	,[ExportTimeStamp]
		--	,[Status]
		--	,[Applied]
		--	,[WireConfirm]
		--	,[DrawFundingId]
		--	,WF_CurrentStatus
		--	,PIKReasonCode
		--	,DealID
		--	,IsDeleted)	
		--	Select Distinct
		--	n.[CRENoteID]
		--	,tr.[Date]
		--	,(tr.[Amount]) as [Amount]
		--	,tr.Comment as [Comments]	
		--	,'Balloon' as [FundingPurpose]
		--	,@UserName as [AuditUserName]
		--	,GETDATE() as [ExportTimeStamp]
		--	,'ReadyForExport' as [Status]
		--	,1 as [Applied]
		--	,1 as [WireConfirm]
		--	,null as [DrawFundingId]
		--	,null as WF_CurrentStatus
		--	,NULL as FeeName
		--	,@DealID
		--	,0 as IsDeleted
		--	from cre.transactionentry tr
		--	Inner Join core.account acc on acc.accountid = tr.accountid
		--	Inner join cre.note n on n.account_accountid = acc.AccountID
		--	where tr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
		--	and [type] in ('Balloon') 
		--	and n.crenoteid = @NoteId
		--	and tr.[Date] > @Cutoffdate
		--END
		--ELSE
		--BEGIN
		--	INSERT INTO [IO].[out_PIKPrincipalFunding]
		--		([CRENoteID]
		--		,[FundingDate]
		--		,[FundingAmount]
		--		,[Comments]
		--		,[FundingPurpose]
		--		,[AuditUserName]
		--		,[ExportTimeStamp]
		--		,[Status]
		--		,[Applied]
		--		,[WireConfirm]
		--		,[DrawFundingId]
		--		,WF_CurrentStatus
		--		,PIKReasonCode
		--		,DealID
		--		,IsDeleted)
		--	Select 
		--	@NoteId as [CRENoteID]
		--	,null as [Date]
		--	,null as [Amount]
		--	,null as [Comments]
		--	,'Balloon' as [FundingPurpose]
		--	,null as [AuditUserName]
		--	,null as [ExportTimeStamp]
		--	,'ReadyForExport' as  [Status]
		--	,null as [Applied]
		--	,null as [WireConfirm]
		--	,null as [DrawFundingId]
		--	,null as WF_CurrentStatus
		--	,null as FeeName
		--	,@DealID
		--	,1 as IsDeleted
		--END



		---Checking noteid exists in backshop or note
		DECLARE @query nvarchar(256) = N'Select COUNT(noteid) from [acore].[vw_AcctNote] where Noteid = '''+@NoteId+''''  
		DECLARE @NoteCount TABLE (Cnt int,ShardName nvarchar(max))  
		INSERT INTO @NoteCount (Cnt,ShardName)  
		EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceDataFF', @stmt = @query    
  
		IF ((Select cnt from @NoteCount) = 0) 
		BEGIN  
			UPDATE [IO].[out_PIKPrincipalFunding] set [Status] = 'Not Exists in [acore].[vw_AcctNote]' where [CRENoteID] = @NoteID and [AuditUserName] = @userName
		END

	END

END


END
GO

