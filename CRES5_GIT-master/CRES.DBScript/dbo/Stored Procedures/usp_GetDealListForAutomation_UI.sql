
-- Procedure
CREATE Procedure [dbo].[usp_GetDealListForAutomation_UI]
AS
BEGIN
	SET NOCOUNT ON;

	Select distinct d.dealid
	,credealid
	,cast(0 as bit) as [Active]
	,(Case When tblActive.DealID is not null THEN 'No' ELSE 'Yes' end) as [PaidOff]
	,dealname
	,l.Name as [Status] 
	,(Case When EnableAutoSpread = 1 THEN 'Yes' ELSE 'No' end)  as [ASFundingEnabled]
	,(Case When EnableAutoSpreadRepayments = 1 THEN 'Yes' ELSE 'No' end)  as [ASRepaymentEnabled]
	,tblar.DealSaveStatus as DealSaveStatus
	,tblar.AutomationStatus as AutomationStatus
	from cre.note n 
	inner join core.account acc on acc.accountid = n.account_accountid
	inner join cre.deal d on d.dealid = n.dealid
	left join core.Lookup l on l.LookupID = d.[Status]
	Left Join(
		Select Distinct d.dealid
		from cre.note n 
		inner join core.account acc on acc.accountid = n.account_accountid
		inner join cre.deal d on d.dealid = n.dealid
		where acc.isdeleted <> 1  and d.isdeleted <> 1
		and ActualPayoffDate is null
	)tblActive on tblActive.dealid = d.DealID
	left Join(
		Select DealID,DealSaveStatus,l.name as AutomationStatus
		from Core.AutomationRequests ar
		left join core.lookup l on l.lookupid = ar.StatusID
		Where ar.BatchID = (Select ISNULL(MAX(BatchID),0) from Core.AutomationRequests where AutomationType = 799)
	)tblar on tblar.dealid = d.dealid
	where acc.isdeleted <> 1  and d.isdeleted <> 1
	and d.[Status] <> 324
 
	 
End






