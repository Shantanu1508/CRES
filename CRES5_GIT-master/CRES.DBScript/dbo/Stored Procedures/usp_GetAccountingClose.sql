CREATE procedure [dbo].[usp_GetAccountingClose] --'4f25c598-fe91-4a28-a20b-bf936e91b2e8'  
 @PortfolioMasterGuid uniqueidentifier = null    
AS  
BEGIN  
  
 SET NOCOUNT ON;  
  
  
  
Declare @tblFirstUnrecDate as TABLE(DealID UNIQUEIDENTIFIER, FirstUnrecDate Date)  
  
INSERT INTO @tblFirstUnrecDate (DealID,FirstUnrecDate)  
Select Distinct DealID,MIN(First_Unreconciled_Date) as FirstUnrecDate  
from(  
 Select tr.dealid,tr.noteid,tr.CREDealID,tr.DealName, ISNULL(EngineType,'C#') as Engine_Type, tr.CRENoteID,tr.ActualPayoffDate,tr.Transactionname as TransactionType, tblac.MAX_DueDate as Last_Reconciled_Date,ISNULL(DATEADD(month,1,tblac.MAX_DueDate),tr.ClosingDate) as First_Unreconciled_Date  
 From(  
  Select Distinct d.dealid,n.noteid,d.credealid,d.dealname, l.Name as EngineType, n.crenoteid,n.ActualPayoffDate,tr.[Type] as Transactionname,n.ClosingDate  
  from cre.TransactionEntry tr  
  Inner join core.account acc on acc.accountid = tr.AccountID         
  Inner join cre.note n on n.account_accountid = acc.accountid  
  --Inner join cre.note n on n.noteid =tr.noteid  
  --Inner join core.account acc on acc.accountid = n.account_accountid  
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
   
 )tr  
 LEFT JOIN(  
  Select nt.noteid,nt.TransactionTypeText,MAX(RelatedtoModeledPMTDate)  MAX_DueDate  
  from cre.notetransactiondetail nt  
  Inner join cre.note n on n.noteid =nt.noteid  
  Inner join core.account acc on acc.accountid = n.account_accountid  
  where acc.isdeleted <> 1  
  group by nt.noteid,nt.TransactionTypeText  
 )tblac on tblac.NoteID = tr.NoteID and tblac.TransactionTypeText = tr.Transactionname  
 --Where tr.noteid ='C5AF85D9-1F20-4281-BF4A-E5E4FE7B2714'  
)z  
group by dealid,DealName,CREDealID  
  
  
  
