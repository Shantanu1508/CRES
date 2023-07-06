  
--[HBOT].[usp_GetSingleEntityByIntentForNoteAndDealByDateRange]  'ID','2230','name','Seventy Rainey',null,'6/8/2018','TotalFunded'  
-- [HBOT].[usp_GetSingleEntityByIntentForNoteAndDealByDateRange]  null,null,null,null,'10/12/2020',null,'LiborRateOnDate'  
-- [HBOT].[usp_GetSingleEntityByIntentForNoteAndDealByDateRange]  null,null,name,'Ritz Carlton North Hills','4/5/2019','11/30/2020','DealLastPaydownFunding'  
-- [HBOT].[usp_GetSingleEntityByIntentForNoteAndDealByDateRange]  null,null,name,'Northstar ALTO Portfolio',null,null,'DealLastPaydownFunding'  
  
CREATE PROCEDURE [HBOT].[usp_GetSingleEntityByIntentForNoteAndDealByDateRange]    
@NoteNature  nvarchar(256),  
@NoteValue  nvarchar(256),  
@DealNature  nvarchar(256),  
@DealValue  nvarchar(256),  
@StartDate Date,  
@EndDate Date,  
@Intent  nvarchar(256)    
  
AS    
BEGIN    
    SET NOCOUNT ON;    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
Declare @Analysisid uniqueidentifier = (SELECT AnalysisID from CORE.Analysis WHERE Name='Default');  
Declare @Date date,@Value decimal(28,15),@DealName nvarchar(256);  
Declare @TodaysDate date = (SELECT CAST(getdate() as Date));  
  
IF(@Intent ='TotalInterestPaid')  
 BEGIN  
 IF(@StartDate=@TodaysDate and @EndDate =@TodaysDate)  
 BEGIN  
  Select DealName, SUM(SumInterestAmount) as Amount  
  FROM(  
   Select d.DealName,tr.noteid,n.crenoteid,SUM(tr.Amount) as SumInterestAmount  
   from cre.transactionEntry Tr  
   inner join cre.note n on n.noteid=tr.noteid   
   inner join cre.deal d on d.DealID = n.DealID  
   inner join core.account acc on acc.AccountID = n.Account_AccountID  
   where tr.analysisID = @Analysisid and tr.[Type] in ('InterestPaid')  
   --and tr.date <= CAST(getdate() as date)  
   and d.dealname = @DealValue --IIF(@DealNature = 'name',d.DealName,d.credealid) = @DealValue  
   and acc.IsDeleted<>1  
   group by tr.noteid,n.crenoteid, d.DealName  
   )a  
  group by DealName  
 END  
 ELSE  
 BEGIN  
  Select DealName, SUM(SumInterestAmount) as Amount, convert(varchar,@StartDate,101) as StartDate, convert(varchar,@EndDate,101)  as EndDate  
  FROM(  
  Select d.DealName,tr.noteid,n.crenoteid,SUM(tr.Amount) as SumInterestAmount  
  from cre.transactionEntry Tr  
  inner join cre.note n on n.noteid=tr.noteid   
  inner join cre.deal d on d.DealID = n.DealID  
  where tr.analysisID =  @Analysisid and tr.[Type] in ('InterestPaid')  
  and d.dealname = @DealValue  --IIF(@DealNature = 'name',d.DealName,d.credealid) = @DealValue  
  and Date >= @StartDate  
  and Date <= @EndDate  
  group by tr.noteid,n.crenoteid, d.DealName  
  )a  
  group by DealName  
 END  
END  
  
IF(@Intent = 'LiborRateOnDate')  
BEGIN  
 Select top 1 @Date= [Date],@Value = [Value]  
 from core.indexes   
 where [Date]  <= @StartDate and IndexType=245   
 and IndexesMasterID in (select IndexesMasterID from core.IndexesMaster where indexesname= 'Default Index')  
 order by [Date] desc  
  SELECT FORMAT(@Date,'MM/dd/yyyy') as Date,@Value as Value;  
END  
  
