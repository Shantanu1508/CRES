Create PROCEDURE [dbo].[usp_IsValidUnreconcileTranscation]
@TmpUnrecon TableTypeTranscationRecon READONLY
AS
BEGIN
Declare @TempUnreconCount int
Declare @TempMainRecords int

IF OBJECT_ID('tempdb..#TempUnrecon') IS NOT NULL                                               
 DROP TABLE #TempUnrecon  

CREATE TABLE #TempUnrecon    
(    
 SplitTransactionid [uniqueidentifier] NULL  ,
  RecordCount int
 )    

 IF OBJECT_ID('tempdb..#TempMainRecords') IS NOT NULL                                               
 DROP TABLE #TempMainRecords
 CREATE TABLE #TempMainRecords    
(    
 SplitTransactionid [uniqueidentifier] NULL  ,
  RecordCount int
 )

 
 insert into #TempUnrecon 
	select tbltr.SplitTransactionid,count(tbltr.SplitTransactionid) as RecCount
	from @TmpUnrecon tm
	left join(
		Select Transcationid,SplitTransactionid  
		from cre.TranscationReconciliation 
		where Transcationid in ( Select Transcationid from @TmpUnrecon)
	)tbltr on tbltr.Transcationid = tm.Transcationid
	where tbltr.SplitTransactionid is not null
	group by tbltr.SplitTransactionid





 INSERT into #TempMainRecords  
  SELECT SplitTransactionid  ,count(SplitTransactionid) cnt
FROM cre.TranscationReconciliation 
WHERE SplitTransactionid in ( 
		
	SELECT Distinct tbltr.SplitTransactionid
	from @TmpUnrecon tm
	left join(
	Select Transcationid,SplitTransactionid  
	from cre.TranscationReconciliation 
	where Transcationid in ( Select Transcationid from @TmpUnrecon)
	)tbltr on tbltr.Transcationid = tm.Transcationid
	where tbltr.SplitTransactionid is not null
	group by tbltr.SplitTransactionid

)
group by SplitTransactionid


Select n.CRENoteID,TransactionType,convert(varchar(50),RemittanceDate,101) as RemittanceDate from cre.TranscationReconciliation tt left join cre.Note n on tt.noteid=n.noteid  where SplitTransactionid in (
Select SplitTransactionid
from (
Select 
un.SplitTransactionid as SplitTransactionid,
mn.RecordCount-un.RecordCount as Delta
 from #TempUnrecon un full join #TempMainRecords mn on un.SplitTransactionid=mn.SplitTransactionid
 )z
 where Delta>0
  ) and Transcationid not in (select Transcationid from @TmpUnrecon)
  group by CRENoteID,TransactionType,RemittanceDate


END

