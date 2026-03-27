--- [dbo].[usp_ImportDealFromBackshop] '25-0021','B0E6697B-3534-4C09-BE0A-04473401AB93',null,null

CREATE PROCEDURE [dbo].[usp_ImportDealFromBackshop]    
(      
	@DealID varchar(256) ,
	@CreatedBy nvarchar(256),
	@allowImport int OUTPUT,
	@ValidationMessage nvarchar(256) OUTPUT
)      
AS     
BEGIN      
 SET NOCOUNT ON;


SET @allowImport = 0

Delete from [IO].[L_BackShopDeal] where ControlId = @DealID
Delete from [IO].[L_BackShopNote] where ControlId = @DealID
Delete from [IO].[L_BackShopNoteFunding] where ControlId = @DealID


Declare @query_Deal nvarchar(max);

SET @query_Deal = N'Select cm.ControlId 
,cm.dealname
,cm.LoanStatusCd_F
,ls.LoanStatusDesc 
from tblControlMaster cm
Left Join [dbo].[tblzCdLoanStatus] ls on ls.LoanStatusCd = cm.LoanStatusCd_F 
Where ls.LoanStatusDesc  in (
''Inquiry'',
--''Dead'',
''Quote / Proposal'',
''Term Sheet Issued'',
''Term Sheet Signed'',
''Credit Committee Approved'',
''Committed''
)
and cm.ControlID = '''+ @DealID +'''
'

INSERT INTO  [IO].[L_BackShopDeal](ControlId,dealname,LoanStatusCd_F,LoanStatusDesc,ShardName)
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = @query_Deal


IF EXISTS(Select ControlId from [IO].[L_BackShopDeal] where controlid = @DealID)  ----Exist in backshop as pipeline
BEGIN	
	
	IF NOT EXISTS(
		Select d.credealid
		from cre.deal d
		where d.isdeleted <> 1  
		and d.credealid = @DealID
	)
	BEGIN
		---Deal Not Exist in M61 
		SET @allowImport = 1;
		SET @ValidationMessage = 'Deal exists in backshop as pipeline and does not exists in M61';
	END
	ELSE IF EXISTS(
		Select d.credealid,ls.LoanStatusDesc
		from cre.deal d
		Inner join cre.loanstatus ls on d.LoanStatusID = ls.LoanStatusID
		where d.isdeleted <> 1  and d.credealid = @DealID
		and ls.LoanStatusDesc in (
		'Funded',
		'Securtized / Sold (partial)',
		'Paid Off',
		'Watchlist',
		'DPO',
		'Foreclosure',
		'REO',
		'REO Released',
		'Duplicates / Test Loans',
		'Duplicate',
		'Previous Placeholder',
		'Pre-Modified Deal'
		)
	)
	BEGIN
		---Exist in M61 as funded
		SET @allowImport = 0;
		SET @ValidationMessage = 'Deal exists in backshop as pipeline and found in m61 as funded.';
	END
	ELSE IF EXISTS(
		Select d.credealid,ls.LoanStatusDesc
		from cre.deal d
		Inner join cre.loanstatus ls on d.LoanStatusID = ls.LoanStatusID
		where d.isdeleted <> 1  and d.credealid = @DealID
		and ls.LoanStatusDesc in (
		'Inquiry',		
		'Quote / Proposal',
		'Term Sheet Issued',
		'Term Sheet Signed',
		'Credit Committee Approved',
		'Committed'
		)
		and AllowSizerUpload =  937
	)
	BEGIN
		---Exist in M61 as pipeline and flag is set to "Allow Upload" = "Backshop pipeline"
		SET @allowImport = 1;
		SET @ValidationMessage = 'Deal exists in backshop as pipeline and also found in m61 as pipeline with set "Allow Upload" as "Backshop pipeline".';
	END
	ELSE IF EXISTS(
		Select d.credealid,ls.LoanStatusDesc
		from cre.deal d
		Inner join cre.loanstatus ls on d.LoanStatusID = ls.LoanStatusID
		where d.isdeleted <> 1  and d.credealid = @DealID
		and ls.LoanStatusDesc in (
		'Inquiry',		
		'Quote / Proposal',
		'Term Sheet Issued',
		'Term Sheet Signed',
		'Credit Committee Approved',
		'Committed'
		)
		and AllowSizerUpload <>  937
	)
	BEGIN
		---Exist in M61 as pipeline and flag is not set to "Allow Upload" <> "Backshop pipeline"
		SET @allowImport = 0;
		SET @ValidationMessage = 'Deal exists in backshop as pipeline and also found in m61 as pipeline. for allow override you have to set "Allow Upload" as "Backshop pipeline".';
	END


