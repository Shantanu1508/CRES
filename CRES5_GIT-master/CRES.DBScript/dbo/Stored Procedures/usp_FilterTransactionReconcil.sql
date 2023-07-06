-- Procedure


--[dbo].usp_FilterTransactionReconcil  '1/2/1900' ,'12/21/2121 12:00:00 AM','','19-0039',0,0,''

--[dbo].usp_FilterTransactionReconcil  '1/2/1900' ,'12/21/2121 12:00:00 AM','','19-0039',1,0,''
CREATE  PROCEDURE [dbo].usp_FilterTransactionReconcil 
@StartDate Date=null,
@EndDate Date=null,
@Delta nvarchar(500),
--@CRENoteID nvarchar(500),
@CREDealID nvarchar(500),
@IsReconciled bit=false,
@IsException bit=false,
@TransactionType nvarchar(500)

AS
BEGIN

SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare @sql varchar(max)=''
Declare @sql1 varchar(max)=''


 IF OBJECT_ID('tempdb..#TempSplitTransaction') IS NOT NULL                                               
 DROP TABLE #TempSplitTransaction

CREATE TABLE #TempSplitTransaction   
(    
 SplitTransactionid [uniqueidentifier] NULL 
 )  


 set @sql1=' insert into #TempSplitTransaction select distinct	tr.SplitTransactionid from cre.TranscationReconciliation tr left join cre.note n on n.NoteID=tr.NoteID left join cre.Deal d on d.DealID=n.DealID where '
 if(@IsReconciled=0)
BEGIN
	set @sql1= @sql1 + 'tr.PostedDate  is null '
END
else
BEGIN
	set @sql1= @sql1 + 'tr.PostedDate  is not null '
END

if(@IsException=1)
BEGIN
	set @sql1= @sql1 + ' and tr.Exception  is not null '
END

if(@CREDealID<>'')
BEGIN
	set @sql1= @sql1 + ' and  d.CREDealID in (' + @CREDealID + ') '
END
	

if(@Delta<>'')
Begin
	if(@Delta='Less than and equal to 0.1')		
		set @sql1= @sql1 + ' and  abs(isnull(tr.ActualDelta,0))  between 0 and 0.1'
	if(@Delta='From 0.1 to 0.99')	
		set @sql1= @sql1 + ' and  abs(isnull(tr.ActualDelta,0)) between 0.1 and 0.99'
	if(@Delta='Between 1 and 50')		
		set @sql1= @sql1 + ' and  abs(isnull(tr.ActualDelta,0)) between 1 and 50'
	if(@Delta='Greater than 50')		
		set @sql1= @sql1 + ' and  abs(isnull(tr.ActualDelta,0)) > 50'
END

if(@StartDate<>'' and @EndDate<>'')
BEGIN
	set @sql1=	@sql1 +' and isnull(tr.DateDue,''1900-01-02'') between ''' + CAST(@StartDate  AS VARCHAR(100))   + ''' and ''' + CAST(@EndDate AS   VARCHAR(100))  +''' '
END
if(@TransactionType<>'' )
BEGIN
	set @sql1= @sql1 + ' and  tr.TransactionType in (' + @TransactionType + ')'
END 
set @sql1= @sql1 + ' and tr.SplitTransactionid  is not null'
set @sql1= @sql1 + ' and tr.Deleted=0'

EXEC (@sql1);
print (@sql1);


set @sql=
'select	
tr.Transcationid,
tr.SplitTransactionid,
tr.[DateDue],
tr.RemittanceDate,		
d.CREDealID,
d.DealID,
d.DealName,
n.CRENoteID,
n.NoteID,
ac.Name as NoteName,
tr.TransactionType,	
Round(tr.ServicingAmount,2) as ServicingAmount,
Round(tr.CalculatedAmount,2) as CalculatedAmount,
Case
		--	When ISNULL(tr.OverrideValue,0)=0  Then Round(tr.Delta,2)
			When ISNULL(tr.OverrideValue,0)=0  Then Round((ISNULL(tr.ServicingAmount,0)-ISNULL(tr.CalculatedAmount,0)),2)
			--When ISNULL(tr.OverrideValue,0)<>0  Then Round(tr.OverrideValue-tr.CalculatedAmount,2)
			When ISNULL(tr.OverrideValue,0)<>0  Then Round(ISNULL(tr.OverrideValue,0)-ISNULL(tr.CalculatedAmount,0),2)
			END as Delta,
Round(ISNULL(tr.Adjustment,0),2) as Adjustment,
Round(ISNULL(tr.ActualDelta,tr.Delta),2) as ActualDelta,
Round(ISNULL(tr.AddlInterest,0),2) as AddlInterest,
Round(ISNULL(tr.TotalInterest,0),2) as TotalInterest,
ISNULL(tr.M61Value,0) as M61Value ,
ISNULL(tr.ServicerValue,0) as ServicerValue,
ISNULL(tr.Ignore,0) as Ignore,
tr.OverrideValue,
tr.Exception,
tr.comments,
case when tr.PostedDate is null then 1
	when tr.PostedDate is not null then 0
END  as isRecon,
tr.TransactionDate,
sm.ServicerName as SourceType,
tr.OverrideReason,
lk.name OverrideReasonText,
tr.InterestAdj
from cre.TranscationReconciliation tr
left join cre.note n on n.NoteID=tr.NoteID
left join cre.Deal d on d.DealID=n.DealID	
inner join [CRE].[ServicerMaster] sm on sm.ServicerMasterID=tr.ServcerMasterID	
INNER JOIN core.Account ac ON ac.AccountID = n.Account_AccountID	
 Left Join Core.Lookup lk on tr.OverrideReason=lk.LookupID
where '

if(@IsReconciled=0)
BEGIN
	set @sql= @sql + 'tr.PostedDate  is null '
END
else
BEGIN
	set @sql= @sql + 'tr.PostedDate  is not null '
END

if(@IsException=1)
BEGIN
	set @sql= @sql + ' and tr.Exception  is not null '
END

if(@CREDealID<>'')
BEGIN
	set @sql= @sql + ' and  d.CREDealID in (' + @CREDealID + ') '
END
		

if(@Delta<>'')
Begin
	if(@Delta='Less than and equal to 0.1')		
		set @sql= @sql + ' and  abs(isnull(tr.ActualDelta,0))  between 0 and 0.1'
	if(@Delta='From 0.1 to 0.99')	
		set @sql= @sql + ' and  abs(isnull(tr.ActualDelta,0)) between 0.1 and 0.99'
	if(@Delta='Between 1 and 50')		
		set @sql= @sql + ' and  abs(isnull(tr.ActualDelta,0)) between 1 and 50'
	if(@Delta='Greater than 50')		
		set @sql= @sql + ' and  abs(isnull(tr.ActualDelta,0)) > 50'
END

if(@StartDate<>'' and @EndDate<>'')
BEGIN
	set @sql=	@sql +' and isnull(tr.DateDue,''1900-01-02'') between ''' + CAST(@StartDate  AS VARCHAR(100))   + ''' and ''' + CAST(@EndDate AS   VARCHAR(100))  +''' '
END
if(@TransactionType<>'' )
BEGIN
	set @sql= @sql + ' and  tr.TransactionType in (' + @TransactionType + ')'
END 


set @sql= @sql + 'and tr.Deleted=0  or tr.SplitTransactionid in (select SplitTransactionid from #TempSplitTransaction) order by d.CREDealID,n.CRENoteID,tr.TransactionType,tr.[DateDue]'


print (@sql);
EXEC (@sql);


SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
GO

