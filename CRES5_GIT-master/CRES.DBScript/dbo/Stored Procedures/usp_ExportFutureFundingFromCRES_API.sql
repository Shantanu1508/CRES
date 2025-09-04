--Drop  PROCEDURE [dbo].[usp_ExportFutureFundingFromCRES_API] 

CREATE PROCEDURE [dbo].[usp_ExportFutureFundingFromCRES_API] 
(
	@notefunding [TableTypeFundingSchedule] READONLY,
	@CreatedBy nvarchar(256),
	@UpdatedBy nvarchar(256),
	@SavingFromDeal bit = 0
)
AS
BEGIN


BEGIN TRY
	
	Declare @Cutoffdate date = CAST((select [Value] from app.appconfig where [key] = 'CutOffDate_BackshopExport') as date)

	
	Declare @DealID UNIQUEIDENTIFIER;
	Declare @CREDealID nvarchar(256);

	Select @DealID = n.dealid ,@CREDealID = d.CREDealID
	from cre.note n
	inner join cre.deal d on d.dealid = n.dealid
	where n.noteid in (Select top 1 NoteId from @notefunding where NoteID is not null)

	
	Delete from [Core].[Exceptions] where ExceptionsAutoID in (Select ExceptionsAutoID from [Core].[Exceptions] where FieldName = 'M61 and Backshop funding mismatch' and ObjectTypeID = 182 and ObjectID in (Select DISTINCT NoteId from @notefunding where NoteID is not null) )


	IF((Select top 1 [Value] from app.AppConfig where [Key] = 'AllowBackshopFF') = 1)
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
	
		DELETE FROM [IO].[out_FutureFunding] where DealID = @DealID
	

		INSERT INTO [IO].[out_FutureFunding]
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
				,DealFundingRowno
				,DealFundingID
				,[GeneratedBy]
				,[GeneratedByText]
				,DealID
				,IsDeleted
				,FF_BlankJson
				,AdjustmentType
				,FundingAdjustmentTypeCd_F)
		Select 
		n.CRENoteID
		,fs.[Date] as FundingDate
		,fs.Value as FundingAmount
		,fs.Comments
		--,(Select Top 1 df.Comment from [CRE].dealfunding df where df.dealid = d.dealid and df.[Date] = fs.[Date] and df.PurposeID = fs.PurposeID) as [Comments] --df.Comment as [Comments]
		,(CASE LPurposeID.name
		WHEN 'Property Release' THEN 'PROPREL'
		WHEN 'Payoff/Paydown' THEN 'PAYOFF'
		WHEN 'Additional Collateral Purchase' THEN 'ADDCOLLPUR'
		WHEN 'Capital Expenditure' THEN 'CAPEXPEN'
		WHEN 'Debt Service / Opex' THEN 'DSOPEX'
		WHEN 'TI/LC' THEN 'TILCDRAW'
		WHEN 'Other' THEN 'OTHER'
		WHEN 'Amortization' THEN 'AMORT'
		--WHEN 'Capitalized Interest (Complex)' THEN 'CAPINTC'
		--WHEN 'Capitalized Interest (Non-Complex)' THEN 'CAPINTN'
		WHEN 'OpEx' THEN 'OPEX'
		WHEN 'Force Funding' THEN 'FORCEFUND'
		WHEN 'Capitalized Interest' THEN 'CAPINTC'
		WHEN 'Full Payoff' THEN 'FULLPAY'
		WHEN 'Note Transfer' THEN 'NOTETRAN'	
		WHEN 'Paydown' THEN 'PAYDOWN'	
		WHEN 'Principal Writeoff' THEN 'PWRITEOFF'	
		--WHEN 'Net Property Income/Loss' THEN 'NETINCLOSS'	
		WHEN 'Equity Distribution' THEN 'EQUITYDIST'		
		END
		)as [FundingPurpose]
		,@UserName as [AuditUserName]
		,GETDATE() as [ExportTimeStamp]
		,'ReadyForExport' as [Status]
		,1 as [Applied]
		,fs.[Applied] as [WireConfirm]
		,fs.DrawFundingId
		,fs.WF_CurrentStatus
		,DealFundingRowno
		,DealFundingID
		,fs.[GeneratedBy]
		,LGeneratedBy.name as GeneratedByText
		,@DealID
		,0 as IsDeleted
		,0 as FF_BlankJson
		,LAdjustmentType.name as AdjustmentType
		,LAdjustmentType.Value as FundingAdjustmentTypeCd_F

		--,(CASE LAdjustmentType.name
		--WHEN 'Non-Commitment Adjustment (PA)' THEN 'NONCOMITADJ'
		--WHEN 'Revolver' THEN 'REVOLVER'
		--ELSE LAdjustmentType.name END) as FundingAdjustmentTypeCd_F

		from [CORE].FundingSchedule fs
		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
		INNER JOIN (						
				Select 
					(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
					MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
					from [CORE].[Event] eve
					INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
					INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
					where EventTypeID = 10 and eve.StatusID = 1				
					and n.NoteID in (Select DISTINCT NoteId from @notefunding where NoteID is not null)				
					GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID
			) sEvent
		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.StatusID = 1

		left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		LEFT JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID
		LEFT JOIN [CORE].[Lookup] LGeneratedBy ON LGeneratedBy.LookupID = fs.GeneratedBy
		left JOIN [CORE].[Lookup] LAdjustmentType ON LAdjustmentType.LookupID = fs.AdjustmentType 
		where sEvent.StatusID = e.StatusID 
		and fs.[Date] > @Cutoffdate
		and ISNUMERIC(n.CRENoteID) = 1
		and LPurposeID.Name <> 'Net Property Income/Loss'

		UNION ALL

		Select Distinct 
		n.CRENoteID
		,null as FundingDate
		,null as FundingAmount
		,null as Comments
		,null as  [FundingPurpose]
		,null as [AuditUserName]
		,null as [ExportTimeStamp]
		,'ReadyForExport' as [Status]
		,null as [Applied]
		,null as [WireConfirm]
		,null as DrawFundingId
		,null as WF_CurrentStatus
		,null as DealFundingRowno
		,null as DealFundingID
		,null as [GeneratedBy]
		,null as GeneratedByText
		,@DealID
		,1 as IsDeleted
		,0 as FF_BlankJson
		,null as AdjustmentType
		,null as FundingAdjustmentTypeCd_F
		from cre.note n
		Inner join core.account acc on acc.accountid = n.account_accountid
		Inner join cre.deal d on d.dealid = n.dealid
		where acc.isdeleted <> 1
		and d.dealid = @DealID
		and n.noteid not in ( 
			Select Distinct n.noteid From [CORE].FundingSchedule fs
			INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
			where e.StatusID = 1 and acc.IsDeleted = 0
			and n.dealid = @DealID
		)
		and ISNUMERIC(n.CRENoteID) = 1

		UNION ALL

		---Note has only paydown
		Select Distinct 
		n.CRENoteID
		,null as FundingDate
		,null as FundingAmount
		,null as Comments
		,null as  [FundingPurpose]
		,null as [AuditUserName]
		,null as [ExportTimeStamp]
		,'ReadyForExport' as [Status]
		,null as [Applied]
		,null as [WireConfirm]
		,null as DrawFundingId
		,null as WF_CurrentStatus
		,null as DealFundingRowno
		,null as DealFundingID
		,null as [GeneratedBy]
		,null as GeneratedByText
		,@DealID
		,0 as IsDeleted
		,1 as FF_BlankJson
		,null as AdjustmentType
		,null as FundingAdjustmentTypeCd_F
		from cre.note n
		Inner join core.account acc on acc.accountid = n.account_accountid
		Inner join cre.deal d on d.dealid = n.dealid
		where acc.isdeleted <> 1
		and d.dealid = @DealID
		and n.noteid not in ( 
			Select Distinct n.noteid from [CORE].FundingSchedule fs
			INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
			INNER JOIN 
			(						
				Select 	(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
				MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
				from [CORE].[Event] eve
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
				where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')
				and n.dealid = @DealID  and acc.IsDeleted = 0
				and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
				GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID
			) sEvent
			ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
			left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID
			left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID 
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
			where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0
			and n.DealID = @DealID
			and fs.PurposeID <> 631
		
			and fs.[GeneratedBy] = 747  ----Auto Spread
			and fs.Applied <> 1
		)
		and ISNUMERIC(n.CRENoteID) = 1

		-------======set IsProjectedPaydown = 1 where paydowns having no comment======		
		Update [IO].[out_FutureFunding] set IsProjectedPaydown = 1
		where [CRENoteID] in (Select DISTINCT n.crenoteid from @notefunding nf inner join cre.note n on n.noteid = nf.noteid where nf.NoteID is not null)	
		and FundingPurpose = 'PAYDOWN'
		---and NULLIF(Comments,'') is NULL
		and [GeneratedBy] = 747  ----Auto Spread
		and [WireConfirm] <> 1



		Delete From [IO].[out_FutureFunding] Where IsProjectedPaydown = 1 
		and DealID = @DealID
		and CRENoteID in (
			Select n.CRENoteID
			from cre.deal d
			Inner join cre.note n on n.dealid = d.dealid
			inner join cre.LoanStatus ls on ls.LoanStatusID = d.LoanStatusID
			where d.IsDeleted <> 1
			and d.DealID = @DealID
			and ls.LoanStatusCd = 'E'
		)
		------===================================================================

		---======Delete duplicate data from landing=======	
		IF EXISTS(Select DealFundingID from cre.dealfunding where dealid = @DealID)
		BEGIN	
			Delete FROM [IO].[out_FutureFunding] where [CRENoteID] in (
			Select DISTINCT n.crenoteid from @notefunding nf 
			inner join cre.note n on n.noteid = nf.noteid 
			where nf.NoteID is not null)	
			and DealFundingID not in (Select DealFundingID from cre.dealfunding where dealid = @DealID )
		END
		---=========================================


		---Update status by checking noteid in backshop
		DECLARE @tblNote_BS TABLE (NoteID int,ShardName nvarchar(max))
		DECLARE @query nvarchar(256) = N'Select NoteID from [acore].[vw_AcctNote] where ControlID = '''+@CREDealID+''' '
		
		INSERT INTO @tblNote_BS(NoteID,ShardName)
		EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceDataFF', @stmt = @query

		
		IF EXISTS(Select NoteID from @tblNote_BS)
		BEGIN
			UPDATE [IO].[out_FutureFunding] set [Status] = 'Not Exists in [acore].[vw_AcctNote]' where DealID = @DealID and [AuditUserName] = @userName
			and crenoteid not in (Select NoteID from @tblNote_BS)
		END
		ELSE
		BEGIN
			UPDATE [IO].[out_FutureFunding] set [Status] = 'Not Exists in [acore].[vw_AcctNote]' where DealID = @DealID and [AuditUserName] = @userName
		END



	END


END TRY
BEGIN CATCH

	DECLARE @ErrorMessage NVARCHAR(4000);
	DECLARE @ErrorSeverity INT;
	DECLARE @ErrorState INT;

	Select @ErrorMessage = 'SQL error ' + ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
	
	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	
END CATCH


END  
  
  