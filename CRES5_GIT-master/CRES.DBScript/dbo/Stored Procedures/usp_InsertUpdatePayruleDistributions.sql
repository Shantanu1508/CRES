
 CREATE PROCEDURE [dbo].[usp_InsertUpdatePayruleDistributions] --'6d7be350-31ea-4455-b04a-733e107371d9','Null'
	@SourceNoteID nvarchar(256),
	@UpdatedBy nvarchar(256),
	@AnalysisID UNIQUEIDENTIFIER 
   
 AS  
 --declare @SourceNoteID uniqueidentifier='00DA9C97-814E-439C-A31B-B438F207FF1A'
 
 Begin

delete CRE.PayruleDistributions where SourceNoteID=@SourceNoteID and (AnalysisID = @AnalysisID or AnalysisID is null)

INSERT INTO CRE.PayruleDistributions  
(   
	TransactionDate,
	SourceNoteID,
	ReceiverNoteID,
	RuleID,
	Amount,
	CreatedBy,
	CreatedDate,
	UpdatedBy,
	UpdatedDate,
	FeeName,
	AnalysisID
 )  

 select
	distinct nc.[Date]
	,@SourceNoteID as SourceNoteID
	,ps.StripTransferTo
	,ps.RuleID
	,(nc.Amount * ps.[Value]) * (-1)  as Amount
	,@UpdatedBy
	,GETDATE()
	,@UpdatedBy
	,GETDATE()
	,nc.FeeName
	,@AnalysisID
	 
 from CRE.TransactionEntry nc
 inner join CRE.PayruleSetup ps on ps.StripTransferFrom=nc.NoteID 
 Inner join cre.feeschedulesconfig fsc on fsc.FeeTypeNameID = ps.RuleID
 Inner join core.lookup lFeeTypeTran on lFeeTypeTran.lookupid = fsc.FeeNameTransID
 WHERE nc.NoteID = @SourceNoteID 
 and nc.analysisid = @AnalysisID
 --and CHARINDEX(REplace(lFeeTypeTran.Name + 'Strip',' ',''), [Type]) > 0
and CHARINDEX(REplace(lFeeTypeTran.Name + 'Strip',' ',''), (CASE WHEN [Type] = 'AddlFeesStrippingExcldfromLevelYield' THEN 'AdditionalFeeStrippingExcldfromLevelYield' ELSE [Type] END)) > 0


 EXEC usp_InsertUpdateFeeCouponStripReceivableForPayruleSetup @SourceNoteID,@UpdatedBy,@AnalysisID

 End
