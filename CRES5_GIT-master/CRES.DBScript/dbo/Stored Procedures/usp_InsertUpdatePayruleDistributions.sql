
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
  Inner join core.account acc on acc.accountid = nc.AccountID
 Inner join cre.note n on n.account_accountid = acc.accountid

 inner join CRE.PayruleSetup ps on ps.StripTransferFrom=n.NoteID 
 Inner join cre.feeschedulesconfig fsc on fsc.FeeTypeNameID = ps.RuleID
 Inner join core.lookup lFeeTypeTran on lFeeTypeTran.lookupid = fsc.FeeNameTransID
 WHERE n.NoteID = @SourceNoteID 
 and nc.analysisid = @AnalysisID
  and acc.AccounttypeID = 1
 --and CHARINDEX(REplace(lFeeTypeTran.Name + 'Strip',' ',''), [Type]) > 0
and CHARINDEX(REplace(lFeeTypeTran.Name + 'Strip',' ',''), (CASE WHEN [Type] = 'AddlFeesStrippingExcldfromLevelYield' THEN 'AdditionalFeeStrippingExcldfromLevelYield' ELSE [Type] END)) > 0




Delete from core.[FeeCouponStripReceivable] where SourceNoteId = @SourceNoteID and AnalysisID =  @AnalysisID  and eventid in (
Select eventid from core.Event WHERE  EventTypeID = 20
and AccountID in (Select Account_AccountID from CRE.NOte where noteid in (Select StripTransferTo from [CRE].PayruleSetup where StripTransferFrom =@SourceNoteID ))
)  
 


 EXEC usp_InsertUpdateFeeCouponStripReceivableForPayruleSetup @SourceNoteID,@UpdatedBy,@AnalysisID

 End
