CREATE procedure [dbo].[usp_GetAccountingCloseByDealID]   
	@DealID UNIQUEIDENTIFIER ,  
	@PgeIndex INT,  
	@PageSize INT,  
	@totalCount INT OUTPUT   
AS  
  
BEGIN  
  
 SET NOCOUNT ON;  
SELECT @totalCount = COUNT(Dealid) FROM Core.Period where Dealid=@DealID and isdeleted<>1 ;  
  
Declare @tblFirstUnrecDate as TABLE(DealID UNIQUEIDENTIFIER, FirstUnrecDate Date)  
  
INSERT INTO @tblFirstUnrecDate (DealID,FirstUnrecDate)  
Select Distinct DealID,MIN(First_Unreconciled_Date) as FirstUnrecDate  
from(  
 Select tr.dealid,tr.noteid,tr.CREDealID,tr.DealName, ISNULL(EngineType,'C#') as Engine_Type, tr.CRENoteID,tr.ActualPayoffDate,tr.Transactionname as TransactionType, tblac.MAX_DueDate as Last_Reconciled_Date,ISNULL(DATEADD(month,1,tblac.MAX_DueDate),tr.ClosingDate) as First_Unreconciled_Date  
 From(  
  Select Distinct d.dealid,n.noteid,d.credealid,d.dealname, l.Name as EngineType, n.crenoteid,n.ActualPayoffDate,tr.[Type] as Transactionname,n.ClosingDate  
  from cre.TransactionEntry tr  
  Inner join core.account acc on acc.accountid = tr.AccountID         
  left join cre.note n on n.account_accountid = acc.accountid  
 -- Inner join cre.note n on n.noteid =tr.noteid  
 -- Inner join core.account acc on acc.accountid = n.account_accountid  
  Inner join cre.deal d on d.dealid = n.dealid  
  left join core.Lookup l on l.LookupID=d.CalcEngineType  
  where acc.isdeleted <> 1  and acc.AccounttypeID = 1
  and tr.analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'  
  and d.Status=323  
  --and CalcEngineType=798  
  and tr.[Type] in ('ExitFeeExcludedFromLevelYield','ExtensionFeeExcludedFromLevelYield','InterestPaid','ScheduledPrincipalPaid')  ----'ExitFeeStrippingExcldfromLevelYield','ExitFeeStripReceivable',  
  and tr.date >= '1/1/2021'   
  and tr.date < GETDATE()  
  and n.Financingsourceid not in (Select FinancingSourceMasterID from cre.financingsourcemaster where IsThirdParty = 1)  
  and d.dealid = @DealID  
 )tr  
 LEFT JOIN(  
  Select nt.noteid,nt.TransactionTypeText,MAX(RelatedtoModeledPMTDate)  MAX_DueDate  
  from cre.notetransactiondetail nt  
  Inner join cre.note n on n.noteid =nt.noteid  
  Inner join core.account acc on acc.accountid = n.account_accountid  
  where acc.isdeleted <> 1  
  and n.dealid = @DealID  
  group by nt.noteid,nt.TransactionTypeText  
 )tblac on tblac.NoteID = tr.NoteID and tblac.TransactionTypeText = tr.Transactionname  
 --Where tr.noteid ='C5AF85D9-1F20-4281-BF4A-E5E4FE7B2714'  
)z  
group by dealid,DealName,CREDealID  
  
  
---==================================================  
Select   
 tbldd.ClosingDate  
 ,tbldd.Maturity  
 ,P.CloseDate  
 ,(CASE WHEN P.CloseDate IS NULL THEN P.OpenDate ELSE NULL END)  as OpenDate  
 ,(u.FirstName + ' ' + u.LastName) as UpdatedBy  
 ,p.UpdatedDate as UpdatedOn  
 ,(CASE WHEN tblnc.dealid is not null then 1 else 0 end) isDataExists  
 ,p.LastActivityType  
 ---,tbllastAct.LastActivityType  
 ,p.updateddate  
 ,tbllastClose.LastAccountingCloseDate  
 ,tbllastOpen.LastAccountingOpenDate  
 ,p.comments  
 ,p.[Description]  
 ,tbldd.ActualPayoffdate  
 ,ISNULL(fu.FirstUnrecDate,tbldd.ClosingDate) as FirstUnrecDate  
 from cre.deal d  
 Inner join CORE.[Period] p on d.dealid = p.dealid   
 left join @tblFirstUnrecDate fu on fu.dealid = d.dealid  
 Left join App.[User] u on u.UserID = p.UpdatedBy  
 Left Join(  
  Select d.dealid,MAX(n.ClosingDate) as ClosingDate,MAX(ISNULL(n.ActualPayoffdate,n.fullyextendedmaturitydate)) as Maturity,MAX(n.ActualPayoffdate) as ActualPayoffdate  
  from cre.Deal d  
  Inner Join cre.note n on n.dealid = d.dealid  
  Inner Join core.account acc on acc.accountid = n.account_accountid  
  Where acc.isdeleted <> 1 and d.isdeleted <> 1  
  and d.dealid = @DealID  
  Group by d.dealid  
 )tbldd on tbldd.dealid = d.dealid  
 Left Join(  
  Select Distinct  d.dealid  
  from cre.noteperiodiccalc nc  
  Inner Join cre.note n on n.Account_AccountID = nc.AccountID  
  Inner Join core.account acc on acc.accountid = n.account_accountid  
  Inner Join cre.deal d on d.dealid = n.dealid  
  Where acc.isdeleted <> 1 and d.isdeleted <> 1  
  and nc.analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'  
  and d.dealid = @DealID  
  and acc.AccounttypeID = 1
  
 )tblnc on tblnc.dealid = d.dealid  
 Left Join(  
  Select dealid,LastActivityType  
  From(  
   Select   
   p.dealid   
   ,LastActivityType  
   ,ROW_NUMBER() OVER (Partition BY p.dealid order by p.dealid,p.PeriodAutoID desc) rno  
   from CORE.[Period] p   
  )a  
  Where rno = 1  
 )tbllastAct on tbllastAct.dealid = d.dealid  
   
   
 left Join(  
  Select   
  d.DealID as DealID    
  , d.credealid as CREDealID   
  ,d.dealname as DealName   
  ,MAX(p.Closedate) as LastAccountingCloseDate   
  from cre.deal d  
  Left join CORE.[Period] p on d.dealid = p.dealid and p.isdeleted <> 1  
  where d.isdeleted <> 1   
  and d.dealid = @DealID  
  Group by  d.DealID,d.credealid,d.dealname  
  
 )tbllastClose on tbllastClose.dealid = d.dealid  
 left Join(  
  Select   
  d.DealID as DealID    
  , d.credealid as CREDealID   
  ,d.dealname as DealName   
  ,MAX(p.OpenDate) as LastAccountingOpenDate   
  from cre.deal d  
  Left join CORE.[Period] p on d.dealid = p.dealid   
  where d.dealid = @DealID  
  and p.CloseDate is null  
  Group by  d.DealID,d.credealid,d.dealname  
  
 )tbllastOpen on tbllastOpen.dealid = d.dealid  
  
   
 where d.dealid = @DealID  
 and d.isdeleted <> 1    
  
 order by d.dealid,p.updateddate desc  
  
  
  
  
END





