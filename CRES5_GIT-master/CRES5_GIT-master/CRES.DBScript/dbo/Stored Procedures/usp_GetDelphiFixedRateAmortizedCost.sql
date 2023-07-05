
CREATE Procedure [dbo].[usp_GetDelphiFixedRateAmortizedCost] 
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
-- declare @currentdatetime datetime = [dbo].[ufn_GetTimeByTimeZoneName](getdate(),@TimeZoneName),@monthEndDate date,@monthStartDate date 
 --set @currentdatetime ='09/30/2020'

 ---------------=========================-----------------
 If(OBJECT_ID('tempdb..#tempReadJsonData') Is Not Null)
		Drop Table #tempReadJsonData
	
	CREATE TABLE #tempReadJsonData(Date date)
	INSERT INTO #tempReadJsonData (Date)
	SELECT * FROM OPENJSON(@JsonReportParamters)  WITH (Date Date '$.Date');

	declare @currentdatetime datetime	
	SET @currentdatetime = (Select date from #tempReadJsonData);
	---------------==============================-----------------
	declare @monthEndDate date,@monthStartDate date ;


 SELECT @monthEndDate = EOMONTH(@currentdatetime)
 if (@currentdatetime<@monthEndDate)
 BEGIN
	 set @monthEndDate= EOMONTH(dateadd(m,-1,@currentdatetime))
 END
 SELECT @monthStartDate = DATEADD(mm, DATEDIFF(mm, 0, @monthEndDate), 0)

 Declare @FutureFunding table ( 
 NoteID nvarchar(256)  
 ,value decimal(28,15)
   )
--Future funding
insert into @FutureFunding
Select  n.CRENoteID ,sum(fs.Value)
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
					--and n.crenoteid = '6114'  
					and acc.IsDeleted = 0
					and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
					GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID

			) sEvent

	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID

	left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID
	left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID 
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	inner join cre.deal d on d.dealid = n.dealid
	join cre.FinancingSourcemaster fn on fn.FinancingSourcemasterID = n.FinancingSourceID
	left join core.lookup lcurrency on lcurrency.lookupid = ISNULL(acc.BaseCurrencyID,187) and lcurrency.ParentID = 29
	--and n.crenoteid='6114'  
	where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0
	and fn.FinancingSourceName like '%Delphi%'
	and ISNUMERIC(n.crenoteid) = 1
	--and fs.[date]=CAST(@monthEndDate as date) --'02/07/2020'
	and fs.[date]>=CAST(@monthStartDate as date) and fs.[date]<=CAST(@monthEndDate as date) --'02/07/2020'
	and (n.ActualPayOffDate is null OR n.ActualPayOffDate >= Cast(@currentdatetime as date))
	and fs.Value>0
	and fs.PurposeID not in (629)
	group by n.CRENoteID
--
Declare @Disclosure table ( 
 [Date] nvarchar(256)
 ,DealID nvarchar(256)
 ,NoteID nvarchar(256)  
,DealName nvarchar(256)
,NoteName nvarchar(256)  
,ClosingDate nvarchar(256)  
,InitialMaturityDate nvarchar(256)  
,TotalCommitment decimal(28,15)
,LoanOriginationFee decimal(28,15)
,futureFunding decimal(28,15)
,PIKInterest decimal(28,15)
 ,BeginningPrincipalBalance decimal(28,15)
 ,ScheduledPrincipalAmortization decimal(28,15)
 ,EndingPrincipalBalance decimal(28,15)
 ,DeferredFees  decimal(28,15)
 ,CleanCost decimal(28,15)
 ,CurrentMonthAmortizationDeferredFees decimal(28,15)
 ,CumulativeAmortization decimal(28,15)
 ,AmortizedCost decimal(28,15)
 ,AmortizedPrice decimal(28,15)
 ,FinancingSource nvarchar(256)  
 ,Sortorder int
 ,PIKPrinPaid decimal(28,15)
)  
  
