-- Procedure
  
--[dbo].[usp_VerifyFutureFundingM61andBackshop] '12871','admin_qa','admin_qa'  
  
CREATE PROCEDURE [dbo].[usp_VerifyFutureFundingM61andBackshop]   
(  
 @CRENoteId nvarchar(256),  
 @userName nvarchar(256),  
 @CreatedBy nvarchar(256)  
)  
AS  
BEGIN  
  
BEGIN TRY
--BEGIN TRAN
--======================================================
	Declare @Cutoffdate date = CAST((select [Value] from app.appconfig where [key] = 'CutOffDate_BackshopExport') as date)

	DECLARE @query1 nvarchar(256) = N'Select COUNT(noteid) from [acore].[vw_AcctNote] where Noteid = '''+@CRENoteId+''''  
	DECLARE @NoteCount TABLE (Cnt int,ShardName nvarchar(max))  
	INSERT INTO @NoteCount (Cnt,ShardName)  
	EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceDataFF', @stmt = @query1  
  
	IF ((Select cnt from @NoteCount) > 0) --Check if note exists in backshop database  
	BEGIN  
  
		Declare @NoteId UNIQUEIDENTIFIER   
		SET @NoteId = (Select noteid from cre.note where CRENoteID = @CRENoteId);  
  
  
  
		DECLARE @M61FF TABLE  
		(  
		CRENoteID nvarchar(256) null,  
		FundingDate Date null,  
		FundingAmount decimal(28 ,15) null,  
		Comments nvarchar(256) null,  
		FundingPurpose nvarchar(256) null,  
		Applied bit null,  
		WireConfirm bit null,  
		DrawFundingId nvarchar(256) null  
		)  
  
		DECLARE @BackshopFF TABLE  
		(  
		CRENoteID nvarchar(256) null,  
		FundingDate Date null,  
		FundingAmount decimal(28 ,15) null,  
		Comments nvarchar(256) null,  
		FundingPurpose nvarchar(256) null,  
		Applied bit null,  
		WireConfirm bit null,  
		DrawFundingId nvarchar(256) null,  
		ShardName nvarchar(256) null  
		)  
		---======================================================  
		INSERT INTO @M61FF (CRENoteID,FundingDate,FundingAmount,Comments,FundingPurpose,Applied,WireConfirm,DrawFundingId)  
		Select [CRENoteID]  
		,[FundingDate]  
		,[FundingAmount]  
		,[Comments]  
		,[FundingPurpose]  
		,[Applied]  
		,[WireConfirm]   
		,DrawFundingId   
		from [IO].[out_FutureFunding] where [CRENoteID] = @CRENoteId and [AuditUserName] = @userName   and [FundingDate] > @Cutoffdate 
		and ISNULL(IsProjectedPaydown,0) <> 1
  
		--Select Distinct n.CRENoteID  
		-- ,fs.[Date] as FundingDate  
		-- ,fs.Value as FundingAmount  
		-- ,fs.Comments  
		-- ,(CASE LPurposeID.name  
		-- WHEN 'Property Release' THEN 'PROPREL'  
		-- WHEN 'Payoff/Paydown' THEN 'PAYOFF'  
		-- WHEN 'Additional Collateral Purchase' THEN 'ADDCOLLPUR'  
		-- WHEN 'Capital Expenditure' THEN 'CAPEXPEN'  
		-- WHEN 'Debt Service / Opex' THEN 'DSOPEX'  
		-- WHEN 'TI/LC' THEN 'TILCDRAW'  
		-- WHEN 'Other' THEN 'OTHER'  
		-- WHEN 'Amortization' THEN 'AMORT'  
		-- WHEN 'OpEx' THEN 'OPEX'  
		-- WHEN 'Force Funding' THEN 'FORCEFUND'  
		-- WHEN 'Capitalized Interest' THEN 'CAPINTC'  
		-- WHEN 'Full Payoff' THEN 'FULLPAY'  
		-- WHEN 'Note Transfer' THEN 'NOTETRAN'   
		-- WHEN 'Paydown' THEN 'PAYDOWN'  
		-- WHEN 'Principal Writeoff' THEN 'PWRITEOFF'
		-- END  
		-- )as [FundingPurpose]  
		-- ,1 as [Applied]  
		-- ,fs.[Applied] as [WireConfirm]  
		-- ,fs.DrawFundingId  
		--from [CORE].FundingSchedule fs  
		--INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId  
		--INNER JOIN   
		--   (  
        
		--    Select   
		--     (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID and ac.IsDeleted=0) AccountID ,  
		--     MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID  
		--     from [CORE].[Event] eve  
		--     INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
		--     INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
		--     where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')  
		--     and n.CRENoteID = @CRENoteId and acc.IsDeleted=0  
		--     and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)  
		--     GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID  
  
		--   ) sEvent  
  
		--ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
  
		--left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID  
		--left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID   
		--INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
		--INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
		--where sEvent.StatusID = e.StatusID and acc.IsDeleted=0  
		--and fs.[Date] > '01/31/2020'  
  
		------------------  

		DECLARE @query nvarchar(MAX) = N'Select Distinct CAST(NoteID_f as varchar(256)),FundingDate,FundingAmount,'''' as Comments,FundingPurposeCD_F,Applied,WireConfirm,FundingDrawId   
		from [acore].[vw_AcctNoteFundings] where FundingDate > '''+ CAST(@Cutoffdate as nvarchar(256)) +''' and FundingPurposeCD_F not in (''PIKNC'',''PIKPP'') and  NoteID_f = '''+ @CRENoteId +''' '  
  
		INSERT INTO @BackshopFF (CRENoteID,FundingDate,FundingAmount,Comments,FundingPurpose,Applied,WireConfirm,DrawFundingId,ShardName)  
		EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceDataFF',   
		@stmt = @query  
  
		---======================================================  
  
		/* Comparision */  
		DECLARE @m61Count int, @backshopCount int, @countAll int;  
		SELECT @m61Count = COUNT(*)  
			FROM @M61FF  
  
		SELECT @backshopCount = COUNT(*)  
			FROM @BackshopFF  
  
		 --Comparing both tables  
		SELECT @countAll = COUNT(*) from  
		 (Select   
		  CRENoteID,  
		  FundingDate,  
		  ROUND(FundingAmount,0) FundingAmount,  
		  null as Comments,  
		  FundingPurpose,  
		  Applied,  
		  WireConfirm,  
		  DrawFundingId  
		  FROM @M61FF  
		 UNION  
			Select   
		  CRENoteID,  
		  FundingDate,  
		  ROUND(FundingAmount,0) FundingAmount,  
		  null as Comments,  
		  FundingPurpose,  
		  Applied,  
		  WireConfirm,  
		  DrawFundingId  
		 FROM @BackshopFF) a  


     
		Delete from core.Exceptions where ObjectID=@NoteId and FieldName = 'M61 and Backshop funding mismatch' and ObjectTypeID = 182  

  
			IF(@m61Count = @backshopCount and @m61Count = @countAll )  
			BEGIN  
   
			 UPDATE [IO].[out_FutureFunding] set [Status] = 'Verified' where [CRENoteID] = @CRENoteId and [AuditUserName] = @userName  and IsProjectedPaydown <> 1
			END  
			ELSE  
			BEGIN  
   
				declare @NormalEx int = (Select LookupID from core.lookup where ParentID= 46 and Name = 'Normal')  
      
			 INSERT into core.Exceptions ([ObjectID],[ObjectTypeID],[FieldName],[Summary],[ActionLevelID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])  
			 VALUES(@NoteId ,182 ,'M61 and Backshop funding mismatch','M61 and Backshop funding mismatch.',@NormalEx,@CreatedBy,GETDATE(),@CreatedBy,GETDATE())  
			END  
  END  
  
--======================================================
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

	Declare @DealID UNIQUEIDENTIFIER
	SET @DealID = (Select top 1 dealid from cre.Note where CRENoteID = @NoteId)
	exec [dbo].[usp_InsertErrorLogFromDB] 'ExportFutureFunding-sql',@ErrorMessage,@DealID,'usp_VerifyFutureFundingM61andBackshop',@userName

	  
END CATCH



END  
  
  
  
