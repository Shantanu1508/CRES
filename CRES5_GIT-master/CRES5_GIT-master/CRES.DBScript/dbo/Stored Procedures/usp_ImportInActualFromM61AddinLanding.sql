
CREATE PROCEDURE [dbo].[usp_ImportInActualFromM61AddinLanding]
@BatchLogGenericID int,
@CreatedBy nvarchar(256)

AS
BEGIN



--Ignore records if not configured
Update [IO].[L_M61AddinLanding] set [Status] = 'Ignore' ,Comment = 'Transaction Types is not configured' 
where M61AddinLandingID in (
	
	Select M61AddinLandingID from [IO].[L_M61AddinLanding] 
	where TransactionTypeID not in (Select TransactionTypesID from cre.TransactionTypes where Calculated =  4)
	and [Status] = 'InProcess'
	and TableName = 'M61.Tables.Actuals' 
	and BatchLogGenericID = @BatchLogGenericID

)


--Ignore records if flag set to EnableM61Calculations = N
Update [IO].[L_M61AddinLanding] set [Status] = 'Ignore' ,Comment = 'Enable M61 Calculations flag on accounting tab is not set to Y' 
where M61AddinLandingID in (	
	Select mch.M61AddinLandingID
	from [IO].[L_M61AddinLanding] mch
	inner join cre.note n on n.crenoteid = mch.Noteid
	where TableName = 'M61.Tables.Actuals' 
	and BatchLogGenericID = @BatchLogGenericID
	and [Status] = 'InProcess'
	and ISNULL(EnableM61Calculations,3) = 4
)


--------------------------------------------------------
Declare @ServicerMasterID int;
SET @ServicerMasterID = (Select ServicerMasterID from cre.servicermaster where ServicerName = 'M61Addin')



