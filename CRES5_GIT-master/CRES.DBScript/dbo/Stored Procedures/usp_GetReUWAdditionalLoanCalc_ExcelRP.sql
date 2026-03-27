  
CREATE Procedure [dbo].[usp_GetReUWAdditionalLoanCalc_ExcelRP]  
(  
  @JsonReportParamters NVARCHAR(MAX)=null  
)  
AS  
BEGIN  
 SET NOCOUNT ON;    
  
 --===============================================
	If(OBJECT_ID('tempdb..#tempReadJsonData') Is Not Null)
		Drop Table #tempReadJsonData
	
	CREATE TABLE #tempReadJsonData(Date date)
	INSERT INTO #tempReadJsonData (Date)
	SELECT * FROM OPENJSON(@JsonReportParamters)  WITH (Date Date '$.Date');

	declare @currentdatetime datetime	
	SET @currentdatetime = (Select date from #tempReadJsonData);
	--===============================================

If(OBJECT_ID('tempdb..#tblNPC') Is Not Null)
	Drop Table #tblNPC
	

CREATE TABLE #tblNPC(
noteid	UNIQUEIDENTIFIER,
PeriodEndDate	Date,
EndingBalance	decimal(28,15),
AllInCouponRate decimal(28,15),
ScheduledPrincipal decimal(28,15),
AnalysisID UNIQUEIDENTIFIER
)

INSERT into #tblNPC (noteid,PeriodEndDate,EndingBalance,AllInCouponRate,ScheduledPrincipal,AnalysisID)
select n.NoteID,npc.PeriodEndDate,npc.EndingBalance,npc.AllInCouponRate,npc.ScheduledPrincipal,npc.AnalysisID
from cre.noteperiodiccalc npc  
Inner join core.account acc on acc.accountid = npc.AccountID
Inner join cre.note n on n.account_accountid = acc.accountid
 and acc.AccounttypeID = 1
--inner join cre.Note n on npc.NoteID=n.NoteID   
--INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID 
where acc.IsDeleted <> 1 
and npc.AnalysisID='C10F3372-0FC2-4861-A9F5-148F1F80804F' 
and npc.[MONTH] is not null 
and npc.PeriodEndDate=EOMONTH(@currentdatetime)



---====================================================================================
If(OBJECT_ID('tempdb..#tbltransactionentry') Is Not Null)
	Drop Table #tbltransactionentry

CREATE TABLE #tbltransactionentry
(
	NoteID UNIQUEIDENTIFIER,	
	Date date,
	Amount  decimal(28,15)
)
INSERT INTO #tbltransactionentry (noteid,date,Amount)
select n.NoteID,EOMONTH(tr.Date) as [date] ,SUM(tr.amount) as amount  
from cre.TransactionEntry tr  
INNER JOIN [CORE].[Account] acc ON acc.AccountID = tr.AccountID
inner join cre.Note n on n.Account_AccountID = acc.AccountID
 
where tr.AnalysisID='C10F3372-0FC2-4861-A9F5-148F1F80804F'  
and [type] = 'Interestpaid' 
group by n.NoteID, EOMONTH(tr.Date) 
having EOMONTH(tr.Date)=EOMONTH(@currentdatetime)
---====================================================================================




select d.CREDealID as [Deal ID]
,d.DealName as [Deal Name] 
,n.creNoteID as [Note ID]
,acc.Name as [Note Name]
,npc.PeriodEndDate  as [Period End Date]
,npc.EndingBalance as [Ending Balance]
,npc.AllInCouponRate as [Interest Rate]  

,trint.[InterestPaid] as [Interest Paid]
,npc.ScheduledPrincipal as [Scheduled Principal Paid]
,(trint.[InterestPaid] + npc.ScheduledPrincipal)*12 as [Annualized Debt Service]  

from #tblNPC npc  
inner join cre.Note n on npc.NoteID=n.NoteID   
INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID   
Inner Join cre.deal d on d.dealid = n.dealid
left join( 
	select tr.NoteID, tr.[Date] as PeriodEndDate ,tr.amount as [InterestPaid]
	from #tbltransactionentry tr
)trint on npc.noteid = trint.noteid and npc.PeriodEndDate=trint.PeriodEndDate 

where acc.IsDeleted <> 1  and d.IsDeleted <> 1 
and npc.AnalysisID='C10F3372-0FC2-4861-A9F5-148F1F80804F' 
and d.[Status] = 323
and npc.PeriodEndDate=EOMONTH(@currentdatetime)
--and n.creNoteID='2230'  



END


