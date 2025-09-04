 -- [dbo].[usp_Get_QuarterlyPortfolioTransactionDetailActivity]'{"Date":"12/30/2020"}'  
  
CREATE Procedure [dbo].[usp_Get_QuarterlyPortfolioTransactionDetailActivity]  
(  
  @JsonReportParamters NVARCHAR(MAX)=null  
)  
AS  
BEGIN  
  SET NOCOUNT ON;  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
 /*--read paramter from the json  
 DECLARE @SheetName NVARCHAR(256),  
   @SheetJsonParamters NVARCHAR(MAX),  
   @SheetJsonParamtersRoot NVARCHAR(MAX),  
   @Client_ID NVARCHAR(10),@SOURCE NVARCHAR(10)  
   
 Select @SheetName=SheetName From App.ReportFileSheet where ReportFileSheetID=2  
   
 SELECT @SheetJsonParamters=[value]  
    FROM OPENJSON (@JsonReportParamters,'$.Root') where [key]=@SheetName  
 print @SheetJsonParamters  
 IF (@SheetJsonParamters IS NOT NULL)  
 BEGIN  
     select @Client_ID=value from OPENJSON(@SheetJsonParamters) where [key]='CLIENT_ID'  
     select @SOURCE=value from OPENJSON(@SheetJsonParamters) where [key]='SOURCE'  
 END  
 --  
 */  
   
---------to read data from jsonparameter---------==============  
If(OBJECT_ID('tempdb..#tempReadJsonData') Is Not Null)  
Drop Table #tempReadJsonData  
CREATE TABLE #tempReadJsonData(Date date)  
INSERT INTO #tempReadJsonData (Date)  
SELECT * FROM OPENJSON(@JsonReportParamters)  WITH (Date Date '$.Date');  
---------------==================================-------------------------  
   
Declare @AnalysisID uniqueidentifier = (Select AnalysisId from core.Analysis where name='Default');  
DECLARE @today date =  (SELECT Date FROM #tempReadJsonData); --DATEADD(month, DATEDIFF(month, 0, @mydate), 0);  
declare @startdate date = DATEFROMPARTS(YEAR(@today), MONTH(@today)-((MONTH(@today)-1)%3),1);  
declare @enddate date = DATEADD(QUARTER, 1, @startdate);  
declare @endquartermonth int = MONTH(@enddate);  --(DATEADD(D,-1,@enddate));  
declare @startquartermonth int = MONTH(@startdate);  
declare @todaymonth int = MONTH(@today);  
declare @todayenddateofmonth int = DATEPART(d,@today);  
declare @lastdateoftodaymonth int = datepart(d,dateadd(month,1+datediff(month,0,@today),-1)); --DATEADD(month, DATEDIFF(month, 0, @mydate), 0);  
declare @previousmonthofendquarter int = DATEPART(MONTH,DATEADD(Month,-1,@enddate));  
declare @colstartdate date, @colenddate date;  
  
set @colstartdate = (DATEADD(D,-1,@startdate));  
set @colenddate = (DATEADD(D,-1,@enddate));  
--select @today as today,@startdate as startdate,@enddate as enddate,@endquartermonth as endquartermonth,  
--@startquartermonth as startquartermonth,@todaymonth as todaymonth,@todayenddateofmonth as todayenddateofmonth,  
--@lastdateoftodaymonth as lastdateoftodaymonth,@previousmonthofendquarter as previousmonthofendquarter  
  
IF(@todaymonth = @startquartermonth OR @todaymonth = @endquartermonth OR @todaymonth = @previousmonthofendquarter)  
BEGIN  
 IF(@lastdateoftodaymonth <> @todayenddateofmonth)  
 BEGIN  
  set @startdate = (SELECT DATEADD(qq, DATEDIFF(qq, 0, @today) - 1, 0));  
  set @enddate =(SELECT DATEADD(dd, -1, DATEADD(qq, DATEDIFF(qq, 0, @today), 0)));  
  set @colstartdate = (DATEADD(D,-1,@startdate));  
     set @colenddate = @enddate;  
 END  
END  
ELSE  
BEGIN  
 set @startdate = (SELECT DATEADD(qq, DATEDIFF(qq, 0, @today) - 1, 0));  
 set @enddate =(SELECT DATEADD(dd, -1, DATEADD(qq, DATEDIFF(qq, 0, @today), 0)));  
 set @colstartdate = (DATEADD(D,-1,@startdate));  
 set @colenddate = @enddate;  
END  
  
-------------===================temp table transactionentry----------------========================  
If(OBJECT_ID('tempdb..#tempTransactionEntry') Is Not Null)  
Drop Table #tempTransactionEntry  
  
Create Table #tempTransactionEntry(  
   NoteID uniqueidentifier,  
   Date date,  
   Amount decimal(28,15),  
   Type nvarchar(256),  
   AnalysisID uniqueidentifier,  
   FeeName nvarchar(256)  
);  
INSERT INTO #tempTransactionEntry (NoteID,Date,Amount,Type,AnalysisID,FeeName)  
SELECT n.NoteID,Date,Amount,Type,AnalysisID,FeeName  
FROM CRE.TransactionEntry tr  
Inner join core.account acc on acc.accountid = tr.AccountID     
left join cre.note n on n.account_accountid = acc.accountid  
WHERE AnalysisID = @AnalysisID  and acc.AccounttypeID = 1
and Type in ('InitialFunding','FundingOrRepayment','PIKPrincipalFunding','ScheduledPrincipalPaid','PIKPrincipalPaid','Balloon')  
and date >= @startdate and date <= @colenddate  
  
  
---=====================================Maturity table for fullpayoff===============---------------------  
If(OBJECT_ID('tempdb..#tempMaturity') Is Not Null)  
Drop Table #tempMaturity  
  
