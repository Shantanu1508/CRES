--  [dbo].[usp_Get_QuarterlyPortfolioInvestmentActivity]'{"Date":"06/30/2021"}'  
  
CREATE Procedure [dbo].[usp_Get_QuarterlyPortfolioInvestmentActivity]  
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
and Type in ('InitialFunding','FundingOrRepayment','PIKPrincipalFunding','ScheduledPrincipalPaid','Amortization','Balloon','PIKPrincipalPaid')  
and date >= @startdate and date <= @colenddate  
  
----------==========================temp table for quarter startdate ending bal-------------------===================  
If(OBJECT_ID('tempdb..#tempEndingBalance') Is Not Null)  
Drop Table #tempEndingBalance  
  
Create Table #tempEndingBalance(  
 NoteID uniqueidentifier,  
 PeriodEndDate date,  
 EndingBalance decimal(28,15)  
);  
  
INSERT INTO #tempEndingBalance(NoteID,PeriodEndDate,EndingBalance)  
select Distinct n.noteid,PeriodEndDate,  
(CASE WHEN (n.InitialFundingAMount = 0.01 and ISNULL(np.EndingBalance,0) <> 0) THEN ISNULL(np.EndingBalance,0) - ISNULL(n.InitialFundingAMount,0)  
 ELSE ISNULL(np.EndingBalance,0)  
 END  
 ) EndingBalance  
from [CRE].[NotePeriodicCalc] np  
Inner join core.account acc on acc.accountid = np.AccountID
Inner join cre.note n on n.account_accountid = acc.accountid
inner join cre.Deal dd on dd.dealid = n.dealid  
where  PeriodEndDate >= @colstartdate and PeriodEndDate <= @colenddate  
and AnalysisID = @AnalysisID   and acc.AccounttypeID = 1
    
  
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
     and eve.statusID = 1  
     GROUP BY n.Account_AccountID,EventTypeID      
    ) sEvent      
    ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.statusID = 1  
    INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
    INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID    
    Left JOin Core.lookup lMaturityType on lMaturityType.lookupid = mat.MaturityType  
    Left JOin Core.lookup lApproved on lApproved.lookupid = mat.Approved   
      
    where mat.MaturityDate > getdate()  
    and lApproved.name = 'Y'  
  )a where a.rno = 1  
 )currMat on currMat.noteid = n1.noteid  
 where acc1.IsDeleted <> 1  
  
---=====================================Funding Schedule table for===============---------------------  
  
If(OBJECT_ID('tempdb..#tempFF') Is Not Null)  
Drop Table #tempFF  
  
Create Table #tempFF(  
 NoteID uniqueidentifier,  
 Date date,  
 value decimal(28,15),  
 PurposeText nvarchar(256),  
 FeeName nvarchar(256)  
);  
  
INSERT INTO #tempFF(NoteID,Date,value,PurposeText,FeeName)  
Select    
n.NoteID  
,fs.[Date]  
,fs.Value  
,(CASE WHEN LPurposeID.Name = 'Note Transfer' THEN 'Note Transfer' ELSE 'All' end)  as PurposeText ,  
tblfeename.FeeName  
  
from [CORE].FundingSchedule fs  
INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId  
INNER JOIN   
(        
 Select   
  (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
  MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID  
  from [CORE].[Event] eve  
  INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
  INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
  where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')    
  and acc.IsDeleted = 0  
  and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)  
  GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID  
) sEvent  
  
ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID  
left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID   
INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
left Join (   
 select Distinct te.NoteID,te.date,FeeName  
 FROM #tempTransactionEntry te  
 Where type ='FundingOrRepayment'    
)tblfeename on tblfeename.noteid = n.noteid and fs.date = tblfeename.date  
where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0  
and LPurposeID.Name <> 'Amortization'  
--and fs.date >= '01/01/2021' and fs.date <= '03/31/2021'  
and (fs.date <= ISNULL(n.ActualPayoffDate,n.fullyextendedmaturitydate) and (fs.date >= @startdate and fs.date <= @colenddate ) )  
  
  
--=========================================================  
  
  
---------------=====for creating column headers for startdate ending balance===========------------------------  
If(OBJECT_ID('tempdb..#tempEndingBalanceDateColumn') Is Not Null)  
Drop Table #tempEndingBalanceDateColumn  
  
