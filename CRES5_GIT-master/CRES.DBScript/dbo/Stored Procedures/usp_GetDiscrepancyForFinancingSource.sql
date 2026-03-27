CREATE PROCEDURE [dbo].[usp_GetDiscrepancyForFinancingSource]   
AS  
BEGIN  
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  

	Select d.CREDealID as [Deal ID],DealName as [Deal Name],n.CRENoteID as [Note ID],acc.Name as [Note Name],fs.FinancingSourceName as [Financing Source]
	from cre.note n 
	inner join core.account acc on acc.accountid = n.Account_AccountID
	inner join Cre.Deal d on d.dealID=n.DealID
	left join cre.FinancingSourceMaster fs on fs.FinancingSourceMasterID= n.FInancingSourceID
	Where acc.isdeleted<>1 and d.isdeleted <> 1
	and (fs.FinancingSourceName is null OR fs.FinancingSourceName = 'None')
	and d.[Status] = 323
	AND  d.DealName NOT LIKE '%copy%'
	Order by DealName, n.crenoteid,acc.Name
  
  

 SET TRANSACTION ISOLATION LEVEL READ COMMITTED      
END     


