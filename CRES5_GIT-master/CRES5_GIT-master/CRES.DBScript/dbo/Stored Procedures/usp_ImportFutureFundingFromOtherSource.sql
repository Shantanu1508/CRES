
--[dbo].[usp_ImportFutureFundingFromOtherSource] 'tcp:b0xesubcki1.database.windows.net,1433','CRES4_Integration','d9vWuP)[WEhu})P','CRES4_Integration','19-16351UseRuleN'



CREATE PROCEDURE [dbo].[usp_ImportFutureFundingFromOtherSource]
	@ServerName nvarchar(256),
	@Login nvarchar(256),
	@Password nvarchar(256),
	@DataBaseName nvarchar(256),
	@CREDealID nvarchar(256)
AS
BEGIN
	SET NOCOUNT ON;


	Declare @DBServer nvarchar(256) = @ServerName;	
	Declare @DB_User_Int nvarchar(256) = @Login;
	Declare @DB_Pass_Int nvarchar(256) = @Password;
	Declare @DB_Name_Int nvarchar(256) = @DataBaseName;

	exec  ('
		IF EXISTS(select [name] from sys.external_data_sources where name = ''RemoteReference_ImportFFOtherSrc'')
			Drop EXTERNAL DATA SOURCE RemoteReference_ImportFFOtherSrc 
		IF EXISTS(select [name] from sys.database_scoped_credentials where name = ''Credential_ImportFFOtherSrc'')
			Drop DATABASE SCOPED CREDENTIAL Credential_ImportFFOtherSrc

		--CREATE DATABASE SCOPED CREDENTIAL
		CREATE DATABASE SCOPED CREDENTIAL Credential_ImportFFOtherSrc  WITH IDENTITY = '''+ @DB_User_Int +''',  SECRET = '''+ @DB_Pass_Int +'''

		--CREATE EXTERNAL DATA SOURCE
		Create EXTERNAL DATA SOURCE RemoteReference_ImportFFOtherSrc
		WITH 
		( 
			TYPE=RDBMS, 
			LOCATION='''+ @DBServer +''', 
			DATABASE_NAME='''+ @DB_Name_Int +''', 
			CREDENTIAL= Credential_ImportFFOtherSrc 
		); 
	')

--Collect deal data from other source in global temp table (##)

exec [dbo].[usp_GetTableFromSourceFF]  @CREDealID,'RemoteReference_ImportFFOtherSrc'
--=====================================================================================================

/****
Actual Insert
***/


Declare @Src_dealid UNIQUEIDENTIFIER
Declare @Des_dealid UNIQUEIDENTIFIER

SET @Src_dealid = (Select dealid from ##tblDeal where credealid = @CREDealID and IsDeleted <> 1)
SET @Des_dealid = (Select dealid from cre.deal where credealid = @CREDealID and IsDeleted <> 1)

Declare  @FundingSchedule  int  =10;

Delete from CRE.DealFunding where dealid = @Des_dealid

 INSERT INTO CRE.DealFunding
	(
		DealID,	
		[Date],	
		Amount,	
		Comment,	
		PurposeID,	
		Applied,	
		DrawFundingId,	
		Issaved,	
		DealFundingRowno,	
		DeadLineDate,	
		LegalDeal_DealFundingID,	
		EquityAmount,	
		RemainingFFCommitment,	
		RemainingEquityCommitment,	
		SubPurposeType,
		CreatedBy,	
		CreatedDate	,
		UpdatedBy,	
		UpdatedDate,
		RequiredEquity,
		AdditionalEquity
	)
	select 	
	@Des_dealid,
	Date,
	Amount,
	Comment,
	PurposeID,
	Applied,
	DrawFundingId,
	Issaved,
	DealFundingRowno,
	DeadLineDate,
	LegalDeal_DealFundingID,	
	EquityAmount,	
	RemainingFFCommitment,	
	RemainingEquityCommitment,	
	SubPurposeType,
	CreatedBy,
	Getdate(),
	UpdatedBy,
	Getdate(),
	RequiredEquity,
	AdditionalEquity
	from ##tblDealFunding  where dealid = @Src_dealid



---Delete note FF----------
Declare @tblAccID as Table(AccID UNIQUEIDENTIFIER)

INSERT INTO @tblAccID(AccID)
select Distinct acc.AccountID
	from cre.Note n
	inner join core.Account acc on acc.accountid = n.Account_AccountID
	inner join cre.deal d on d.DealID = n.DealID
	where acc.isdeleted <> 1
	and d.DealID = @Des_dealid  

Delete From core.FundingSchedule where EventId in (Select eventid from CORE.Event where eventtypeid = 10 and accountid in (Select AccID from @tblAccID) )
Delete from CORE.Event where eventtypeid = 10 and accountid in (Select AccID from @tblAccID)
--=====================


DECLARE @c_accountid UNIQUEIDENTIFIER,
@c_NoteName nvarchar(256) ,
@c_CRENoteID nvarchar(256),
@c_NoteId UNIQUEIDENTIFIER

DECLARE @d_accountid UNIQUEIDENTIFIER,
@d_NoteName nvarchar(256) ,
@d_CRENoteID nvarchar(256),
@d_NoteId UNIQUEIDENTIFIER



IF CURSOR_STATUS('global','Cursor_OtherSrc')>=-1          
BEGIN          
DEALLOCATE Cursor_OtherSrc          
END 

DECLARE Cursor_OtherSrc CURSOR FOR 
	
	select AccountID,NoteName,CRENoteID,NoteId  from ##tblNoteCursor

OPEN Cursor_OtherSrc  
FETCH NEXT FROM Cursor_OtherSrc into @c_accountid,  @c_NoteName, @c_CRENoteID, @c_NoteId
WHILE @@FETCH_STATUS = 0  
Begin
	
	select @d_accountid = acc.AccountID,
	@d_NoteId = n.NoteId,
	@d_CRENoteID = n.CRENoteID,
	@d_NoteName = acc.name 
	from cre.note n
	inner join Core.Account acc on acc.accountid = n.Account_AccountID	
	where acc.isdeleted <> 1
	and n.CRENoteID =  @c_CRENoteID 


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
		   @d_accountid
		  ,[Date]
		  ,[EventTypeID]
		  ,[EffectiveStartDate]
		  ,[EffectiveEndDate]
		  ,[SingleEventValue]
		  ,[CreatedBy]
		  ,[CreatedDate]
		  ,UpdatedBy as Updatedby
		  ,getdate() as UpdatedDate
		  ,[StatusID]
	FROM ##tblEvent  where AccountID=@c_accountid  and eventtypeid=@FundingSchedule and StatusID = 1

	IF EXISTS (SELECT EventTypeID FROM ##tblEvent WHERE EventTypeID=@FundingSchedule)
	BEGIN
		INSERT INTO core.FundingSchedule ([EventId]
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
			  ,[WF_CurrentStatus])

			  SELECT (SELECT TOP 1
						EventId
					FROM CORE.[event] se
					WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)
					AND se.[EventTypeID] = @FundingSchedule and StatusID = 1
					AND se.AccountID = @d_accountid),
					CONVERT(date, fd.Date, 101),
					Value,	
					fd.CreatedBy,
					fd.CreatedDate,
					fd.UpdatedBy as Updatedby,
					getdate() as UpdatedDate,
					PurposeID,
					Applied,
					DrawFundingId,
					Comments,
					Issaved,	
					DealFundingRowno
				   ,[DealFundingID]
				  ,[WF_CurrentStatus]
			FROM ##tblFundingSchedule fd 
			inner join ##tblEvent e  on e.eventid =  fd.EventId
			inner join ##tblAccount acc on acc.AccountID =  e.AccountID
			WHERE fd.Date is not null 
			and e.StatusID = 1
			and acc.AccountID = @c_accountid and  e.EventTypeID = @FundingSchedule
	  END


	

FETCH NEXT FROM Cursor_OtherSrc into   @c_accountid,  @c_NoteName, @c_CRENoteID, @c_NoteId
END
CLOSE Cursor_OtherSrc;  
DEALLOCATE Cursor_OtherSrc; 



END