insert into @Disclosure  
Select 
Cast(Format(@monthEndDate,'MM/dd/yyyy') as nvarchar(256)) as [Date]
,CreDealID
,a.NoteID
,DealName  
,NoteName  
,Cast(Format(ClosingDate,'MM/dd/yyyy') as nvarchar(256)) as ClosingDate  
,Cast(Format(b.SelectedMaturityDate,'MM/dd/yyyy') as nvarchar(256)) as InitialMaturitydate
,TotalCommitment
,a.LoanOriginationFee
,ROUND(tblFF.Value,2) as FutureFunding
,ROUND(PIKInterestForThePeriod,2) as PIKInterest
,ROUND(BeginningBalance,2) as BeginningPrincipalBalance 
,ROUND(ScheduledPrincipal,2) as ScheduledPrincipalAmortization 
,ROUND(EndingBalance,2) as EndingPrincipalBalance  
,ROUND(GrossDeferredFees,2) as GrossDeferredFees  
,ROUND(CleanCost,2) as CleanCost  
,ROUND(TotalAmortAccrualForPeriod,2) as CurrentMonthAmortizationDeferredFees  
,ROUND(AccumulatedAmort,2) as CumulativeAmortization  
,ROUND(AmortizedCost,2) as AmortizedCost  
,ROUND(AmortizedCostPrice,2) as AmortizedPrice
,FinancingSource
,0  
,ROUND(PIKPrinPaid,2) as PIKPrinPaid

