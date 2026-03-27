-- Procedure

CREATE PROCEDURE [VAL].[usp_GetCashFlow_Valuation_Client] --'12/31/2020'
	@markedDate date
	
AS  
BEGIN  
  
	SET NOCOUNT ON;  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = @MarkedDate)


	Select NoteCashFlowID
	,d.credealid as DealID
	,d.dealname as DealName
	,n.crenoteid as Noteid
	,acc.name as NoteName
	,tr.Date
	,tr.Value
	,tr.ValueOverride
	,tr.ValueType 

	--,tr.Spread
	--,tr.IndexValue
	,tr.TransactionDate
	,tr.DueDate
	,tr.RemitDate
	,tr.FeeName
	,tr.Description
	,tr.Cash_NonCash

	from [VAL].[NoteCashFlow] tr
	Inner JOin cre.note n on n.noteid = tr.noteid
	Inner Join core.account acc on acc.accountid = n.account_accountid
	Inner JOin cre.deal d on d.dealid = n.dealid
	Left Join core.analysis a on a.analysisid = tr.analysisid
	Inner Join [val].DealList dl on dl.dealid = d.dealid and IsCashFlowLive = 572

	Where acc.isdeleted <> 1 and d.isdeleted <> 1
	and tr.MarkedDateMasterID = @MarkedDateMasterID
	
	



	

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  