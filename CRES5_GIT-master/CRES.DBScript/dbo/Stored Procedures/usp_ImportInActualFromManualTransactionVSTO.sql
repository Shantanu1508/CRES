CREATE PROCEDURE [dbo].[usp_ImportInActualFromManualTransactionVSTO]
@CreatedBy nvarchar(256) 

AS
BEGIN

Declare @TransactionTypeID int;
Select @TransactionTypeID = TransactionTypesID from cre.TransactionTypes where TransactionName = 'MarketPrice'



--Ignore records if not configured
Update [IO].[L_ManualTransactionVSTO] set [Status] = 'Ignore' ,Comment = 'Transaction Types is not configured' where 
ManualTransactionVSTOID in (
	
	Select ManualTransactionVSTOID from [IO].[L_ManualTransactionVSTO] where [Status] = 'InProcess' and TransactionTypeID not in (
		Select TransactionTypesID from cre.TransactionTypes where Calculated =  4			
		----(AllowCalculationOverride = 3 or Calculated =  4)
	)
)
and TransactionTypeID <> @TransactionTypeID


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
from [IO].[L_ManualTransactionVSTO] mt
inner join cre.note n on n.crenoteid =mt.noteid
left join CRE.TransactionTypes ty on ty.TransactionTypesID = mt.TransactionTypeID


Where [Status] = 'InProcess' and TransactionTypeID <> @TransactionTypeID


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

----======================================
--Send note to calculation
Declare @CalcPriority nvarchar(256)

IF((Select COUNT(Distinct NoteId) from [IO].[L_ManualTransactionVSTO]  where [Status] = 'InProcess' and TransactionTypeID <> @TransactionTypeID ) > 20)
BEGIN
	SET @CalcPriority = 'Batch'
END
ELSE
BEGIN
	SET @CalcPriority = 'Real Time'
END


declare @TableTypeCalculationRequests TableTypeCalculationRequests
	
insert into @TableTypeCalculationRequests(NoteId,StatusText,UserName,PriorityText,AnalysisID,CalcType)
Select NoteId,'Processing',@CreatedBy,@CalcPriority,an.AnalysisID ,775
From Cre.Note,core.Analysis an
where CRENoteID in  (Select NoteId from [IO].[L_ManualTransactionVSTO]  where [Status] = 'InProcess' and TransactionTypeID <> @TransactionTypeID)
and an.name = 'Default'
	
exec [dbo].[usp_QueueNotesForCalculation] @TableTypeCalculationRequests,@CreatedBy,@CreatedBy, NULL, NULL, 'ManualTransactionVSTO'
--=================================================


Update [IO].[L_ManualTransactionVSTO] set [Status] = 'Imported' where [Status] = 'InProcess' and ServicerMasterID = @ServicerMasterID and TransactionTypeID <> @TransactionTypeID

---================================================---
--transfer market price from landing table to actual table
IF OBJECT_ID('tempdb..[#NoteAttributesbyDate]') IS NOT NULL                                         
 DROP TABLE [#NoteAttributesbyDate]  
create table [#NoteAttributesbyDate](
	[NoteID] [nvarchar](256) NULL,
	[Date] datetime null,
	[Value] decimal(28,15),
	[ValueTypeID] int null,
	[StatusType] [nvarchar](256) NULL,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedDate] [datetime] NULL Default getdate(),
	[UpdatedBy] [nvarchar](256) NULL,
	[UpdatedDate] [datetime] NULL Default getdate()
)

INSERT into [#NoteAttributesbyDate](NoteID,[Date],Value,ValueTypeID,[StatusType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
Select n.crenoteid,mt.DueDate,mt.Value,mt.TransactionTypeID,'insert' as [StatusType],
mt.[CreatedBy],mt.[CreatedDate],mt.[UpdatedBy],mt.[UpdatedDate]
from [IO].[L_ManualTransactionVSTO] mt
inner join cre.note n on n.crenoteid =mt.noteid
left join CRE.TransactionTypes ty on ty.TransactionTypesID = mt.TransactionTypeID
Where [Status] = 'InProcess' and TransactionTypeID = @TransactionTypeID


Update [#NoteAttributesbyDate] set [StatusType] = 'update'
from(
	Select 
	a.noteid,
	a.ValueTypeID,
	a.[Date]
	from [#NoteAttributesbyDate] a
	inner join cre.NoteAttributesbyDate te on te.noteid = a.noteid 
	and a.[Date] = te.[Date] 
	and a.[ValueTypeID] = te.[ValueTypeID] 
)b
where 
[#NoteAttributesbyDate].noteid = b.noteid
and [#NoteAttributesbyDate].ValueTypeID = b.ValueTypeID
and [#NoteAttributesbyDate].[Date] = b.[Date]


insert into cre.NoteAttributesbyDate([NoteID],
	  [Date],
	  [Value],
	[ValueTypeID],
	[CreatedBy],
	[CreatedDate],
	[UpdatedBy],
	[UpdatedDate])
	select
	[NoteID],
	[Date],
	[Value],
	[ValueTypeID],
	[CreatedBy],
	[CreatedDate],
	[UpdatedBy],
	[UpdatedDate]
	from [#NoteAttributesbyDate] where [StatusType] = 'insert'


update [CRE].[NoteAttributesbyDate] set [Value] =  b.Value
from(
	select [NoteID], 
	[Date],
	[Value], 
	[ValueTypeID]
	from [#NoteAttributesbyDate] a
	Where a.[StatusType] = 'update'	
) b
where 
[CRE].[NoteAttributesbyDate].noteid = b.[NoteID]
and [CRE].[NoteAttributesbyDate].[Date] = b.[Date]
and [CRE].[NoteAttributesbyDate].ValueTypeID=b.ValueTypeID

Update [IO].[L_ManualTransactionVSTO] set [Status] = 'Imported' where [Status] = 'InProcess' and ServicerMasterID = @ServicerMasterID and TransactionTypeID = @TransactionTypeID
---=================================-----
End