Create Table #tempEndingBalanceDateColumn(  
 CRENoteID nvarchar(256)  
);  
  
DECLARE @StartColumnName nvarchar(256), @QuarterColName nvarchar(100), @EndColumnName nvarchar(256);  
 set @StartColumnName = '[' + CAST(FORMAT(@colstartdate,'MM/dd/yyyy') as nvarchar(256)) + ' _Balance]';  
 set @EndColumnName = '[' + CAST(FORMAT(@colenddate,'MM/dd/yyyy') as nvarchar(256)) + ' _Balance]';  
 set @QuarterColName = 'Quarterly Change';  
DECLARE @startdatecoladd NVARCHAR(200);  
SET @startdatecoladd = 'ALTER TABLE #tempEndingBalanceDateColumn ADD ';  
SET @startdatecoladd += @EndColumnName + ' nvarchar(256) NULL,  ';  
SET @startdatecoladd += @StartColumnName + ' nvarchar(256) NULL,  ';  
SET @startdatecoladd += '['+ CAST(@QuarterColName AS NVARCHAR(100)) +'] NVARCHAR(100) NULL';  
  
EXEC sys.sp_executesql @startdatecoladd;  
  
  
INSERT  INTO #tempEndingBalanceDateColumn  
 SELECT n.CRENoteID,CAST(b.EndingBalance as decimal(28,2)) , CAST(a.EndingBalance as decimal(28,2)),CAST(isnull(b.EndingBalance,0) -isnull(a.EndingBalance,0) as decimal(28,2)) FROM  
 cre.note n   
 inner join core.account acc on acc.AccountID=n.Account_AccountID  
 left join(  
    Select NoteID, sum(isnull(EndingBalance,0)) as EndingBalance from #tempEndingBalance where PeriodEnddate = @colstartdate group by NoteID  
   )a on a.NoteID = n.NoteID  
 left join(  
    Select NoteID, sum(isnull(EndingBalance,0)) as EndingBalance from #tempEndingBalance where PeriodEnddate =@colenddate group by NoteID  
   )b on b.NoteID = n.NoteID  
 where acc.IsDeleted<>1  
   
  
 ------------==========for creating columns except dynamic columns=======================------------------  
 If(OBJECT_ID('tempdb..#tempNondynamiccolumns') Is Not Null)  
Drop Table #tempNondynamiccolumns  
  
Create Table #tempNondynamiccolumns(  
 [Deal ID] nvarchar(256),  
 [Note ID] nvarchar(256),  
 [Deal Name] nvarchar(256),  
 [Note Name] nvarchar(256),  
 [Status] nvarchar(256),  
 [Debt Type] nvarchar(256),  
 [Financing Source] nvarchar(256),  
 Originations decimal(28,15),  
 [Future Funding] decimal(28,15),  
 [Partial Repayments] decimal(28,15),  
 [Full Payoff] decimal(28,15),  
 [COVID PIK Funding] decimal(28,15),  
 [COVID PIK Paydown] decimal(28,15),  
 [Refinances (New Deal)] decimal(28,15),  
 [Refinances (Old Deal)] decimal(28,15),  
 [Note Sale & Repurchase] decimal(28,15),  
 Total decimal(28,15)  
);  
  
INSERT INTO #tempNondynamiccolumns ([Deal ID],[Note ID],[Deal Name],[Note Name],[Status],[Debt Type],[Financing Source],Originations,[Future Funding],[Partial Repayments],  
         [Full Payoff],[COVID PIK Funding],[COVID PIK Paydown],[Refinances (New Deal)],[Refinances (Old Deal)],[Note Sale & Repurchase],Total)  
