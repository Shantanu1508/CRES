

CREATE PROCEDURE [VAL].[usp_SaveNoteCashFlow] --'12/31/2020'
	@markedDate date,
	@UserID nvarchar(256)
	
AS  
BEGIN  
  
	SET NOCOUNT ON;  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = @MarkedDate)

	----INsert CF for deals having "No"--------
	IF OBJECT_ID('tempdb..#tblDealListDontHaveCF') IS NOT NULL         
	DROP TABLE #tblDealListDontHaveCF

	CREATE TABLE #tblDealListDontHaveCF(
		dealid UNIQUEIDENTIFIER
	)
	INSERT INTO #tblDealListDontHaveCF(dealid)	
	Select dl.dealid  ----list of deal do not have cashflow data in table
	from val.deallist dl
	Left Join(
		Select distinct dealid from [VAL].[NoteCashFlow] where MarkedDateMasterID = @MarkedDateMasterID
	)cf on cf.dealid = dl.dealid
	where MarkedDateMasterID = @MarkedDateMasterID and IsCashFlowLive =572
	and cf.DealID is null


	INSERT INTO [VAL].[NoteCashFlow] (
	MarkedDateMasterID
	,DealID		 
	,Noteid	
	,Date	
	,Value	
	,ValueType	

	,TransactionDate
	,DueDate
	,RemitDate
	,FeeName
	,[Description]
	,Cash_NonCash

	,AnalysisID
	,CreatedBy	
	,CreatedDate
	,UpdatedBy	
	,UpdatedDate
	)

	Select 
	@MarkedDateMasterID
	,d.DealID		 
	,n.Noteid	
	,tr.Date	
	,tr.Amount as Value	
	,tr.Type as ValueType	
		
	,tr.TransactionDateServicingLog as TransactionDate
	,tr.[Date] as DueDate
	,tr.RemitDate
	,tr.FeeName
	,tr.Comment as Description
	,tr.Cash_NonCash
		
	,tr.AnalysisID
	,@UserID as CreatedBy	
	,getdate() as CreatedDate
	,@UserID as UpdatedBy	
	,getdate() as UpdatedDate
	from cre.transactionentry tr
	 Inner join core.account acc on acc.accountid = tr.AccountID
     Inner join cre.note n on n.account_accountid = acc.accountid
 
	--Inner JOin cre.note n on n.noteid = tr.noteid
	--Inner Join core.account acc on acc.accountid = n.account_accountid
	Inner JOin cre.deal d on d.dealid = n.dealid
	Inner Join (
		Select dealid From #tblDealListDontHaveCF
	)dl on dl.dealid = d.dealid 

	Where acc.isdeleted <> 1 and d.isdeleted <> 1 and acc.AccounttypeID = 1
	and tr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	---and tr.[type] not in ('LIBORPercentage','PIKInterestPercentage','SpreadPercentage','PIKLiborPercentage','RawIndexPercentage','RawPIKIndexPercentage')
	and tr.date >= DATEADD(month,-6,@markedDate)
	----================================================



	-----Delete from CF if deal is set to "yes"---------------------
	IF OBJECT_ID('tempdb..#tblDealListForDeleteCF') IS NOT NULL         
	DROP TABLE #tblDealListForDeleteCF

	CREATE TABLE #tblDealListForDeleteCF(
		dealid UNIQUEIDENTIFIER
	)
	INSERT INTO #tblDealListForDeleteCF(dealid)	
	Select dl.dealid  
	from val.deallist dl
	Inner Join(
		Select distinct dealid from [VAL].[NoteCashFlow] where MarkedDateMasterID = 3
	)cf on cf.dealid = dl.dealid
	where MarkedDateMasterID = @MarkedDateMasterID and IsCashFlowLive =571

	Delete from [VAL].[NoteCashFlow] where MarkedDateMasterID = @MarkedDateMasterID and dealid in (Select dealid from #tblDealListForDeleteCF)
	----===============================================================




	SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  