IF OBJECT_ID('tempdb..[#TempServicingLog]') IS NOT NULL                                         
 DROP TABLE [#TempServicingLog]  

Create table [#TempServicingLog]
(   
	NoteID	UNIQUEIDENTIFIER NULL,
	CreNoteID	[nvarchar](256) NULL,
	DueDate	[datetime] NULL	,
	TransactionDate [datetime] NULL,
	RemitDate [datetime] NULL,
	[Value]	[decimal](28, 15) NULL	,
	TransactionTypeID	int NULL,
	ServicerMasterID int null,
	[Status] nvarchar(256) NULL,
	[Comment] nvarchar(max) NULL,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[UpdatedDate] [datetime] NULL,
	
	TransactionName [nvarchar](256) NULL,
	[StatusType] [nvarchar](256) NULL,
	
) 

INSERT into [#TempServicingLog](NoteID,CreNoteID,DueDate,TransactionDate,RemitDate,Value,TransactionTypeID,ServicerMasterID,Status,Comment,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,TransactionName,[StatusType])

Select n.NoteID,n.crenoteid,mt.DueDate,mt.TransactionDate,mt.RemitDate,mt.Value,mt.TransactionTypeID,mt.ServicerMasterID,mt.Status
,mt.Comment,mt.CreatedBy,mt.CreatedDate,mt.UpdatedBy,mt.UpdatedDate,ty.TransactionName,'insert' as [StatusType]
from [IO].[L_M61AddinLanding] mt
inner join cre.note n on n.crenoteid =mt.noteid
left join CRE.TransactionTypes ty on ty.TransactionTypesID = mt.TransactionTypeID
Where [Status] = 'InProcess'
and TableName = 'M61.Tables.Actuals' 
and BatchLogGenericID = @BatchLogGenericID


Update [#TempServicingLog] set [#TempServicingLog].[StatusType] = 'update'
from(
	Select 
	a.noteid,
	a.TransactionName,
	a.DueDate,
	a.ServicerMasterID
	from [#TempServicingLog] a
	inner join cre.NoteTransactionDetail te on te.noteid = a.noteid 
	and a.DueDate = te.RelatedtoModeledPMTDate 
	and a.TransactionName = te.TransactionTypeText 
	and a.ServicerMasterID = te.ServicerMasterID
)b
where 
[#TempServicingLog].noteid = b.noteid
and [#TempServicingLog].TransactionName = b.TransactionName
and [#TempServicingLog].DueDate = b.DueDate
and [#TempServicingLog].ServicerMasterID = b.ServicerMasterID
--==============================================================================


INSERT into cre.NoteTransactionDetail(NoteID,TransactionDate,Amount,RelatedtoModeledPMTDate,ServicingAmount,CalculatedAmount,Delta,M61Value,ServicerValue,Ignore,OverrideValue,comments,ServicerMasterID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,TransactionTypeText,RemittanceDate,Exception,Adjustment,ActualDelta,OverrideReason,TransactionType,Orig_ServicerMasterID) --TranscationReconciliationID,PostedDate
Select 
tre.NoteID,	
tre.TransactionDate,	
tre.Value as Amount,
tre.DueDate,
0 as ServicingAmount,
tre.Value as CalculatedAmount,
0 as Delta,   ----(0 - tre.Value) as Delta, ------(ServicingAmount - CalculatedAmount)---
0 as M61Value,	---1 as M61Value,
0 as ServicerValue,
0 as Ignore,
0 as OverrideValue,
null comments,
tre.ServicerMasterID,	
tre.CreatedBy,
getDate(),
tre.CreatedBy,
getDate(),
tre.TransactionName as TransactionTypeText,
tre.RemitDate,
null as Exception,
0 as Adjustment,
0 as ActualDelta,	---((0 - tre.Value) + 0) as ActualDelta,  ------(Delta + Adjustment)---
null as OverrideReason,
tre.TransactionTypeID,
tre.ServicerMasterID as Orig_ServicerMasterID
from [#TempServicingLog] tre  
Where tre.[StatusType] = 'insert'





Update cre.NoteTransactionDetail set 
cre.NoteTransactionDetail.ServicingAmount = b.ServicingAmount,
cre.NoteTransactionDetail.CalculatedAmount = b.CalculatedAmount,
cre.NoteTransactionDetail.Delta = b.Delta,
cre.NoteTransactionDetail.Adjustment = b.Adjustment,
cre.NoteTransactionDetail.ActualDelta = b.ActualDelta,
cre.NoteTransactionDetail.Orig_ServicerMasterID = b.ServicerMasterID
from(
	Select 
	a.noteid,
	a.TransactionName,
	a.DueDate,
	a.ServicerMasterID,	
	0 as ServicingAmount,
	a.Value as CalculatedAmount,
	0 as Delta,	--(0 - a.Value) as Delta, ------(ServicingAmount - CalculatedAmount)---
	0 as Adjustment,
	0 as ActualDelta	---((0 - a.Value) + 0) as ActualDelta  ------(Delta + Adjustment)---
	from [#TempServicingLog] a  
	Where a.[StatusType] = 'update'	
	and a.ServicerMasterID = @ServicerMasterID
)b
where cre.NoteTransactionDetail.noteid = b.noteid
and cre.NoteTransactionDetail.TransactionTypeText = b.TransactionName
and cre.NoteTransactionDetail.RelatedtoModeledPMTDate = b.DueDate
and cre.NoteTransactionDetail.ServicerMasterID = b.ServicerMasterID

------======================================
----Send note to calculation
--Declare @CalcPriority nvarchar(256)

--IF((Select COUNT(Distinct NoteId) from [IO].L_M61AddinLanding Where [Status] = 'InProcess' and TableName = 'M61.Tables.Actuals' and BatchLogGenericID = @BatchLogGenericID ) > 20)
--BEGIN
--	SET @CalcPriority = 'Batch'
--END
--ELSE
--BEGIN
--	SET @CalcPriority = 'Real Time'
--END


--declare @TableTypeCalculationRequests TableTypeCalculationRequests
	
--insert into @TableTypeCalculationRequests(NoteId,StatusText,UserName,PriorityText,AnalysisID)
--Select NoteId,'Processing',@CreatedBy,@CalcPriority,an.AnalysisID 
--From Cre.Note,core.Analysis an
--where CRENoteID in  (Select NoteId from [IO].L_M61AddinLanding Where [Status] = 'InProcess' and TableName = 'M61.Tables.Actuals' and BatchLogGenericID = @BatchLogGenericID)
--and an.name = 'Default'
	
--exec [dbo].[usp_QueueNotesForCalculation] @TableTypeCalculationRequests,@CreatedBy,@CreatedBy 
----=================================================



Update [IO].[L_M61AddinLanding] set [Status] = 'Imported' 
where TableName = 'M61.Tables.Actuals' 
and BatchLogGenericID = @BatchLogGenericID 
and [Status] = 'InProcess' 
and ServicerMasterID = @ServicerMasterID
  



End