From(  
	Select   
	d.dealname as DealName  
	,acc.name as NoteName  
	,n.crenoteid as NoteID  
	,isnull(n.NoteTransferDate, n.ClosingDate) as ClosingDate  
	,n.InitialMaturitydate   
	,n.TotalCommitment 
	,(n.OriginationFeePercentageRP * 100) as LoanOriginationFee
	,np.PIKInterestForThePeriod
	,d.CreDealID 
	,BeginningBalance 
	,ScheduledPrincipal
	,EndingBalance
	,GrossDeferredFees
	,CleanCost
	,TotalAmortAccrualForPeriod
	,AccumulatedAmort  
	,AmortizedCost  
	,(AmortizedCostPrice*100) as AmortizedCostPrice
	,fs.FinancingSourceName as FinancingSource
	,tblPIKPriPaid.PIKPrinPaid
	From CRE.DEAL d  
	inner join CRE.Note n on n.dealid = d.dealid  
	inner join core.account acc on acc.accountid = n.account_accountid  
	left join cre.FinancingSourcemaster fs on fs.FinancingSourcemasterID = n.FinancingSourceID  
	left join [CRE].[NotePeriodicCalc] np on np.noteid = n.noteid and PeriodEndDate = CAST(@monthEndDate as Date) and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	Left Join( 
		Select noteid,(SUM(Amount)*-1) as PIKPrinPaid
		from cre.transactionEntry
		where analysisid = 'c10f3372-0fc2-4861-a9f5-148f1f80804f'
		and [Type] in ('PIKPrincipalPaid')
		--and date <= CAST(@currentdatetime as Date)
		and [date]>=CAST(@monthStartDate as date) and [date]<=CAST(@monthEndDate as date)
		group by noteid
	)tblPIKPriPaid on tblPIKPriPaid.noteid = n.noteid
	
	where acc.IsDeleted <> 1  
	and fs.FinancingSourceName like '%Delphi%'
	and (n.ActualPayOffDate is null OR n.ActualPayOffDate >= Cast(@currentdatetime as date))
	and np.[month] is not null 
)a 
join
(
	Select  n.creNoteID as NoteID,mat.maturityDate as SelectedMaturityDate,acc.StatusID
	from [CORE].Maturity mat  
	INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
	INNER JOIN   
	(          
		Select   
		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
		where EventTypeID = 11  and eve.StatusID = 1
		and acc.IsDeleted = 0  			
		GROUP BY n.Account_AccountID,EventTypeID    
	) sEvent    
	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID and e.StatusID = 1 
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
	
	where mat.maturityType = 708 
	and	mat.Approved = 3
	--Select n.creNoteID as NoteID,mat.SelectedMaturityDate,acc.StatusID
	--from [CORE].Maturity mat
	--INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
	--INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	--INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	--INNER JOIN (
	--	Select
	--	(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
	--	MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
	--	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
	--	INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
	--	where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')
	--	and acc.IsDeleted = 0
	--	GROUP BY n.Account_AccountID,EventTypeID
	--) sEvent
	--ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate and e.EventTypeID = sEvent.EventTypeID

) b
on a.NoteID=b.NoteID
left join @FutureFunding tblFF
on tblFF.NoteID =a.NoteID
where a.EndingBalance >= 1
and ISNUMERIC(a.noteID) = 1
and b.StatusID=1
order by DealName  
  
----add total colum at the bottom  

insert into @Disclosure
select 
'Total Portfolio'
,null
,null
,null  
,null  
,null  
,null  
,Sum(ISNULL(TotalCommitment,0)) TotalCommitment
,null LoanOriginationFee
,Sum(ROUND(ISNULL(FutureFunding,0),2)) FutureFunding
,Sum(ROUND(ISNULL(PIKInterest,0),2)) PIKInterest
,Sum(ROUND(ISNULL(BeginningPrincipalBalance,0),2)) BeginningPrincipalBalance
,Sum(ROUND(ISNULL(ScheduledPrincipalAmortization,0),2)) ScheduledPrincipalAmortization
,Sum(ROUND(ISNULL(EndingPrincipalBalance,0),2)) EndingBalance
,Sum(ROUND(ISNULL(DeferredFees,0),2)) DeferredFees
,Sum(ROUND(ISNULL(CleanCost,0),2)) CleanCost
,Sum(ROUND(ISNULL(CurrentMonthAmortizationDeferredFees,0),2)) CurrentMonthAmortizationDeferredFees
,Sum(ROUND(ISNULL(CumulativeAmortization,0),2)) CumulativeAmortization
,Sum(ROUND(ISNULL(AmortizedCost,0),2)) AmortizedCost
,Sum(ROUND(ISNULL(AmortizedPrice,0)*100,2)) AmortizedPrice
,null
,1
,Sum(ROUND(ISNULL(PIKPrinPaid,0),2)) PIKPrinPaid
from @Disclosure
 
  
select 
[Date] 
,DealID 
,NoteID   
,DealName 
,NoteName   
,ClosingDate   
,InitialMaturityDate   
,format(nullif(TotalCommitment,0),'#,0.00') TotalCommitment
,format(LoanOriginationFee,'#,0.00') + '%'  LoanOriginationFee
,format(nullif(BeginningPrincipalBalance,0),'#,0.00') BeginningPrincipalBalance
,format(nullif(FutureFunding,0),'#,0.00') FutureFunding
,format(nullif(PIKInterest,0),'#,0.00') PIKInterest

,(CASE WHEN PIKPrinPaid < 0 Then '('+ format(nullif(ABS(PIKPrinPaid), 0),'#,0.00')+')' ELSE '('+ format(nullif(PIKPrinPaid, 0),'#,0.00')+')' END) as PIKPaydown

,ScheduledPrincipalAmortization =(case when nullif(EndingPrincipalBalance,0) is not null then
 '('+ format(nullif(ScheduledPrincipalAmortization, 0),'#,0.00')+')' else null end)

,format(nullif(EndingPrincipalBalance,0),'#,0.00') EndingPrincipalBalance
,format(nullif(DeferredFees,0),'#,0.00') DeferredFees
,format(nullif(CleanCost,0),'#,0.00') CleanCost
,format(nullif(CurrentMonthAmortizationDeferredFees,0),'#,0.00') CurrentMonthAmortizationDeferredFees
,format(nullif(CumulativeAmortization,0),'#,0.00') CumulativeAmortization
,format(nullif(AmortizedCost,0),'#,0.00') AmortizedCost
,format(nullif(AmortizedPrice,0),'#,0.00') AmortizedPrice
,FinancingSource


from    @Disclosure
order by Sortorder,closingdate

select CONVERT(varchar,@currentdatetime,101) as [Date];


END  