IF (@PortfolioMasterGuid is null or @PortfolioMasterGuid='00000000-0000-0000-0000-000000000000')    
BEGIN    
 Select   
  d.DealID as DealID    
 ,d.credealid as CREDealID   
 ,d.dealname as DealName  
 ,tbldd.ClosingDate  
 ,tbldd.Maturity  
 ,p.LastAccountingCloseDate  
 ,p.LastClosedOn  
 ,p.LastClosedBy  
 ,(CASE WHEN tblnc.dealid is not null then 1 else 0 end) isDataExists  
 ,tbllastAct.LastActivityType  
 ,p.Comments  
 ,p.[Description]  
 ,tbldd.ActualPayoffdate  
 ,ISNULL(fu.FirstUnrecDate,tbldd.ClosingDate) as FirstUnrecDate  
 from cre.deal d  
 left join @tblFirstUnrecDate fu on fu.dealid = d.dealid  
 Left join (  
  Select dealid,CloseDate as LastAccountingCloseDate,CreatedDate as LastClosedOn,updateddate,LastClosedBy,Comments,[Description]  
  From(  
   Select p.dealid,p.CloseDate,p.CreatedDate,p.updateddate,(u.FirstName + ' ' + u.LastName) as LastClosedBy,p.Comments,p.[Description],  
   ROW_NUMBER() OVER (Partition BY p.dealid order by p.dealid,p.updateddate desc) rno  
   from CORE.[Period] p  
   Left join App.[User] u on u.UserID = p.UpdatedBy  
   where p.IsDeleted <> 1  
   and p.CloseDate is not null  
  )a where rno = 1  
 ) p on d.dealid = p.dealid    
   
 Left Join(  
  Select d.dealid,MAX(n.ClosingDate) as ClosingDate,MAX(ISNULL(n.ActualPayoffdate,n.fullyextendedmaturitydate)) as Maturity,MAX(n.ActualPayoffdate) as ActualPayoffdate  
  from cre.Deal d  
  Inner Join cre.note n on n.dealid = d.dealid  
  Inner Join core.account acc on acc.accountid = n.account_accountid  
  Where acc.isdeleted <> 1 and d.isdeleted <> 1  
  Group by d.dealid  
 )tbldd on tbldd.dealid = d.dealid  
 Left Join(  
  Select Distinct  d.dealid  
  from cre.noteperiodiccalc nc  
   Inner join core.account acc on acc.accountid = nc.AccountID
   Inner join cre.note n on n.account_accountid = acc.accountid 
  --Inner Join cre.note n on n.noteid = nc.noteid  
  --Inner Join core.account acc on acc.accountid = n.account_accountid  
  Inner Join cre.deal d on d.dealid = n.dealid  
  Where acc.isdeleted <> 1 and d.isdeleted <> 1  and acc.AccounttypeID = 1
  and nc.analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'  
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
 where d.isdeleted <> 1   
   
 and d.dealid in (  
  ----Only V1 deals  
  Select Distinct n.dealid   
  from cre.note n   
  inner join core.account acc on acc.accountid =n.account_accountid  
  inner join cre.deal d on d.dealid = n.dealid  
  where d.CalcEngineType = 798  
  and d.isdeleted <> 1  
  and acc.isdeleted <> 1  
 )  
   
 Order by p.LastAccountingCloseDate desc    
END  
ELSE  
BEGIN  
  Declare @Dynamic_Portfolio as Table(    
  PortfolioMasterID int ,    
  ObjectTypeID int ,    
  ObjectID int     
  )    
    
  INSERT INTO @Dynamic_Portfolio(PortfolioMasterID,ObjectTypeID,ObjectID)    
  select  pm.PortfolioMasterID,pd.ObjectTypeID,pd.ObjectID     
  from core.PortfolioMaster pm     
  inner join core.PortfolioDetail pd on pm.PortfolioMasterID = pd.PortfolioMasterID    
  where pm.PortfolioMasterGuid=@PortfolioMasterGuid     
  --============================================   
    
  Select   
  d.DealID as DealID    
 ,d.credealid as CREDealID   
 ,d.dealname as DealName  
 ,tbldd.ClosingDate  
 ,tbldd.Maturity  
 ,p.LastAccountingCloseDate  
 ,p.LastClosedOn  
 ,p.LastClosedBy  
 ,(CASE WHEN tblnc.dealid is not null then 1 else 0 end) isDataExists  
 ,tbllastAct.LastActivityType  
 ,p.Comments  
 ,p.[Description]  
 ,tbldd.ActualPayoffdate  
 ,ISNULL(fu.FirstUnrecDate,tbldd.ClosingDate) as FirstUnrecDate  
 from cre.deal d  
 left join @tblFirstUnrecDate fu on fu.dealid = d.dealid  
 Left join (  
  Select dealid,CloseDate as LastAccountingCloseDate,CreatedDate as LastClosedOn,updateddate,LastClosedBy,Comments,[Description]  
  From(  
   Select p.dealid,p.CloseDate,p.CreatedDate,p.updateddate,(u.FirstName + ' ' + u.LastName) as LastClosedBy,p.Comments,p.[Description],  
   ROW_NUMBER() OVER (Partition BY p.dealid order by p.dealid,p.updateddate desc) rno  
   from CORE.[Period] p  
   Left join App.[User] u on u.UserID = p.UpdatedBy  
   where p.IsDeleted <> 1  
   and p.CloseDate is not null  
  )a where rno = 1  
 ) p on d.dealid = p.dealid    
   
 Left Join(  
  Select d.dealid,MAX(n.ClosingDate) as ClosingDate,MAX(ISNULL(n.ActualPayoffdate,n.fullyextendedmaturitydate)) as Maturity,MAX(n.ActualPayoffdate) as ActualPayoffdate  
  from cre.Deal d  
  Inner Join cre.note n on n.dealid = d.dealid  
  Inner Join core.account acc on acc.accountid = n.account_accountid  
  Where acc.isdeleted <> 1 and d.isdeleted <> 1  
  Group by d.dealid  
 )tbldd on tbldd.dealid = d.dealid  
 Left Join(  
  Select Distinct  d.dealid  
  from cre.noteperiodiccalc nc  
    Inner join core.account acc on acc.accountid = nc.AccountID
    Inner join cre.note n on n.account_accountid = acc.accountid 
  --Inner Join cre.note n on n.noteid = nc.noteid  
  --Inner Join core.account acc on acc.accountid = n.account_accountid  
  Inner Join cre.deal d on d.dealid = n.dealid  
  Where acc.isdeleted <> 1 and d.isdeleted <> 1  and acc.AccounttypeID = 1
  and nc.analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'  
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
 where d.isdeleted <> 1   
 and d.dealid in (      
  Select c.dealid  
  From(    
   Select b.noteid,b.CRENoteID,b.Fundid,b.PoolID,b.ClientID,b.FinancingSourceID,b.dealid    
   From(    
    Select a.noteid,a.CRENoteID,a.Fundid,a.PoolID,a.ClientID,a.FinancingSourceID,a.dealid    
    From(    
     Select n.noteid,n.CRENoteID,n.Fundid,n.PoolID,n.ClientID,n.FinancingSourceID,n.dealid    
     from cre.note n    
     where 1 = (CASE WHEN (Select Count(ObjectID) from @Dynamic_Portfolio Where ObjectTypeID = 574) = 0 Then 1    
     WHEN n.Fundid in (Select ObjectID from @Dynamic_Portfolio Where ObjectTypeID = 574) Then 1    
     END)     
    )a    
    where 1 = (CASE WHEN (Select Count(ObjectID) from @Dynamic_Portfolio Where ObjectTypeID = 511) = 0 Then 1    
    WHEN a.PoolID in (Select ObjectID from @Dynamic_Portfolio Where ObjectTypeID = 511) Then 1    
    END)     
   )b    
   where 1 = (CASE WHEN (Select Count(ObjectID) from @Dynamic_Portfolio Where ObjectTypeID = 633) = 0 Then 1    
   WHEN b.FinancingSourceID in (Select ObjectID from @Dynamic_Portfolio Where ObjectTypeID = 633) Then 1    
   END)    
  )c    
  where 1 = (CASE WHEN (Select Count(ObjectID) from @Dynamic_Portfolio Where ObjectTypeID = 510) = 0 Then 1    
  WHEN c.ClientID in (Select ObjectID from @Dynamic_Portfolio Where ObjectTypeID = 510) Then 1  END)    
 )   
 Order by p.LastAccountingCloseDate desc    
END  
  
  
END