Create Table #tempMaturity(  
 NoteID uniqueidentifier,  
 MaturityDate date  
);  
INSERT INTO #tempMaturity(NoteID,MaturityDate)  
Select n1.noteid,ISNULL(n1.ActualPayOffDate,ISNULL(currMat.MaturityDate,n1.FullyExtendedMaturityDate)) as currMaturityDate  
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
     where EventTypeID = 11  
     and acc.IsDeleted = 0    
     and eve.StatusID = 1  
     GROUP BY n.Account_AccountID,EventTypeID      
    ) sEvent      
    ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.StatusID = 1  
    INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
    INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID    
    Left JOin Core.lookup lMaturityType on lMaturityType.lookupid = mat.MaturityType  
    Left JOin Core.lookup lApproved on lApproved.lookupid = mat.Approved   
    where mat.MaturityDate > getdate()  
    and lApproved.name = 'Y'  
  )a where a.rno = 1  
 )currMat on currMat.noteid = n1.noteid  
 where acc1.IsDeleted <> 1  
  
 --select n.Noteid,Convert(varchar,  
--  (ISNULL(n.ActualPayoffDate,InitialMaturity.MaturityDate)),101) as Maturity FROM cre.Note n  
--  left join (  
--   Select n.noteid,mat.MaturityDate    
--   from [CORE].Maturity mat    
--   INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId    
--   inner join core.account acc on acc.accountid = e.accountid  
--   inner join cre.note n on n.account_accountid =acc.accountid   
--   INNER JOIN (Select     
--    (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,    
--    MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve    
--    INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID    
--    inner join cre.Deal ddd on ddd.dealid = n.dealid  
--    INNER JOIN [CORE].[Account] accSub ON accSub.AccountID = n.Account_AccountID    
--    where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')    
--    and accSub.isdeleted <> 1  
--    GROUP BY n.Account_AccountID,EventTypeID    
--   ) sEvent    
--   ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
--  )InitialMaturity on InitialMaturity.noteid = n.noteid  
  
  
 ------------==========for creating columns except dynamic columns=======================------------------  
 If(OBJECT_ID('tempdb..#tempAllcolumns') Is Not Null)  
Drop Table #tempAllcolumns  
  
Create Table #tempAllcolumns(  
 [Deal ID] nvarchar(256),  
 [Note ID] nvarchar(256),  
 [Deal Name] nvarchar(256),  
 [Note Name] nvarchar(256),   [Status] nvarchar(256),  
 [Debt Type] nvarchar(256),  
 [Financing Source] nvarchar(256),  
 [Date] nvarchar(256),  
 [Amount] decimal(28,15),  
 [M61 TransactionType] nvarchar(256),  
 [Category] nvarchar(256)  
);  
  
INSERT INTO #tempAllcolumns ([Deal ID],[Note ID],[Deal Name],[Note Name],[Status],[Debt Type],[Financing Source],[Date],[Amount],[M61 TransactionType],[Category])  
SELECT  d.CREDealID,  
  n.CRENoteID,  
  d.DealName,  
  acc.Name,  
  nm.[LoanStatus],  
     lDebtID.Name,  
  lFinancingID.FinancingSourceName,  
  CONVERT(varchar,a.Date,101),  
  a.Amount,  
  a.Type,  
  a.Category  
    
  