SELECT  d.CREDealID,  
  n.CRENoteID,  
  d.DealName,  
  acc.Name,  
  nm.[LoanStatus],  
     lDebtID.Name,  
  lFinancingID.FinancingSourceName,  
  (CASE WHEN lFinancingID.FinancingSourceName in ('Co-Fund','Note Sale','3rd Party Owned') THEN 0 ELSE ROUND(tbloriginations.Amount,2) END) ,  
  (CASE WHEN lFinancingID.FinancingSourceName in ('Co-Fund','Note Sale','3rd Party Owned') THEN 0 ELSE ROUND(tblfuturefunding.Amount,2) END),  
  (CASE WHEN lFinancingID.FinancingSourceName in ('Co-Fund','Note Sale','3rd Party Owned') THEN 0 ELSE ROUND(tblpartialrepay.Amount,2) END),  
  (CASE WHEN lFinancingID.FinancingSourceName in ('Co-Fund','Note Sale','3rd Party Owned') THEN 0 ELSE ROUND((tblfullpayoff.Amount * -1 ),2) END),  
  ROUND(tblCovidfund.Amount,2) ,  
  ROUND((tblCovidpaydown.Amount * -1 ) ,2) ,  
  nullif(0,''),  --manual  
  nullif(0,''),  --manual  
  --nullif(0,''),  --manual  
  ROUND(tblFFNoteTran.Amount,2),  --manual  
  
  (CASE WHEN  lFinancingID.FinancingSourceName in ('Co-Fund','Note Sale','3rd Party Owned') THEN IIF(isnull(tblCovidfund.Amount,0)+isnull(tblCovidpaydown.Amount,0) = 0,0,isnull(tblCovidfund.Amount,0)+isnull(tblCovidpaydown.Amount,0))  
       ELSE  IIF(isnull(tbloriginations.Amount,0)+isnull(tblfuturefunding.Amount,0)+isnull(tblpartialrepay.Amount,0)+isnull(tblfullpayoff.Amount,0)+isnull(tblCovidfund.Amount,0)+isnull(tblCovidpaydown.Amount,0) = 0,null,  
    isnull(tbloriginations.Amount,0)+isnull(tblfuturefunding.Amount,0)+isnull(tblpartialrepay.Amount,0)+isnull(tblfullpayoff.Amount,0)+isnull(tblCovidfund.Amount,0)+isnull(tblCovidpaydown.Amount,0))  
     END)  
FROM CRE.Note n   
left join CRE.deal d on n.DealId = d.DealID  
left join core.account acc on acc.AccountID = n.Account_AccountID  
left join NoteMatrixBI nm on nm.NoteID = n.CRENoteID  
left join core.lookup lDebtID on lDebtID.LookupID = n.DebtTypeID  
left join [CRE].[FinancingSourceMaster] lFinancingID on lFinancingID.FinancingSourceMasterID = n.FinancingSourceID  
left join (  
   select NoteID, -1*SUM(isnull(Amount,0)) as Amount FROM #tempTransactionEntry   
   Where type='InitialFunding' and ROUND(Amount,2) <> -0.01  
   group by NoteID  
    ) tbloriginations on tbloriginations.NoteID = n.NoteID   
left join (  
   SELECT z.NoteID,-1*SUM(isnull(z.Amount,0)) as Amount  
   FROM (  
    select t.NoteID, -1*SUM(isnull(Amount,0)) as Amount FROM #tempTransactionEntry t  
    Where type in ('Balloon')   
    group by t.NoteID  
  
    UNION ALL  
  
    select t.NoteID, -1*sum(isnull(Amount,0)) as Amount  
    FROM #tempTransactionEntry t  
    left join #tempMaturity tm on tm.NoteID = t.NoteID  
    Where type in ('FundingOrRepayment') and t.Date = tm.MaturityDate  
    group by t.NoteID   
   )z group by z.NoteID  
    ) tblfullpayoff on tblfullpayoff.NoteID = n.NoteID  
