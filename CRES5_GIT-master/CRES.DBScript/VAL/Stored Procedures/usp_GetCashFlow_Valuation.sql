
CREATE PROCEDURE [VAL].[usp_GetCashFlow_Valuation]  --'1/31/2024','17-0916'
	@markedDate date,
	@credealid nvarchar(256) = null
	
AS  
BEGIN  
  
	SET NOCOUNT ON;  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = @MarkedDate)

IF(@credealid is not null)
BEGIN
	Select DealID,DealName,NoteID,NoteName,[Date],[Value],ValueType from (
	Select 
	d.credealid as DealID
	,d.dealname as DealName
	,n.crenoteid as Noteid
	,acc.name as NoteName
	,tr.Date
	,ISNULL(tr.valueOverride,tr.Value) as [Value]
	,tr.ValueType 
	
	from [VAL].[NoteCashFlow] tr
	Inner JOin cre.note n on n.noteid = tr.noteid
	Inner Join core.account acc on acc.accountid = n.account_accountid
	Inner JOin cre.deal d on d.dealid = n.dealid
	Left Join core.analysis a on a.analysisid = tr.analysisid
	Inner Join [val].DealList dl on dl.dealid = d.dealid and IsCashFlowLive = 572 and dl.MarkedDateMasterID = @MarkedDateMasterID
	Where acc.isdeleted <> 1 and d.isdeleted <> 1
	and tr.MarkedDateMasterID = @MarkedDateMasterID
	and d.credealid = @credealid
	and tr.date >= DateAdd(day,1,EOMonth(DateAdd(month,-3,@markedDate)))
	
	UNION ALL

	Select 
	d.credealid as DealID
	,d.dealname as DealName
	,n.crenoteid as Noteid
	,acc.name as NoteName
	,tr.Date
	,tr.Amount as Value
	,tr.[Type] as ValueType
	
	from cre.transactionentry tr
	Inner join core.account acc on acc.accountid = tr.AccountID
    Inner join cre.note n on n.account_accountid = acc.accountid
  

	--Inner JOin cre.note n on n.noteid = tr.noteid
	--Inner Join core.account acc on acc.accountid = n.account_accountid
	Inner JOin cre.deal d on d.dealid = n.dealid
	Inner JOin [val].DealList dl on dl.dealid = d.dealid and IsCashFlowLive = 571 and dl.MarkedDateMasterID = @MarkedDateMasterID

	Where acc.isdeleted <> 1 and d.isdeleted <> 1
	and tr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	and tr.[type] not in ('LIBORPercentage','PIKInterestPercentage','SpreadPercentage','PIKLiborPercentage','RawIndexPercentage')
	and tr.date >= DateAdd(day,1,EOMonth(DateAdd(month,-3,@markedDate)))
	and d.credealid = @credealid
	and (n.ActualPayOffDate is null OR n.ActualPayOffDate > Cast(@markedDate as date))
	and  acc.AccounttypeID = 1
	) Res Order By NoteID,[Date]
END
ELSE
BEGIN
	Select DealID,DealName,NoteID,NoteName,[Date],[Value],ValueType from (
	Select 
	d.credealid as DealID
	,d.dealname as DealName
	,n.crenoteid as Noteid
	,acc.name as NoteName
	,tr.Date
	,ISNULL(tr.valueOverride,tr.Value) as [Value]
	,tr.ValueType 
	from [VAL].[NoteCashFlow] tr
	Inner JOin cre.note n on n.noteid = tr.noteid
	Inner Join core.account acc on acc.accountid = n.account_accountid
	Inner JOin cre.deal d on d.dealid = n.dealid
	Left Join core.analysis a on a.analysisid = tr.analysisid
	Inner Join [val].DealList dl on dl.dealid = d.dealid and IsCashFlowLive = 572 and dl.MarkedDateMasterID = @MarkedDateMasterID
	Where acc.isdeleted <> 1 and d.isdeleted <> 1
	and tr.MarkedDateMasterID = @MarkedDateMasterID
	and tr.date >= DateAdd(day,1,EOMonth(DateAdd(month,-3,@markedDate)))
	
	UNION ALL

	Select 
	d.credealid as DealID
	,d.dealname as DealName
	,n.crenoteid as Noteid
	,acc.name as NoteName
	,tr.Date
	,tr.Amount as Value
	,tr.[Type] as ValueType
	from cre.transactionentry tr
	Inner join core.account acc on acc.accountid = tr.AccountID
    Inner join cre.note n on n.account_accountid = acc.accountid
	--Inner JOin cre.note n on n.noteid = tr.noteid
	--Inner Join core.account acc on acc.accountid = n.account_accountid
	Inner JOin cre.deal d on d.dealid = n.dealid
	Inner JOin [val].DealList dl on dl.dealid = d.dealid and IsCashFlowLive = 571 and dl.MarkedDateMasterID = @MarkedDateMasterID

	Where acc.isdeleted <> 1 and d.isdeleted <> 1
	and tr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	and tr.[type] not in ('LIBORPercentage','PIKInterestPercentage','SpreadPercentage','PIKLiborPercentage','RawIndexPercentage')
	and tr.date >= DateAdd(day,1,EOMonth(DateAdd(month,-3,@markedDate)))
	and (n.ActualPayOffDate is null OR n.ActualPayOffDate > Cast(@markedDate as date))
	and  acc.AccounttypeID = 1
	) Res Order By NoteID,[Date]
END
	


	

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  