
--exec [dbo].[usp_CopyFF_FromOtherSource] 'tcp:b0xesubcki1.database.windows.net,1433','CRES4_Integration','d9vWuP)[WEhu})P','CRES4_Integration','20-1525','B0E6697B-3534-4C09-BE0A-04473401AB93','17501'


CREATE PROCEDURE [dbo].[usp_CopyFF_FromOtherSource]
@ServerName nvarchar(256),
@Login nvarchar(256),
@Password nvarchar(256),
@DataBaseName nvarchar(256),
@CREDealID nvarchar(256),
@UpdatedBy nvarchar(256),
@CRENoteID nvarchar(256)
AS
BEGIN
	SET NOCOUNT ON;

--IF((SELECT DB_NAME()) = 'CRES4_Acore')
--BEGIN
--	Print('Not allowed to import in production')
--	return;
--END


BEGIN TRY
BEGIN TRAN

Declare @DBServer nvarchar(256) = @ServerName;	
Declare @DB_User_Int nvarchar(256) = @Login;
Declare @DB_Pass_Int nvarchar(256) = @Password;
Declare @DB_Name_Int nvarchar(256) = @DataBaseName;



exec  ('
	IF EXISTS(select [name] from sys.external_data_sources where name = ''RemoteReference_CopyDealOtherSrc'')
		Drop EXTERNAL DATA SOURCE RemoteReference_CopyDealOtherSrc 
	IF EXISTS(select [name] from sys.database_scoped_credentials where name = ''Credential_CopyDealOtherSrc'')
		Drop DATABASE SCOPED CREDENTIAL Credential_CopyDealOtherSrc

	--CREATE DATABASE SCOPED CREDENTIAL
	CREATE DATABASE SCOPED CREDENTIAL Credential_CopyDealOtherSrc  WITH IDENTITY = '''+ @DB_User_Int +''',  SECRET = '''+ @DB_Pass_Int +'''

	--CREATE EXTERNAL DATA SOURCE
	Create EXTERNAL DATA SOURCE RemoteReference_CopyDealOtherSrc
	WITH 
	( 
		TYPE=RDBMS, 
		LOCATION='''+ @DBServer +''', 
		DATABASE_NAME='''+ @DB_Name_Int +''', 
		CREDENTIAL= Credential_CopyDealOtherSrc 
	); 
')

Declare @Env nvarchar(256)
SET @Env = 'RemoteReference_CopyDealOtherSrc';


--Check deal in source env
DECLARE @query nvarchar(256) = N'Select COUNT(CREDealID) from [CRE].[Deal] where CREDealID = '''+@CREDealID+''''
DECLARE @DealCount TABLE (Cnt int,ShardName nvarchar(max))
INSERT INTO @DealCount (Cnt,ShardName)
EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @query

IF ((Select cnt from @DealCount) =  0)
BEGIN
	
	Print('Deal does not exists in source')
	--RETURN;
END
ELSE
BEGIN

---===========================================================================================
--Importing Deal with Notes
DECLARE  @NewDealID nvarchar(256),
		 @c_accountid UNIQUEIDENTIFIER,
		 @c_NoteName nvarchar(256) ,
		 @c_CRENoteID nvarchar(256),
		 @c_NoteId UNIQUEIDENTIFIER,
		 @AnalysisIDDefault uniqueidentifier;
DECLARE  @insertedAccountID uniqueidentifier;
DECLARE  @insertedEventID uniqueidentifier;
DECLARE  @insertedNoteID uniqueidentifier;
DECLARE  @tAccount TABLE (tAccountID UNIQUEIDENTIFIER)
DECLARE  @tNote TABLE (tNewNoteId UNIQUEIDENTIFIER)
DECLARE  @tEvent TABLE (tNewEventId UNIQUEIDENTIFIER)
Declare  @BalanceTransactionSchedule  int  =5;
Declare  @DefaultSchedule  int  =6;
Declare  @FeeCouponSchedule  int  =7;
Declare  @FinancingFeeSchedule  int  =8;
Declare  @FinancingSchedule  int  =9;
Declare  @FundingSchedule  int  =10;
Declare  @Maturity  int  =11;
Declare  @PIKSchedule  int  =12;
Declare  @PrepayAndAdditionalFeeSchedule  int  =13;
Declare  @RateSpreadSchedule  int  =14;
Declare  @ServicingFeeSchedule  int  =15;
Declare  @StrippingSchedule  int  =16;
Declare  @PIKScheduleDetail  int  =17;
Declare  @LIBORSchedule  int  =18;
Declare  @AmortSchedule  int  =19;
Declare  @FeeCouponStripReceivable  int  =20;  
Declare @generatedBy nvarchar(MAX);


SET @generatedBy = (Select LookupID FROM [CORE].[Lookup] WHERE Name ='Imported' and ParentID=36);
Set @AnalysisIDDefault = (Select AnalysisID from core.Analysis where Name = 'Default');
---===========================================================================================
 
--Get tables data from source env 
EXEC [dbo].[usp_GetTableFromSource] @CREDealID,@Env

---===========================================================================================



  --Note Cursor
DECLARE copy_cursor CURSOR FOR 
select AccountID,
        NoteName, 
        CRENoteID,
        NoteId  from ##tblNoteCursor where CRENoteID = @CRENoteID
OPEN copy_cursor  
FETCH NEXT FROM copy_cursor into @c_accountid,  @c_NoteName, @c_CRENoteID, @c_NoteId

WHILE @@FETCH_STATUS = 0  
   Begin


--============================Cursor for all note detail schedule===========================
Delete from core.FundingSchedule where [EventID] in (Select [EventID] from [Core].[Event] where [AccountID] = @c_accountid and [EventTypeID] = 10)

Delete from [Core].[Event] where [AccountID] = @c_accountid and [EventTypeID] = 10

--Event
INSERT INTO [Core].[Event](
	   [AccountID]
      ,[Date]
      ,[EventTypeID]
      ,[EffectiveStartDate]
      ,[EffectiveEndDate]
      ,[SingleEventValue]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
      ,[StatusID])

SELECT DISTINCT
	   AccountID
      ,[Date]
      ,[EventTypeID]
      ,[EffectiveStartDate]
      ,[EffectiveEndDate]
      ,[SingleEventValue]
      ,[CreatedBy]
      ,[CreatedDate]
      ,@UpdatedBy as Updatedby
      ,getdate() as UpdatedDate
      ,[StatusID]
FROM ##tblEvent  where AccountID=@c_accountid and [EventTypeID] = 10



--FundingSchedule
IF EXISTS (SELECT EventTypeID FROM ##tblEvent WHERE EventTypeID=@FundingSchedule)
BEGIN

INSERT INTO core.FundingSchedule (
[EventId]
      ,[Date]
      ,[Value]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
      ,[PurposeID]
      ,[Applied]
      ,[DrawFundingId]
      ,[Comments]
      ,[Issaved]
      ,[DealFundingRowno]
      ,[DealFundingID]
      ,[WF_CurrentStatus]
	  ,GeneratedBy)

	  SELECT (SELECT TOP 1
				EventId
			FROM CORE.[event] se
			WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)
			AND se.[EventTypeID] = @FundingSchedule and StatusID = 1
			AND se.AccountID = @c_accountid),
			CONVERT(date, fd.Date, 101),
			Value,	
			fd.CreatedBy,
			fd.CreatedDate,
			@UpdatedBy as Updatedby,
            getdate() as UpdatedDate,
			PurposeID,
			Applied,
		    DrawFundingId,
		    Comments,
			Issaved,	
		    DealFundingRowno
		   ,[DealFundingID]
          ,[WF_CurrentStatus]
		  ,GeneratedBy
	FROM ##tblFundingSchedule fd 
	inner join ##tblEvent e  on e.eventid =  fd.EventId
	inner join ##tblAccount acc on acc.AccountID =  e.AccountID
	WHERE fd.Date is not null 
	and e.StatusID = 1
	and acc.AccountID = @c_accountid and  e.EventTypeID = @FundingSchedule

END


	


FETCH NEXT FROM copy_cursor into  @c_accountid,  @c_NoteName, @c_CRENoteID, @c_NoteId

END	  
CLOSE copy_cursor;  
DEALLOCATE copy_cursor; 


IF OBJECT_ID('tempdb..##tblDeal') IS NOT NULL             
DROP TABLE ##tblDeal; 
IF OBJECT_ID('tempdb..##tblProperty') IS NOT NULL             
DROP TABLE ##tblProperty           
 IF OBJECT_ID('tempdb..##tblDealFunding') IS NOT NULL             
DROP TABLE ##tblDealFunding          
IF OBJECT_ID('tempdb..##tblPayrule') IS NOT NULL             
DROP TABLE ##tblPayrule 
IF OBJECT_ID('tempdb..##tblAutoSpreadRule') IS NOT NULL             
DROP TABLE ##tblAutoSpreadRule 
IF OBJECT_ID('tempdb..##tblDealAmortizationSchedule') IS NOT NULL             
DROP TABLE ##tblDealAmortizationSchedule 
IF OBJECT_ID('tempdb..##tblDealProjectedPayOffAccounting') IS NOT NULL             
DROP TABLE ##tblDealProjectedPayOffAccounting 
IF OBJECT_ID('tempdb..##tblNoteCursor') IS NOT NULL             
DROP TABLE ##tblNoteCursor         
IF OBJECT_ID('tempdb..##tblAccount') IS NOT NULL             
DROP TABLE ##tblAccount  
IF OBJECT_ID('tempdb..##tblNote') IS NOT NULL             
DROP TABLE ##tblNote 
IF OBJECT_ID('tempdb..##tblEvent ') IS NOT NULL             
DROP TABLE ##tblEvent 
IF OBJECT_ID('tempdb..##tblMaturity') IS NOT NULL             
DROP TABLE ##tblMaturity   
IF OBJECT_ID('tempdb..##tblRateSpreadSchedule') IS NOT NULL             
DROP TABLE ##tblRateSpreadSchedule     
IF OBJECT_ID('tempdb..##tblPrepayAndAdditionalFeeSchedule') IS NOT NULL             
DROP TABLE ##tblPrepayAndAdditionalFeeSchedule     
IF OBJECT_ID('tempdb..##tblFinancingFeeSchedule') IS NOT NULL             
DROP TABLE ##tblFinancingFeeSchedule     
IF OBJECT_ID('tempdb..##tblFinancingSchedule') IS NOT NULL             
DROP TABLE ##tblFinancingSchedule 
IF OBJECT_ID('tempdb..##tblDefaultSchedule') IS NOT NULL             
DROP TABLE ##tblDefaultSchedule     
IF OBJECT_ID('tempdb..##tblPIKSchedule') IS NOT NULL             
DROP TABLE ##tblPIKSchedule  
IF OBJECT_ID('tempdb..##tblServicingFeeSchedule') IS NOT NULL             
DROP TABLE ##tblServicingFeeSchedule  
IF OBJECT_ID('tempdb..##tblFundingSchedule') IS NOT NULL             
DROP TABLE ##tblFundingSchedule  
IF OBJECT_ID('tempdb..##tblPIKScheduleDetail') IS NOT NULL             
DROP TABLE ##tblPIKScheduleDetail 
IF OBJECT_ID('tempdb..##tblLiborSchedule') IS NOT NULL             
DROP TABLE ##tblLiborSchedule 
IF OBJECT_ID('tempdb..##tblAmortSchedule') IS NOT NULL             
DROP TABLE ##tblAmortSchedule 
IF OBJECT_ID('tempdb..##tblFeeCouponStripReceivable') IS NOT NULL             
DROP TABLE ##tblFeeCouponStripReceivable
IF OBJECT_ID('tempdb..##tblExceptions') IS NOT NULL             
DROP TABLE ##tblExceptions
IF OBJECT_ID('tempdb..##tblFundingRepaymentSequence') IS NOT NULL             
DROP TABLE ##tblFundingRepaymentSequence
IF OBJECT_ID('tempdb..##tblPayruleDistributions') IS NOT NULL             
DROP TABLE ##tblPayruleDistributions
 IF OBJECT_ID('tempdb..##tblServicerDropDateSetup') IS NOT NULL             
DROP TABLE ##tblServicerDropDateSetup

END

COMMIT TRAN
END TRY
BEGIN CATCH

	DECLARE @ErrorMessage NVARCHAR(4000);
	DECLARE @ErrorSeverity INT;
	DECLARE @ErrorState INT;

	SELECT @ErrorMessage = 'SQL error ' + ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(),  @ErrorState = ERROR_STATE();
	IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION;

	-- Use RAISERROR inside the CATCH block to return error
	-- information about the original error that caused
	-- execution to jump to the CATCH block.

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	  
END CATCH



Print('FF imported successfully.')

END




 