left join (  
   SELECT NoteID,SUM(Amount) as Amount   
   FROM (  
    --select te.NoteID, -1*SUM(isnull(Amount,0)) as Amount FROM #tempTransactionEntry te  
    --left join #tempMaturity tm on tm.NoteID = te.NoteID  
    --Where type ='FundingOrRepayment' and tm.MaturityDate <> te.Date and Amount < 0 and isnull(FeeName,'a') <> ('COVID') group by te.NoteID  
      
    Select fs.Noteid,SUM(fs.Value) as Amount   
    from #tempFF fs  
    left join #tempMaturity tm on tm.NoteID = fs.NoteID  
    where fs.PurposeText = 'All' and fs.value > 0  
    and tm.MaturityDate <> fs.Date   
    and isnull(FeeName,'a') <> ('COVID')   
    group by fs.Noteid  
  
    UNION ALL  
     
    select NoteID, -1*SUM(isnull(Amount,0)) as Amount FROM #tempTransactionEntry Where type ='PIKPrincipalFunding' and isnull(FeeName,'a') <> ('COVID') group by NoteID  
         )b group by b.NoteID  
)tblfuturefunding on tblfuturefunding.NoteID = n.NoteID   
  
left join (  
   SELECT NoteID,SUM(Amount) as Amount   
   FROM (      
    Select fs.Noteid,SUM(fs.Value) as Amount   
    from #tempFF fs  
    left join #tempMaturity tm on tm.NoteID = fs.NoteID  
    where fs.PurposeText = 'Note Transfer' and fs.value > 0  
    and tm.MaturityDate <> fs.Date   
    and isnull(FeeName,'a') <> ('COVID')   
    group by fs.Noteid      
         )b group by b.NoteID  
)tblFFNoteTran on tblFFNoteTran.NoteID = n.NoteID   
  
left join (  
   SELECT NoteID,SUM(Amount) as Amount FROM (  
   select te.NoteID,-1*SUM(isnull(Amount,0)) as Amount FROM #tempTransactionEntry te  
   left join #tempMaturity tm on tm.NoteID = te.NoteID  
   Where type = 'FundingOrRepayment' and Amount > 0 and tm.MaturityDate <> te.Date  
   group by te.NoteID  
   UNION ALL  
   select NoteID,-1*SUM(isnull(Amount,0)) as Amount FROM #tempTransactionEntry Where type = 'ScheduledPrincipalPaid' group by NoteID  
    )a group by a.NoteID  
    ) tblpartialrepay on tblpartialrepay.NoteID = n.NoteID   
  
left join (  
   select NoteID, -1*SUM(isnull(Amount,0)) as Amount FROM #tempTransactionEntry Where type in ('PIKPrincipalFunding') and FeeName = 'COVID' group by NoteID  
    ) tblCovidfund on tblCovidfund.NoteID = n.NoteID  
left join (  
   select NoteID, SUM(isnull(Amount,0)) as Amount FROM #tempTransactionEntry Where type in ('PIKPrincipalPaid') and FeeName  = 'COVID' group by NoteID  
    ) tblCovidpaydown on tblCovidpaydown.NoteID = n.NoteID  
  
where d.IsDeleted<>1  
and acc.IsDeleted<>1  
and ISNUMERIC(n.crenoteid) = 1   
----------================final table=========-----------  
  
If(OBJECT_ID('tempdb..#TemporaryTable') Is Not Null)  
Drop Table #TemporaryTable  
  
SELECT * INTO #TemporaryTable   
FROM (  
  select * from #tempNondynamiccolumns tn join #tempEndingBalanceDateColumn td on td.CRENoteID = tn.[Note ID]  
  )a  
  
ALTER TABLE #TemporaryTable DROP COLUMN CRENoteID;  
  
select * from #TemporaryTable;  
  
select CONVERT(varchar,@startdate,101) + ',' + CONVERT(varchar,@colenddate,101) as [Date];  
  
  
  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END

