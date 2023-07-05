

--DECLARE @notefunding [TableTypeFundingSchedule]

--INSERT INTO @notefunding(NoteID,Value,Date,PurposeID,AccountId,Applied,DrawFundingId,Comments,[DealFundingRowno],isDeleted,WF_CurrentStatus)
--Select 
--NoteID,
--null as Value,
--null as Date,
--null as PurposeID,
--null as AccountId,
--null as Applied,
--null as DrawFundingId,
--null as Comments,
--null as [DealFundingRowno],
--null as isDeleted,
--null as WF_CurrentStatus
--from cre.note where dealid =  '34015e9a-b0c2-4e89-9e1f-dfa4e1cff84e'

--exec [dbo].[usp_ExportFutureFundingFromCRES] @notefunding,'B0E6697B-3534-4C09-BE0A-04473401AB93','B0E6697B-3534-4C09-BE0A-04473401AB93',0




CREATE PROCEDURE [dbo].[usp_ExportFutureFundingFromCRES] 
(
	@notefunding [TableTypeFundingSchedule] READONLY,
	@CreatedBy nvarchar(256),
	@UpdatedBy nvarchar(256),
	@SavingFromDeal bit = 0
)
AS
BEGIN


BEGIN TRY
--BEGIN TRAN
	
	Declare @DealID UNIQUEIDENTIFIER;
	SET @DealID = (Select dealid from cre.note where noteid in (Select top 1 NoteId from @notefunding where NoteID is not null) )
	


	--Delete from core.Exceptions where ObjectID in (Select DISTINCT NoteId from @notefunding where NoteID is not null) and FieldName = 'M61 and Backshop funding mismatch' and ObjectTypeID = 182
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
		--DELETE FROM [IO].[out_FutureFunding] where [CRENoteID] = @NoteId and [AuditUserName] = @userName

		DELETE FROM [IO].[out_FutureFunding] where [CRENoteID] in (
			Select DISTINCT n.crenoteid
			from @notefunding nf 
			inner join cre.note n on n.noteid = nf.noteid
			where nf.NoteID is not null
		)
	

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
				,[GeneratedByText])
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
		
		where sEvent.StatusID = e.StatusID 
		and fs.[Date] > '12/31/2019' 


		-------======set IsProjectedPaydown = 1 where paydowns having no comment======		
		Update [IO].[out_FutureFunding] set IsProjectedPaydown = 1
		where [CRENoteID] in (Select DISTINCT n.crenoteid from @notefunding nf inner join cre.note n on n.noteid = nf.noteid where nf.NoteID is not null)	
		and FundingPurpose = 'PAYDOWN'
		---and NULLIF(Comments,'') is NULL
		and [GeneratedBy] = 747  ----Auto Spread
		and [WireConfirm] <> 1
		------===================================================================

		
	
		---======Delete duplicate data from landing=======		
		Delete FROM [IO].[out_FutureFunding] where [CRENoteID] in (
			Select DISTINCT n.crenoteid from @notefunding nf 
			inner join cre.note n on n.noteid = nf.noteid 
			where nf.NoteID is not null)	
		and DealFundingID not in (Select DealFundingID from cre.dealfunding where dealid = @DealID )
		--=========================================

		--============Export FF to Backshop==============
		DECLARE @NoteIdFF UNIQUEIDENTIFIER  
		DECLARE @AccountIdFF UNIQUEIDENTIFIER
		DECLARE @CRENoteId nvarchar(256)

		IF CURSOR_STATUS('global','CursorNoteExportFF')>=-1    
		BEGIN    
		DEALLOCATE CursorNoteExportFF    
		END    
 
		DECLARE CursorNoteExportFF CURSOR     
		FOR    
		(    
			--Select DISTINCT NoteId,(SELECT TOP 1 Account_AccountID FROM CRE.Note n inner join Core.Account acc on n.Account_AccountID=acc.AccountID WHERE NoteID = nf.NoteId and acc.IsDeleted=0) AccountId from @notefunding nf where nf.NoteID is not null
			Select DISTINCT nf.noteid,acc.AccountID,n.crenoteid
			from @notefunding nf 
			inner join cre.note n on n.noteid = nf.noteid
			inner join core.Account acc on acc.AccountID = n.Account_AccountID
			where nf.NoteID is not null and acc.IsDeleted <> 1
		)
		OPEN CursorNoteExportFF     
		FETCH NEXT FROM CursorNoteExportFF    
		INTO @NoteIdFF,@AccountIdFF,@CRENoteId
		WHILE @@FETCH_STATUS = 0    
		BEGIN 
			IF EXISTS (SELECT routine_name  FROM   information_schema.routines WHERE  routine_name = 'sp_NoteFundingsDeleteByNoteId')
			BEGIN				

				IF ((SELECT ISNUMERIC(@CRENoteId)) = 1) --Because backshop's procedure take crenoteid as int
				BEGIN
						exec [usp_ExportFutureFundingToBackshop] @CRENoteId,@UserName					
						exec [usp_VerifyFutureFundingM61andBackshop] @CRENoteId,@UserName,@CreatedBy
							
						--Verify Paydowns
						exec [usp_VerifyFutureFundingM61andBackshop_PayDown] @CRENoteId,@UserName,@CreatedBy
							
				END
			END
		FETCH NEXT FROM CursorNoteExportFF    
		INTO @NoteIdFF,@AccountIdFF,@CRENoteId
		END  
		---==============================================


	END


--COMMIT TRAN
END TRY
BEGIN CATCH

	DECLARE @ErrorMessage NVARCHAR(4000);
	DECLARE @ErrorSeverity INT;
	DECLARE @ErrorState INT;

	Select @ErrorMessage = 'SQL error ' + ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();

	

	--IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION;

	-- Use RAISERROR inside the CATCH block to return error
	-- information about the original error that caused
	-- execution to jump to the CATCH block.

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	  
	  ---usp_ExportFutureFundingFromCRES
	exec [dbo].[usp_InsertErrorLogFromDB] 'ExportFutureFunding-sql',@ErrorMessage,@DealID,'usp_ExportFutureFundingFromCRES',@CreatedBy

END CATCH


END


