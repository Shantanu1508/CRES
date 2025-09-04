-- [dbo].[usp_NoteTransactionDetailByNoteId] 'd88f7cea-2678-4881-9534-de0b6091a789'
--[dbo].[usp_NoteTransactionDetailByNoteId] 'b868c63b-9962-43f7-804a-22e148792c1a'
CREATE PROCEDURE [dbo].[usp_NoteTransactionDetailByNoteId] 
(
	@NoteID UNIQUEIDENTIFIER
)
AS
BEGIN
 SET NOCOUNT ON;

Declare @DeterminationDateReferenceDayoftheMonth int  = (Select DeterminationDateReferenceDayoftheMonth from cre.Note where noteid = @NoteID)


Declare @ServicerMasterID int = (Select ServicerMasterID from [CRE].[ServicerMaster] where ServicerName = 'CashFlow')
Declare @ServicerName nvarchar(256) = (Select ServicerName from [CRE].[ServicerMaster] where ServicerName = 'CashFlow')


Declare @NextInterestPaid_Date date;

Select @NextInterestPaid_Date = MIN(date) 
FROM [Cre].TransactionEntry tr
Inner join core.account acc on acc.accountid = tr.AccountID
Inner join cre.note n on n.account_accountid = acc.accountid
WHERE tr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
and n.NoteID = @NoteID
and acc.AccounttypeID = 1
and tr.[Type] = 'InterestPaid'
and tr.RemitDate is null
and n.EnableM61Calculations = 3
and (tr.Date >= Cast(getdate() as date) and tr.Date <= EOMONTH(DATEADD(month,1,getdate())) )
---============================================================

Select 
	ROW_NUMBER() OVER (
      --PARTITION BY RelatedtoModeledPMTDate ,TransactionDate ,TransactionType ,RemittanceDate
     ORDER BY RelatedtoModeledPMTDate Asc,RemittanceDate Asc,TransactionType Asc,TransactionDate Asc
   ) row_num,NoteTransactionDetailID,NoteID,TransactionDate,TransactionType,Amount,RelatedtoModeledPMTDate,ModeledPayment,AmountOutstandingafterCurrentPayment,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,ServicingAmount,CalculatedAmount,Delta,M61Value,ServicerValue,Ignore,OverrideValue,comments,PostedDate,ServicerMasterID,ServicerName,Deleted,TransactionTypeText,TranscationReconciliationID,RemittanceDate,Exception,Adjustment,ActualDelta,OverrideReason,OverrideReasonText,Calculated,AllowCalculationOverride,TransactionEntryAmount,InterestAdj,AddlInterest,TotalInterest,WriteOffAmount