IF(@Intent = 'TotalFundedAmountOnDate')  
 BEGIN  
  SELECT Deal, SUM(b.FundingAmount + b.InitialFundingAmount) as Amount,  
  convert(varchar,@StartDate,101)  as [Date]  
  FROM(  
   SELECT Deal,FundingAmount,SUM(n.InitialFundingAmount) as InitialFundingAmount  
   FROM cre.note n   
   inner join cre.deal dd on dd.DealId = n.DealID  
   inner join core.account acc on acc.AccountID = n.Account_AccountID  
   left join(  
      select  d.DealName as [Deal],  
      d.DealID,  
      SUM(df.Amount) as [FundingAmount]  
      from cre.deal d   
      inner join cre.dealfunding df on df.Dealid = d.Dealid  
      left join core.Lookup l on l.lookupid = df.purposeid  
      where d.dealname = @DealValue --IIF(@DealNature = 'name',d.DealName,d.credealid) = @DealValue  
      and l.Name <> 'Note Transfer'  
      and df.Date <= @StartDate  
      and d.IsDeleted <>1  
      and df.Amount>0  
      group by dealname,d.DealId  
     )a on a.DealId = n.DealID  
  WHERE  acc.IsDeleted<>1 and n.InitialFundingAmount>1  
  and dd.DealName = @DealValue --IIF(@DealNature = 'name',dd.DealName,dd.credealid) = @DealValue  
  group by deal,FundingAmount  
  )b  
  group by deal  
END  
  
IF(@Intent = 'DealCurrentDebtBalance')  
 BEGIN  
  SELECT Deal,SUM(EndingBalance) as [SubDebtBalance] ,convert(varchar,@EndDate,101) as [Date]  
  FROM(  
   SELECT a.Deal,ISNULL(EndingBalance,0) as EndingBalance  
   ,ROW_NUMBER() Over (Partition by npc.noteid Order by npc.noteid,npc.PeriodEndDate desc) as rno  
   from cre.NotePeriodicCalc npc  
   left join ( SELECT n.NoteId,d.DealName as Deal, n.lienposition,n.priority from cre.note n   
      inner join core.Account acc on acc.AccountID = n.Account_AccountID  
      inner join cre.deal d on d.DealID = n.DealID  
      where d.dealname = @DealValue  --IIF(@DealNature = 'name',d.DealName,d.credealid) = @DealValue  
      and acc.IsDeleted<>1  
      and d.IsDeleted<>1  
      and n.lienposition <> 353  
      and n.priority <> 1  
      )a on a.NoteID = npc.NoteID  
   WHERE npc.AnalysisID = @Analysisid  
   and cast(PeriodEndDate as date) <= @EndDate  
   and a.NoteID = npc.NoteID  
  )b WHERE rno=1  
  group by Deal  
 END  
  
 IF(@Intent = 'DealLastPaydownFunding')  
 BEGIN  
  IF(@StartDate=@TodaysDate and @EndDate =@TodaysDate)  
  BEGIN  
   SELECT top 1 @DealName= d.DealName, @Date= df.Date,@Value = df.Amount, @StartDate=null,@EndDate=null  
   from CRE.DealFunding df  
   left join cre.deal d on d.DealID = df.DealID  
   inner join core.lookup l on l.LookupID = df.PurposeID  
   where d.dealname = @DealValue  --IIF(@DealNature = 'name',d.DealName,d.credealid) = @DealValue  
   and d.IsDeleted<>1  
   and l.Name='Paydown'  
   and df.Applied=1  
   and df.Date<= @TodaysDate  
   order by date desc  
  
	  IF(@DealName is not null)
	  BEGIN
	   SELECT @DealName as DealName, FORMAT(@Date,'MM/dd/yyyy') as Date,@Value as Amount, @StartDate as StartDate, @EndDate as EndDate;  
	  END
  END  
  ELSE  
  BEGIN  
   SELECT d.DealName as Deal,SUM(ISNULL(df.Amount,0)) as Amount,null as Date, convert(varchar,@StartDate,101) as StartDate,convert(varchar,@EndDate,101) as EndDate  
   from CRE.DealFunding df  
   left join cre.deal d on d.DealID = df.DealID  
   inner join core.lookup l on l.LookupID = df.PurposeID  
   where d.dealname = @DealValue  --IIF(@DealNature = 'name',d.DealName,d.credealid) = @DealValue  
   and d.IsDeleted<>1  
   and l.Name='Paydown'  
   and df.Date >= @StartDate  
   and df.Date <= @EndDate  
   group by d.DealName  
  END  
END  
  
 IF(@Intent = 'OpenPrepaymentDateNoteList')  
 BEGIN  
  select CRENoteID as NoteID, acc.Name as NoteName,d.DealName,convert(varchar,n.OpenPrepaymentDate,101) as OpenPrepaymentDate  
  from cre.note n  
  inner join core.account acc on acc.AccountID=n.Account_AccountID  
  inner join cre.deal d on d.DealID=n.DealID  
  where acc.IsDeleted<>1  
  and d.IsDeleted<>1  
  and OpenPrepaymentDate>=@StartDate  
  and OpenPrepaymentDate <= @EndDate  
  order by OpenPrepaymentDate,NoteID  
 END  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END 