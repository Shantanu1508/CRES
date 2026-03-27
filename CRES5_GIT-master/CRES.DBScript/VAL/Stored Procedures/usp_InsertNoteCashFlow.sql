-- Procedure

CREATE PROCEDURE [VAL].[usp_InsertNoteCashFlow] --'12/31/2020'
	@markedDate date,
	@UserID nvarchar(256),
	@credealid nvarchar(256) = null
	
AS  
BEGIN  
  
	SET NOCOUNT ON;  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = @MarkedDate)


	IF OBJECT_ID('tempdb..#tblDealList') IS NOT NULL         
	DROP TABLE #tblDealList

	CREATE TABLE #tblDealList(
		CREDealId nvarchar(256)
	)
	INSERT INTO #tblDealList(CREDealId)
	Select [Value] from [dbo].[fn_Split_Str](@credealid,'|')



	Delete from [VAL].[NoteCashFlow] where MarkedDateMasterID = @MarkedDateMasterID

	--INSERT INTO [VAL].[NoteCashFlow] (
	--MarkedDateMasterID
	--,DealID		 
	--,Noteid	
	--,Date	
	--,Value	
	--,ValueType	
	--,AnalysisID
	--,CreatedBy	
	--,CreatedDate
	--,UpdatedBy	
	--,UpdatedDate
	--)

	Select 
	@MarkedDateMasterID
	,d.DealID		 
	,d.Noteid	
	,tr.Date	
	,tr.Amount as Value	
	,tr.Type as ValueType		
	,tr.AnalysisID
	,@UserID as CreatedBy	
	,getdate() as CreatedDate
	,@UserID as UpdatedBy	
	,getdate() as UpdatedDate
	from cre.transactionentry tr
	Inner Join core.account acc on acc.accountid = tr.accountid
	Inner JOin cre.note n on n.account_accountid = acc.accountid
	
	Inner JOin cre.deal d on d.dealid = n.dealid
	Inner Join (
		Select d.dealid,dl.Scenario from #tblDealList td
		Inner Join cre.deal d on d.credealid = td.CREDealId and d.isdeleted <> 1
		Inner Join [val].DealList dl on dl.dealid = d.dealid
		Where ISNULL(dl.IsCashFlowLive,4) = 4
	)dl on dl.dealid = d.dealid and dl.Scenario = tr.analysisid

	Where acc.isdeleted <> 1 and d.isdeleted <> 1
	and tr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	and tr.[type] not in ('LIBORPercentage','PIKInterestPercentage','SpreadPercentage','PIKLiborPercentage','RawIndexPercentage')
	and tr.date >= DATEADD(month,-6,@markedDate)


	


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END
GO