From(

	Select
	[NoteTransactionDetailID]
      ,n.[NoteID]
      ,[TransactionDate]
      ,[TransactionType]
      ,[Amount]
      ,[RelatedtoModeledPMTDate]
      ,[ModeledPayment]
      ,[AmountOutstandingafterCurrentPayment] 
	  ,n.[CreatedBy]
      ,n.[CreatedDate]
      ,n.[UpdatedBy]
      ,n.[UpdatedDate]     
      ,[ServicingAmount]
      ,[CalculatedAmount]
      ,[Delta]
      ,[M61Value]
      ,[ServicerValue]
      ,[Ignore]
	 , [OverrideValue]
     -- ,ISNULL([OverrideValue],0) as [OverrideValue]
      ,[comments]
      ,[PostedDate]
      ,n.[ServicerMasterID]
	  ,sm.ServicerName
      ,[Deleted]
      ,[TransactionTypeText]
      ,[TranscationReconciliationID]
      ,[RemittanceDate]
      ,[Exception]
      ,[Adjustment]
      ,[ActualDelta]
	  ,OverrideReason
	  ,l.Name as OverrideReasonText
	  ,tr.Calculated 
	  ,tr.AllowCalculationOverride
	  ,TransactionEntryAmount as TransactionEntryAmount
	  ,InterestAdj
	  ,AddlInterest
	  ,TotalInterest
	  ,WriteOffAmount
	FROM [Cre].[NoteTransactionDetail] n
	left join CRE.TransactionTypes tr on n.TransactionTypeText=tr.TransactionName
	left join Core.Lookup l ON n.OverrideReason=l.LookupID
	left join [Cre].[ServicerMaster] sm on n.[ServicerMasterID]=sm.ServicerMasterId

	WHERE NoteID = @NoteId

	UNION ALL

	Select

	ISNULL(nt.[NoteTransactionDetailID],'00000000-0000-0000-0000-000000000000') as [NoteTransactionDetailID]
	,n.[NoteID]
	,tr.date as [TransactionDate]
	,ty.TransactionTypesID as [TransactionType]
	,tr.[Amount]
	,tr.date as [RelatedtoModeledPMTDate]
	,null as [ModeledPayment]
	,null as [AmountOutstandingafterCurrentPayment] 
	,tr.[CreatedBy]
	,tr.[CreatedDate]
	,tr.[UpdatedBy]
	,tr.[UpdatedDate]     
	,null as [ServicingAmount]
	,tr.Amount as CalculatedAmount
	,0 as [Delta]
	,0 as [M61Value]
	,0 as [ServicerValue]
	,0 as [Ignore]
	,null as [OverrideValue]
	,null as [comments]
	,null as [PostedDate]
	,@ServicerMasterID as [ServicerMasterID]
	,@ServicerName as ServicerName
	,0 as [Deleted]
	,tr.Type [TransactionTypeText]
	,null as [TranscationReconciliationID]
	,tr.Date as [RemittanceDate]
	,null as [Exception]
	,0 as [Adjustment]
	,0 as [ActualDelta]
	,null as OverrideReason
	,null as OverrideReasonText
	,ty.Calculated 
	,ty.AllowCalculationOverride
	,isnull(tr.Amount,0) as TransactionEntryAmount
	,InterestAdj
	,AddlInterest
	,TotalInterest
	,nt.WriteOffAmount
	FROM [Cre].TransactionEntry tr
	 Inner join core.account acc on acc.accountid = tr.AccountID
     Inner join cre.note n on n.account_accountid = acc.accountid

	left join cre.NoteTransactionDetail nt on nt.NoteID = n.NoteID and tr.Date = nt.RelatedtoModeledPMTDate and tr.Type = nt.TransactionTypeText
	left join CRE.TransactionTypes ty on ty.TransactionName = tr.Type

	WHERE tr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	and n.NoteID = @NoteID
	and ty.AllowCalculationOverride = 3
	and tr.Date <= DATEADD(d,@DeterminationDateReferenceDayoftheMonth - 1,DATEADD(d, 1, EOMONTH(getdate())))
	and nt.NoteTransactionDetailID is null
	and acc.AccounttypeID = 1


	UNION ALL


	Select ISNULL(nt.[NoteTransactionDetailID],'00000000-0000-0000-0000-000000000000') as [NoteTransactionDetailID]
	,n.[NoteID]
	,tr.date as [TransactionDate]
	,ty.TransactionTypesID as [TransactionType]
	,tr.[Amount]
	,tr.date as [RelatedtoModeledPMTDate]
	,null as [ModeledPayment]
	,null as [AmountOutstandingafterCurrentPayment] 
	,tr.[CreatedBy]
	,tr.[CreatedDate]
	,tr.[UpdatedBy]
	,tr.[UpdatedDate]     
	,null as [ServicingAmount]
	,tr.Amount as CalculatedAmount
	,0 as [Delta]
	,0 as [M61Value]
	,0 as [ServicerValue]
	,0 as [Ignore]
	,null as [OverrideValue]
	,null as [comments]
	,null as [PostedDate]
	,@ServicerMasterID as [ServicerMasterID]
	,@ServicerName as ServicerName
	,0 as [Deleted]
	,tr.Type [TransactionTypeText]
	,null as [TranscationReconciliationID]
	,tr.Date as [RemittanceDate]
	,null as [Exception]
	,0 as [Adjustment]
	,0 as [ActualDelta]
	,null as OverrideReason
	,null as OverrideReasonText
	,ty.Calculated 
	,ty.AllowCalculationOverride
	,isnull(tr.Amount,0) as TransactionEntryAmount
	,InterestAdj
	,AddlInterest
	,TotalInterest
	,nt.WriteOffAmount
	FROM [Cre].TransactionEntry tr
	Inner join core.account acc on acc.accountid = tr.AccountID
    Inner join cre.note n on n.account_accountid = acc.accountid
	left join cre.NoteTransactionDetail nt on nt.NoteID = n.NoteID 
	and tr.Date = nt.RelatedtoModeledPMTDate and tr.Type = nt.TransactionTypeText
	left join CRE.TransactionTypes ty on ty.TransactionName = tr.Type

	WHERE tr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	and n.NoteID = @NoteID		
	and nt.NoteTransactionDetailID is null
	and acc.AccounttypeID = 1
	and tr.RemitDate is null
	and tr.[Type] = 'InterestPaid'
	and n.EnableM61Calculations = 3
	and tr.Date <= @NextInterestPaid_Date



)a
order by row_num



END
GO

