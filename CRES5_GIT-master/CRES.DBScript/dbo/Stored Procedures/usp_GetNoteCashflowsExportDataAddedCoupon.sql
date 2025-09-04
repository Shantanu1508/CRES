  
  
--[dbo].[usp_GetNoteCashflowsExportDataAddedCoupon] 'aa15a573-e71d-4ffd-ad99-29f8eb6aa99d','00000000-0000-0000-0000-000000000000'  
  
  
  
CREATE PROCEDURE [dbo].[usp_GetNoteCashflowsExportDataAddedCoupon]   
  
@NoteId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',  
@DealId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000'  
  
AS  
BEGIN  
    SET NOCOUNT ON;  
  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
Declare @Column nvarchar(256)=(select top 1 l.Name from core.Lookup  l inner join core.AnalysisParameter ap on l.lookupid=ap.MaturityScenarioOverrideID   
inner join core.Analysis a on a.AnalysisID=ap.AnalysisID where a.StatusID=(select LookupID from core.Lookup where ParentID =2 and  Name = 'Y'))  
  
  
  
Select Noteid,NoteName,[Date],Value,ValueType  
from  
(  
 select   
 n.CRENoteID Noteid,  
 acc.Name NoteName,  
 LEFT(CONVERT(VARCHAR, te.[Date], 101), 10) AS [Date],  
 te.Amount Value,  
 te.[Type] ValueType  
  from  CRE.TransactionEntry te   
   Inner join core.account acc on acc.accountid = te.AccountID     
   left join cre.note n on n.account_accountid = acc.accountid  
 --inner join Cre.Note n on n.NoteID=te.NoteID  
 --inner join core.Account acc on acc.AccountID=n.Account_AccountID  
 where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1   
 AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1  
  
 and te.[type] not in (Select replace(name,' ','') + 'Receivable' from core.lookup where lookupid in (163,164,165,166))  
   
  
  
 UNION ALL  
    
  
 select   
 n.crenoteid as Noteid  
 ,a.name as NoteName  
 ,dateadd(d,day(firstpaymentdate),eomonth(transactiondate,-1)) AS [Date]  
 ,amount as Value  
 ,replace(l.name,' ','') + 'Receivable' as ValueType  
 from cre.note n inner join core.account a on n.account_accountid=a.accountid inner join   
 cre.payruledistributions p on p.receivernoteid=n.noteid inner join core.lookup l on p.ruleid=l.lookupid  
 where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1   
 and isnull(amount,0)<>0  
 AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1  
 and dateadd(d,day(firstpaymentdate),eomonth(transactiondate,-1))  <= (  
   
  Select isnull(n1.ActualPayoffDate,  
   ISNULL(  
    (CASE WHEN @Column ='Initial or Actual Payoff Date' then n1.ActualPayoffDate     
    WHEN @Column ='Expected Maturity Date' then n1.ExpectedMaturityDate     
    WHEN @Column ='Extended Maturity Date' then n1.ExtendedMaturityCurrent   
    WHEN @Column ='Open Prepayment Date' then n1.OpenPrepaymentDate     
    WHEN @Column ='Fully Extended Maturity Date' then n1.FullyExtendedMaturityDate   
    Else ISNULL(n1.ActualPayOffDate,ISNULL(currMat.MaturityDate,n1.FullyExtendedMaturityDate))  end)   
   ,tblInitialMaturity.InitialMaturityDate)  
  )as maturity  
  from cre.note n1  
  Inner join core.account acc1 on acc1.Accountid = n1.Account_Accountid  
  Left Join(  
   Select noteid,MaturityType,MaturityDate,Approved  
   from (  
     Select n.noteid,lMaturityType.name as [MaturityType],mat.MaturityDate as [MaturityDate],lApproved.name as Approved,  
     ROW_NUMBER() Over(Partition by noteid order by noteid,(CASE WHEN lMaturityType.name = 'Initial' THEN 0 WHEN lMaturityType.name = 'Fully extended' THEN 9999 ELSE 1 END) ASC, mat.MaturityDate) rno  
     from [CORE].Maturity mat    
     INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId    
     INNER JOIN     
     (            
      Select     
      (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,    
      MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve    
      INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID    
      INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID    
      where EventTypeID = 11 and eve.StatusID = 1  
      and n.Account_AccountID = a.AccountID  
      and acc.IsDeleted = 0    
      GROUP BY n.Account_AccountID,EventTypeID      
     ) sEvent      
     ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID   and e.StatusID = 1  
     INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
     INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID    
     Left JOin Core.lookup lMaturityType on lMaturityType.lookupid = mat.MaturityType  
     Left JOin Core.lookup lApproved on lApproved.lookupid = mat.Approved   
     where mat.MaturityDate > getdate()  
     and lApproved.name = 'Y'  
     and n.Account_AccountID = a.AccountID  
   )a where a.rno = 1  
  )currMat on currMat.noteid = n1.noteid   
  Left JOin(  
   Select n.noteid,mat.MaturityDate as InitialMaturityDate  
   from [CORE].Maturity mat    
   INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId    
   INNER JOIN     
   (            
    Select     
    (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,    
    MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve    
    INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID    
    INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID    
    where EventTypeID = 11   and eve.StatusID = 1  
    and acc.IsDeleted = 0    
    and n.Account_AccountID = a.AccountID  
    GROUP BY n.Account_AccountID,EventTypeID      
   ) sEvent      
   ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID   and e.StatusID = 1  
   INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
   INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID    
   where mat.MaturityType = 708 and mat.Approved = 3  
   and n.Account_AccountID = a.AccountID  
  
  )tblInitialMaturity on tblInitialMaturity.noteid = n1.noteid   
  where acc1.IsDeleted <> 1  
  and n1.Account_AccountID = a.AccountID  
  
 --select  
 -- isnull(n.ActualPayoffDate, isnull(  
 --  case when @Column='Initial or Actual Payoff Date' then n.ActualPayoffDate   
 --  when @Column='Expected Maturity Date' then n.ExpectedMaturityDate   
 --  when @Column='Extended Maturity Date #1' then n.ExtendedMaturityScenario1   
 --  when @Column='Extended Maturity Date #2' then n.ExtendedMaturityScenario2   
 --  when @Column='Extended Maturity Date #3' then n.ExtendedMaturityScenario3   
 --  when @Column='Open Prepayment Date' then n.OpenPrepaymentDate   
 --  when @Column='Fully Extended Maturity Date' then n.FullyExtendedMaturityDate end,  
  
 -- (Select TOP 1 mat.[SelectedMaturityDate]  
 --  from [CORE].Maturity mat  
 --  INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
 --  INNER JOIN (Select   
 --  (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
 --  MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
 --  INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
 --  INNER JOIN [CORE].[Account] accSub ON accSub.AccountID = n.Account_AccountID  
 --  where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')  
 --  and accSub.AccountID = a.AccountID  
 --  GROUP BY n.Account_AccountID,EventTypeID  
 -- ) sEvent  
 -- ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID)  
 -- ))  
  
  
 )  
  
)a  
order by a.NoteID,a.[Date]  asc  
  
  
    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
   
END