FROM CRE.Note n   
left join CRE.deal d on n.DealId = d.DealID  
left join core.account acc on acc.AccountID = n.Account_AccountID  
left join NoteMatrixBI nm on nm.NoteID = n.CRENoteID  
left join core.lookup lDebtID on lDebtID.LookupID = n.DebtTypeID  
left join [CRE].[FinancingSourceMaster] lFinancingID on lFinancingID.FinancingSourceMasterID = n.FinancingSourceID  
left join (  
   select NoteID, -1*SUM(isnull(Amount,0)) as Amount,Date,Type,'Originations' as Category FROM #tempTransactionEntry Where type='InitialFunding' group by NoteID,Date,Type  
      
    UNION ALL  
  
   SELECT NoteID,SUM(isnull(Amount,0)) as Amount,Date,Type,'Future Funding' as Category FROM (  
   select te.NoteID, -1*SUM(isnull(Amount,0)) as Amount,Date,Type FROM #tempTransactionEntry te  
   left join #tempMaturity tm on tm.NoteID = te.NoteID  
   Where type ='FundingOrRepayment' and tm.MaturityDate <> te.Date and Amount < 0 and isnull(FeeName,'a') <> ('COVID') group by te.NoteID,Date,Type  
   UNION ALL  
   select NoteID, -1*SUM(isnull(Amount,0)) as Amount,Date,Type FROM #tempTransactionEntry Where type ='PIKPrincipalFunding' and isnull(FeeName,'a') <> ('COVID') group by NoteID,Date,Type  
         )b group by b.NoteID,Date,Type  
  
   UNION ALL  
  
   SELECT NoteID,SUM(isnull(Amount,0)) as Amount,Date,Type,'Partial Repayments' as Category FROM (  
   select te.NoteID,-1*SUM(isnull(Amount,0)) as Amount,Date,Type FROM #tempTransactionEntry te  
   left join #tempMaturity tm on tm.NoteID = te.NoteID  
   Where type = 'FundingOrRepayment' and Amount > 0 and tm.MaturityDate <> te.Date  
   group by te.NoteID,Date,Type  
   UNION ALL  
   select NoteID,-1*SUM(isnull(Amount,0)) as Amount,Date,Type FROM #tempTransactionEntry Where type = 'ScheduledPrincipalPaid' group by NoteID,Date,Type  
    )a group by a.NoteID,Date,Type  
     
   UNION ALL  
  
   SELECT z.NoteID,-1*SUM(isnull(z.Amount,0)) as Amount,Date,'Balloon' as Type,'Full Payoff' as Category  
   FROM (  
    select t.NoteID, -1*SUM(isnull(Amount,0)) as Amount,Date,'Balloon' as Type FROM #tempTransactionEntry t  
    Where type in ('Balloon')   
    group by t.NoteID,Date,Type  
  
    UNION ALL  
  
    select t.NoteID, -1*sum(isnull(Amount,0)) as Amount,Date,'Balloon' as Type  
    FROM #tempTransactionEntry t  
    left join #tempMaturity tm on tm.NoteID = t.NoteID  
    Where type in ('FundingOrRepayment') and t.Date = tm.MaturityDate  
    group by t.NoteID,Date,Type  
   )z group by z.NoteID,Date,Type  
  
   UNION ALL  
    SELECT NoteID,-1*SUM(isnull(Amount,0)) as Amount,Date,Type,'COVID PIK Funding' as Category   
       FROM #tempTransactionEntry Where type ='PIKPrincipalFunding' and isnull(FeeName,'a') = ('COVID') group by NoteID,Date,Type  
      
   UNION ALL  
   SELECT NoteID,-1*SUM(isnull(Amount,0)) as Amount,Date,Type,'COVID PIK Paydown' as Category   
    FROM #tempTransactionEntry Where type ='PIKPrincipalPaid' and isnull(FeeName,'a') = ('COVID') group by NoteID,Date,Type  
    ) a on a.NoteID = n.NoteID  
where d.IsDeleted<>1  
and acc.IsDeleted<>1  
and ISNUMERIC(n.crenoteid) = 1   
----------================final table=========-----------  
  
select * from #tempAllcolumns;  
  
select CONVERT(varchar,@startdate,101) + ',' + CONVERT(varchar,@colenddate,101) as [Date];  
  
  
  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END

