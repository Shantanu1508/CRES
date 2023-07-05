-- Procedure
  
--[dbo].[usp_VerifyFutureFundingM61andBackshop_PayDown] '12871','admin_qa','admin_qa'  
  
CREATE PROCEDURE [dbo].[usp_VerifyFutureFundingM61andBackshop_PayDown]   
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
		Select Distinct [CRENoteID]  
		,[FundingDate]  
		,[FundingAmount]  
		,[Comments]  
		,[FundingPurpose]  
		,0 as [Applied]  
		,0 as [WireConfirm]   
		,'' as DrawFundingId   
		from [IO].[out_FutureFunding] where [CRENoteID] = @CRENoteId and [AuditUserName] = @userName   and [FundingDate] > '12/31/2019' and IsProjectedPaydown = 1
  

		DECLARE @query nvarchar(MAX) = N'Select  Distinct CAST(NoteID_f as varchar(256)) as NoteID_f
		,[PaymentDate] as FundingDate
		,[Amount] as FundingAmount
		,'''' as Comments
		,FundingPurposeCD_F
		,0 Applied
		,0 WireConfirm
		,'''' FundingDrawId   
		from [acore].[vw_AcctNoteProjectedPayments] 
		where PaymentDate > ''12/31/2019'' 
		and FundingPurposeCD_F not in (''PIKNC'',''PIKPP'') and  NoteID_f = '''+ @CRENoteId +''' '  
  

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


     
		Delete from core.Exceptions where ObjectID=@NoteId and FieldName = 'M61 and Backshop funding paydown mismatch' and ObjectTypeID = 182  

  
		IF(@m61Count = @backshopCount and @m61Count = @countAll )  
		BEGIN  
   
			UPDATE [IO].[out_FutureFunding] set [Status] = 'Verified' where [CRENoteID] = @CRENoteId and [AuditUserName] = @userName  and IsProjectedPaydown = 1
		END  
		ELSE  
		BEGIN  
   
			declare @NormalEx int = (Select LookupID from core.lookup where ParentID= 46 and Name = 'Normal')  
      
			INSERT into core.Exceptions ([ObjectID],[ObjectTypeID],[FieldName],[Summary],[ActionLevelID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])  
			VALUES(@NoteId ,182 ,'M61 and Backshop funding paydown mismatch','M61 and Backshop funding paydown mismatch.',@NormalEx,@CreatedBy,GETDATE(),@CreatedBy,GETDATE())  
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
	exec [dbo].[usp_InsertErrorLogFromDB] 'ExportFutureFunding-sql',@ErrorMessage,@DealID,'usp_VerifyFutureFundingM61andBackshop_PayDown',@userName

	  
END CATCH



END  
  
  
  