END
ELSE
BEGIN
	SET @allowImport = 0;
	SET @ValidationMessage = 'Deal does not exists in backshop as pipeline';
	
END



IF(@allowImport = 1)
BEGIN

	Declare @query_Note nvarchar(max);
	SET @query_Note = N'SELECT ControlId,NoteId	,NoteName,FundingDate,TotalCommitment,TotalCurrentAdjustedCommitment,OrigLoanAmount,PaymentFreqCd_F,LienPosition,[Priority],StatedMaturityDate 
	FROM [acore].[vw_AcctNote] where Controlid = '''+ @DealID +''''
	
	INSERT INTO [IO].[L_BackShopNote](ControlId,NoteId,NoteName,FundingDate,TotalCommitment,TotalCurrentAdjustedCommitment,OrigLoanAmount,PaymentFreqCd_F,LienPosition,[Priority],StatedMaturityDate,ShardName)
	EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', @stmt = @query_Note

	IF OBJECT_ID('tempdb..#tblNoteLoanTerm') IS NOT NULL         
		DROP TABLE #tblNoteLoanTerm

	CREATE TABLE #tblNoteList( 
		ControlId_F Nvarchar(255), 
		NoteId Nvarchar(255),
		LoanTerm int,
		OriginationFeePct decimal(28,15),
		FirstPIPaymentDate DateTime,

		ShardName Nvarchar(MAX)
	)

	SET @query_Note = N'SELECT ControlId_F, NoteId, LoanTerm, OriginationFeePct, FirstPIPaymentDate from dbo.tblnote where ControlId_F = '''+ @DealID +''''
	
	INSERT INTO #tblNoteList(ControlId_F, NoteId, LoanTerm, OriginationFeePct, FirstPIPaymentDate, ShardName)
	EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', @stmt = @query_Note;

	Update BN Set 
	BN.LoanTerm = temp.LoanTerm,
	BN.OriginationFeePct = temp.OriginationFeePct,
	BN.FirstPIPaymentDate = temp.FirstPIPaymentDate
	FROM [IO].[L_BackShopNote] BN 
	INNER JOIN #tblNoteList temp ON BN.ControlId = temp.ControlId_F AND BN.NoteId = temp.NoteId


	---Check Duplicate note
	IF EXISTS(
		Select ControlId,Noteid from [IO].[L_BackShopNote] where ControlId = @DealID 
		and NoteId in (
			Select n.crenoteid 
			from cre.note n 
			Inner Join core.account acc on acc.accountid = n.account_accountid
			Inner join cre.deal d on d.dealid = n.DealID
			where acc.isdeleted <> 1
			and d.CREDealID <> @DealID
		)
	)
	BEGIN
		---Check Duplicate note
		SET @allowImport = 0;
		SET @ValidationMessage = 'Duplicate note found';
		Select @allowImport,@ValidationMessage

		return;
	END
	ELSE
	BEGIN
		---Not found Duplicate note
		SET @allowImport = 1;
		SET @ValidationMessage = 'Not found Duplicate note';
		
	END

	DECLARE @query_FF nvarchar(MAX) = N'Select '''+@DealID+''' as ControlID,CAST(NoteID_f as varchar(256)) as NoteID_f,FundingDate,FundingAmount,cast(Comments as nvarchar(max)) as Comments,FundingPurposeCD_F,Applied,WireConfirm,FundingAdjustmentTypeCd_F
	from tblnotefunding where FundingPurposeCD_F not in (''PIKNC'',''PIKPP'') 
	and  NoteID_f in (Select noteid from tblnote where controlid_f = '''+@DealID+''')'  
	
	INSERT INTO [IO].[L_BackShopNoteFunding](ControlID,NoteID_f,FundingDate,FundingAmount,Comments,FundingPurposeCD_F,Applied,WireConfirm,FundingAdjustmentTypeCd_F,ShardName)
	EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData',  	@stmt = @query_FF  


	---Check FF exists
	IF EXISTS(Select ControlId from [IO].[L_BackShopNoteFunding] where ControlId = @DealID)
	BEGIN
		
		SET @allowImport = 1;
		SET @ValidationMessage = 'Future funding found';
		
	END
	ELSE
	BEGIN
		
		SET @allowImport = 0;
		SET @ValidationMessage = 'No future funding found';
		Select @allowImport,@ValidationMessage
		return;
		
	END
	

	exec [dbo].[usp_ImportDealFromBackshopInM61] @DealID,@CreatedBy
END


Select @allowImport,@ValidationMessage

--Select * from [IO].[L_BackShopDeal] where ControlId = @DealID
--Select * from [IO].[L_BackShopNote] where ControlId = @DealID
--Select * from [IO].[L_BackShopNoteFunding] where ControlId = @DealID




END

