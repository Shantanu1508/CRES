    
    
  --  [dbo].[usp_Get_TREACR_DisclosureME]  '{"Date":"07/30/2021"}'  
CREATE Procedure [dbo].[usp_Get_TREACR_DisclosureME]    
(    
  @JsonReportParamters NVARCHAR(MAX)=null    
)    
AS    
BEGIN    
 SET NOCOUNT ON;    
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
 --US Eastern time zone    
 --declare @TimeZoneName nvarchar(256)='US Eastern Standard Time'    
 --declare @currentdatetime datetime = [dbo].[ufn_GetTimeByTimeZoneName](getdate(),@TimeZoneName)    
 ------------------------------------================----------------------------  
 If(OBJECT_ID('tempdb..#tempReadJsonData') Is Not Null)  
  Drop Table #tempReadJsonData  
   
 CREATE TABLE #tempReadJsonData(Date date)  
 INSERT INTO #tempReadJsonData (Date)  
 SELECT * FROM OPENJSON(@JsonReportParamters)  WITH (Date Date '$.Date');  
  
 declare @currentdatetime datetime   
 SET @currentdatetime = (Select date from #tempReadJsonData);  
-----------------------------------===============================-----------------------  
   
declare @tblbls as table(  
noteid UNIQUEIDENTIFIER,  
EndingBalance decimal(28,15)  
)  
  
Declare @c_NoteID UNIQUEIDENTIFIER  
  
   
IF CURSOR_STATUS('global','CursorBls')>=-1  
BEGIN  
 DEALLOCATE CursorBls  
END  
  
DECLARE CursorBls CURSOR   
for  
(  
 select nn.noteid  
 From CRE.Note nn    
 inner join cre.deal dd on dd.dealid = nn.dealid    
 Inner join core.account acc1 on acc1.accountid = nn.account_accountid    
 left join cre.FinancingSourcemaster fs1 on fs1.FinancingSourcemasterID = nn.FinancingSourceID    
 where acc1.IsDeleted <> 1    
 and fs1.FinancingSourceName in ('TRE ACR Portfolio')   
 and (nn.ActualPayOffDate is null OR nn.ActualPayOffDate >= @currentdatetime)    
)  
OPEN CursorBls   
FETCH NEXT FROM CursorBls  
INTO @c_NoteID  
  
WHILE @@FETCH_STATUS = 0  
BEGIN  
  
 INSERT INTO @tblbls(noteid,EndingBalance)  
 select np.noteid,np.EndingBalance  
 from [CRE].[DailyInterestAccruals] np      
 where Date = CAST(@currentdatetime as Date) and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'  
 and np.noteid = @c_NoteID  
        
FETCH NEXT FROM CursorBls  
INTO @c_NoteID  
END  
CLOSE CursorBls     
DEALLOCATE CursorBls  
  
  
  
  
--=======================================  
     
Declare @Disclosure table (DealName nvarchar(256)    
,NoteName nvarchar(256)    
,NoteID nvarchar(256)    
,ClosingDate nvarchar(256)    
,DealType nvarchar(256)    
,PropertyType nvarchar(256)    
,InitialFundingBalance decimal(28,15)    
,RemainingUnfundedCommitment decimal(28,15)    
,TotalLoanCommitment decimal(28,15)    
,CurrentLoanBalance decimal(28,15)    
,Price decimal(28,15)    
,FMV decimal(28,15)    
,SortOrder int identity(1,1)    
)    
    
insert into @Disclosure    
Select DealName    
,NoteName    
,'ACR'+REPLICATE('0',6-LEN(RTRIM(NoteID))) + RTRIM(NoteID) as NoteID    
,Cast(Format(ClosingDate,'MM/dd/yyyy') as nvarchar(256)) as ClosingDate    
,DealType    
,PropertyType    
,ROUND(InitialFundingBalance,2) as InitialFundingBalance    
--,ROUND((TotalLoanCommitment - CurrentLoanBalance) - PIKPrincipalFunding ,2) as RemainingUnfundedCommitment    
,ROUND((TotalLoanCommitment) - (CurrentLoanBalance - PIKPrincipalFunding) ,2) as RemainingUnfundedCommitment   
,ROUND(TotalLoanCommitment,2) as TotalLoanCommitment    
,ROUND(CurrentLoanBalance,2) as CurrentLoanBalance    
,ROUND(Price,2) as Price    
,ROUND(ISNULL((CurrentLoanBalance * Price)/100,0),2) as FMV    
From(    
    
Select     
d.dealname as DealName    
,acc.name as NoteName    
,n.crenoteid as NoteID    
,isnull(n.NoteTransferDate, n.ClosingDate) as ClosingDate    
--,dm.DealTypeName DealType    
,d.BS_CollateralStatusDesclatest as DealType  
--,c.PropertyType     
,d.PropertyTypeBS as PropertyType  
  
,(CASE WHEN n.initialfundingamount = 0.01 THEN tblFundingClosing.[value] Else n.initialfundingamount END) as InitialFundingBalance    
,null RemainingUnfundedCommitment    
,adj.TotalCurrentAdjustedCommitment as TotalLoanCommitment    
,tblCurrBls.CurrentLoanBalance as CurrentLoanBalance     
,b.[Value] as Price      
,null FMV    
,ISNULL(tblPIKFund.PIKPrincipalFunding,0) as PIKPrincipalFunding  
  
From CRE.DEAL d    
inner join CRE.Note n on n.dealid = d.dealid    
inner join core.account acc on acc.accountid = n.account_accountid    
left join cre.FinancingSourcemaster fs on fs.FinancingSourcemasterID = n.FinancingSourceID    
left join cre.DealTypeMaster dm on dm.DealTypeMasterID = d.DealTypeMasterID    
left join (  
 Select Noteid,Date,Value  
  From(  
   Select na.Noteid,na.Date,na.Value ,Row_number() over(Partition by na.Noteid order by na.date desc) as rno  
   from [CRE].[NoteAttributesbyDate] na  
   inner join cre.TransactionTypes ty on ty.TransactionTypesID = na.ValueTypeID  
   where ty.TransactionName = 'MarketPrice'  
   and cast(na.Date as date) <=cast(@currentdatetime as date)  
  )a where rno =  1) b  
on b.Noteid=n.crenoteid    
left join     
(    
 --Select CAST(noteid as nvarchar(256)) NoteID,TotalCurrentAdjustedCommitment     
 --from dw.UwNoteBI     
 --where noteid in (Select crenoteid from cre.note where ISNUMERIC(crenoteid) = 1)  
  
 Select CRENoteID as NoteID,NoteAdjustedTotalCommitment as TotalCurrentAdjustedCommitment,NoteTotalCommitment  
 From(     
  SELECT d.CREDealID  
  ,n.CRENoteID  
  ,Date as Date  
  ,nd.Type as Type  
  ,NoteAdjustedTotalCommitment  
  ,NoteTotalCommitment  
  ,nd.NoteID  
  ,ROW_NUMBER() OVER (PARTITION BY nd.NoteID order by nd.NoteID,nd.RowNo desc ,Date) as rno,  
  nd.Rowno  
  from cre.NoteAdjustedCommitmentMaster nm  
  left join cre.NoteAdjustedCommitmentDetail nd on nd.NoteAdjustedCommitmentMasterID = nm.NoteAdjustedCommitmentMasterID  
  right join cre.deal d on d.DealID=nm.DealID  
  Right join cre.note n on n.NoteID = nd.NoteID  
  inner join core.account acc on acc.AccountID = n.Account_AccountID  
  where d.IsDeleted<>1 and acc.IsDeleted<>1  
  and ISNUMERIC(n.crenoteid) = 1  
  and [Date] <= CAST(@currentdatetime as Date)  
 )a  
 where rno =  1     
) adj  on adj.NoteID =  n.CRENoteID    
--left join     
--(    
-- Select Distinct b.dealid,(CASE when cnt > 1 Then 'Multiple' Else b.PropertyType end) as PropertyType  From(   Select a.dealid,a.PropertyType,count(a.PropertyType) Over (Partition By a.dealid order by a.dealid) as cnt   From(    Select Distinct dd.dealid,  
--l.name as PropertyType     from cre.deal dd    inner join cre.property pp on pp.deal_dealid = dd.dealid    left join core.lookup l on l.lookupid = pp.PropertyType    where pp.PropertyType is not null    )a  )b    
--)c     
--on c.dealid =d.dealid    
    
left join(    
    
  Select noteid,EndingBalance as CurrentLoanBalance from @tblbls  
 -- Select nn.noteid,    
 --ISNULL((select SUM((ISNULL(EndingBalance,0)))      
 --  from [CRE].[NotePeriodicCalc] np      
 --  where np.noteid = nn.noteid  and PeriodEndDate = CAST(@currentdatetime as Date) and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'),0)         
 -- as CurrentLoanBalance   
  
 -- From CRE.Note nn    
 -- inner join cre.deal dd on dd.dealid = nn.dealid    
 -- Inner join core.account acc1 on acc1.accountid = nn.account_accountid    
 -- left join cre.FinancingSourcemaster fs1 on fs1.FinancingSourcemasterID = nn.FinancingSourceID    
 -- where acc1.IsDeleted <> 1    
 -- and fs1.FinancingSourceName in ('TRE ACR Portfolio')   
 -- and (nn.ActualPayOffDate is null OR nn.ActualPayOffDate >= @currentdatetime)    
    
)as tblCurrBls on tblCurrBls.noteid = n.noteid    
Left Join(   
 Select n.noteid,(SUM(Amount)*-1) as PIKPrincipalFunding 
 from cre.transactionEntry tr  
 Inner join core.account acc on acc.accountid = tr.AccountID     
 left join cre.note n on n.account_accountid = acc.accountid  
 where analysisid = 'c10f3372-0fc2-4861-a9f5-148f1f80804f'  and acc.accounttypeid = 1
 and [Type] in ('PIKPrincipalFunding','PIKPrincipalPaid')  
 and date <= CAST(@currentdatetime as Date)  
 group by n.noteid  
)tblPIKFund on tblPIKFund.noteid = n.noteid  
Left Join(  
 Select n.noteid,fs.value  
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
 where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0  
 and LPurposeID.name <> 'Capitalized Interest'  
 and fs.date = n.closingdate  
)tblFundingClosing on tblFundingClosing.noteid =n.NoteID  
    
where acc.IsDeleted <> 1    
and fs.FinancingSourceName in ('TRE ACR Portfolio') --'AFLAC US',  
and (n.ActualPayOffDate is null OR n.ActualPayOffDate >= @currentdatetime)  
and n.ClosingDate <= Cast(@currentdatetime as date)  
  
)a   
--where a.CurrentLoanBalance >= 1  
order by DealName    
    
--add total colum at the bottom    
insert into @Disclosure    
select 'Portfolio Total' DealName    
,null NoteName     
,null NoteID     
,null ClosingDate     
,null DealType     
,null PropertyType     
,Sum(ISNULL(InitialFundingBalance,0)) as  InitialFundingBalance    
,Sum(ISNULL(RemainingUnfundedCommitment,0)) as RemainingUnfundedCommitment    
,Sum(ISNULL(TotalLoanCommitment,0)) as  TotalLoanCommitment    
,Sum(ISNULL(CurrentLoanBalance,0)) as CurrentLoanBalance      
,null Price     
,Sum(ISNULL(FMV,0) ) as FMV      
from @Disclosure    
    
    
select DealName 'Deal Name'    
,NoteName as 'Note Name'    
,NoteID as 'Note ID'    
,ClosingDate as 'Closing Date'    
,DealType as 'Deal Type'    
,PropertyType as 'Property Type'    
,InitialFundingBalance as 'Initial Funding Balance'    
,RemainingUnfundedCommitment as 'Remaining Unfunded Commitment'    
,TotalLoanCommitment as 'Total Loan Commitment'    
,CurrentLoanBalance as 'Current Loan Balance'    
,Price     
,FMV    
from @Disclosure     
    
order by Sortorder   
  
 select CONVERT(varchar,@currentdatetime,101) as [Date];  
  
END  
