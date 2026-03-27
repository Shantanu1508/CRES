-- Procedure
-- Procedure

--[dbo].usp_FilterTransactionReconcil  '1/2/1900' ,'7/25/2124 12:00:00 AM','','',1,0,'','b0e6697b-3534-4c09-be0a-04473401ab93','1,39,2,67,68,33,30,3,34,35,4,41,59,74,5,73,72,36,31,45,63,65,61,60,70,66,6,7,40,38,64,69,71,8,9,10,37,11,12,13,26,14,15,16,58,56,44,17,18,19,48,62,49,50,51,52,53,54,20,21,57,22,23,24,55,25,47'
--[dbo].usp_FilterTransactionReconcil  '1/2/1900' ,'7/25/2124 12:00:00 AM','',"'17-1123'",1,0,'','b0e6697b-3534-4c09-be0a-04473401ab93','1,39,2,67,68,33,30,3,34,35,4,41,59,74,5,73,72,36,31,45,63,65,61,60,70,66,6,7,40,38,64,69,71,8,9,10,37,11,12,13,26,14,15,16,58,56,44,17,18,19,48,62,49,50,51,52,53,54,20,21,57,22,23,24,55,25,47'

--[dbo].usp_FilterTransactionReconcil  '1/2/1900' ,'7/25/2124 12:00:00 AM','','',0,0,'','',"'2','67','68','33','30'"
CREATE  PROCEDURE [dbo].usp_FilterTransactionReconcil 
@StartDate Date=null,
@EndDate Date=null,
@Delta nvarchar(500),
@CREDealID nvarchar(500),
@IsReconciled bit=false,
@IsException bit=false,
@TransactionType nvarchar(max),
@UserId nvarchar(50),
@FinancingSource nvarchar(max)=null ,
@StartRemitDate Date=null,
@EndRemitDate Date=null
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


 set @sql1='insert into #TempSplitTransaction select distinct	tr.SplitTransactionid from cre.TranscationReconciliation tr left join cre.note n on n.NoteID=tr.NoteID left join cre.Deal d on d.DealID=n.DealID 
  left join cre.FinancingSourceMaster fm on fm.FinancingSourceMasterID = n.financingsourceid where '
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
if(@StartRemitDate<>'' and @EndRemitDate<>'')
BEGIN
	set @sql1=	@sql1 +' and isnull(tr.RemittanceDate,''1900-01-02'') between ''' + CAST(@StartRemitDate  AS VARCHAR(100))   + ''' and ''' + CAST(@EndRemitDate AS   VARCHAR(100))  +''' '
END

if(@TransactionType<>'' )
BEGIN
	set @sql1= @sql1 + ' and  tr.TransactionType in (' + @TransactionType + ')'
END 
if(@FinancingSource<>'' )  
BEGIN  
 set @sql1= @sql1 + ' and fm.FinancingSourceMasterID in (' + @FinancingSource + ')' 

END
set @sql1= @sql1 + ' and tr.SplitTransactionid  is not null'
set @sql1= @sql1 + ' and d.isdeleted <> 1  and tr.Deleted=0'

EXEC (@sql1);
print (@sql1);


--Case		
--When ISNULL(tr.OverrideValue,0)=0  Then Round((ISNULL(tr.ServicingAmount,0)-ISNULL(tr.CalculatedAmount,0)),2)			
--When ISNULL(tr.OverrideValue,0)<>0  Then Round(ISNULL(tr.OverrideValue,0)-ISNULL(tr.CalculatedAmount,0),2)
--END as Delta,


set @sql=
'select	
tr.Transcationid,tr.SplitTransactionid,tr.[DateDue],tr.RemittanceDate,d.CREDealID,d.DealID,d.DealName,n.CRENoteID,n.NoteID,ac.Name as NoteName,tr.TransactionType,	
Round(tr.ServicingAmount,2) as ServicingAmount,
Round(tr.CalculatedAmount,2) as CalculatedAmount,
(Case 
When tr.OverrideValue is not null  Then Round(ISNULL(tr.OverrideValue,0)-ISNULL(tr.CalculatedAmount,0),2)
ELSE Round((ISNULL(tr.ServicingAmount,0)-ISNULL(tr.CalculatedAmount,0)),2)
END) as Delta,
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
tr.InterestAdj,
isnull(z.LastAccountingCloseDate,''1900-01-02'') as LastAccountingCloseDate,
(case when tr.DueDateAlreadyReconciled=1 then ''Yes''
when isnull(tr.DueDateAlreadyReconciled,0)=0 then ''No''
End ) as ''DueDateAlreadyReconciled'',
tr.UpdatedBy,
u.FirstName + '' '' + u.LastName as  UpdatedByName,
tr.WriteOffAmount,
fm.FinancingSourceName as  FinancingSource
from cre.TranscationReconciliation tr
left join cre.note n on n.NoteID=tr.NoteID
left join cre.Deal d on d.DealID=n.DealID	
left join cre.FinancingSourceMaster fm on fm.FinancingSourceMasterID = n.financingsourceid      
inner join [CRE].[ServicerMaster] sm on sm.ServicerMasterID=tr.ServcerMasterID	
INNER JOIN core.Account ac ON ac.AccountID = n.Account_AccountID	
Left Join Core.Lookup lk on tr.OverrideReason=lk.LookupID
Left join app.[user] u on  tr.UpdatedBy=u.UserID 
 Left Join (
		Select noteid,LastAccountingCloseDate from(
			Select 
			d.DealID,n.noteid,p.CloseDate as LastAccountingCloseDate	
			,ROW_NUMBER() OVER (Partition BY d.dealid,n.noteid order by d.dealid,n.noteid,p.updateddate desc) rno
			from cre.deal d
			Inner join cre.note n on n.dealid = d.dealid
			Left join (
				Select dealid,CloseDate,updateddate
				from CORE.[Period]
				where isdeleted <> 1 and CloseDate is not null
			)p on d.dealid = p.dealid 
			Where d.IsDeleted <> 1
		)a
		where a.rno = 1
	)z on tr.noteid = z.NoteID
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
	set @sql= @sql + ' and  d.CREDealID in ('+ @CREDealID + ') '
END
		

if(@Delta<>'')
Begin
	if(@Delta='Less than and equal to 0.1')		
		set @sql= @sql + ' and  abs(Round(ISNULL(tr.ActualDelta,tr.Delta),2))  between 0 and 0.1'
	if(@Delta='From 0.1 to 0.99')	
		set @sql= @sql + ' and  abs(Round(ISNULL(tr.ActualDelta,tr.Delta),2)) between 0.1 and 0.99'
	if(@Delta='Between 1 and 50')		
		set @sql= @sql + ' and  abs(Round(ISNULL(tr.ActualDelta,tr.Delta),2)) between 1 and 50'
	if(@Delta='Greater than 50')		
		set @sql= @sql + ' and  abs(Round(ISNULL(tr.ActualDelta,tr.Delta),2)) > 50'
END

if(@StartDate<>'' and @EndDate<>'')
BEGIN
	set @sql=	@sql +' and isnull(tr.DateDue,''1900-01-02'') between ''' + CAST(@StartDate  AS VARCHAR(100))   + ''' and ''' + CAST(@EndDate AS   VARCHAR(100))  +''' '
END
if(@StartRemitDate<>'' and @EndRemitDate<>'')
BEGIN
	set @sql=	@sql +' and isnull(tr.RemittanceDate,''1900-01-02'') between ''' + CAST(@StartRemitDate  AS VARCHAR(100))   + ''' and ''' + CAST(@EndRemitDate AS   VARCHAR(100))  +''' '
END
if(@TransactionType<>'' )
BEGIN
	set @sql= @sql + ' and  tr.TransactionType in (' + @TransactionType + ')'
END 

if(@UserId <>'')
BEGIN
	set @sql= @sql + ' and  tr.UpdatedBy=  ''' + @UserId + ''' '
END
if(@FinancingSource is not null )        
BEGIN        
 set @sql= @sql + ' and  fm.FinancingSourceMasterID in (' + @FinancingSource +')'        
END  
set @sql= @sql + ' and d.isdeleted <> 1 and tr.Deleted=0  or tr.SplitTransactionid in (select SplitTransactionid from #TempSplitTransaction) order by d.CREDealID,n.CRENoteID,tr.TransactionType,tr.[DateDue]'


print (@sql);
EXEC (@sql);


SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
GO

