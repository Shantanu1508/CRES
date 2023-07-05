
CREATE PROCEDURE [DW].[usp_ImportRealizedDataIntoTransactionEntryBI_Realized]
	
AS
BEGIN
	SET NOCOUNT ON;

Truncate table [DW].[TransactionEntryBI_Realized]

INSERT INTO [DW].[TransactionEntryBI_Realized](
TransactionEntryID	
,NoteID	
,CRENoteID	
,Date	
,Amount	
,Type	
,CreatedBy	
,CreatedDate	
,UpdatedBy	
,UpdatedDate
,[TransactionEntryAutoID]
,AnalysisID	
,AnalysisName	
,FeeName	
,DealName	
,CreDealID	
,TransactionDateByRule	
,TransactionDateServicingLog	
,RemitDate
,ClientBI
,NoteName)

Select 
 tr.TransactionEntryID	
,tr.NoteID	
,tr.CRENoteID	
,tr.Date	
,tr.Amount	
,tr.Type	
,tr.CreatedBy	
,tr.CreatedDate	
,tr.UpdatedBy	
,tr.UpdatedDate
,tr.[TransactionEntryAutoID]
,tr.AnalysisID	
,tr.AnalysisName	
,tr.FeeName	
,tr.DealName	
,tr.CreDealID	
,tr.TransactionDateByRule	
,tr.TransactionDateServicingLog	
,tr.RemitDate	
,n.clientBI
,n.name
from dw.TransactionEntryBI tr
inner join dw.notebi n on n.noteid = tr.noteid
inner join (
	Select Distinct noteid from [dbo].[RealizedCashFlow_IG$]
)IG on IG.NoteID = tr.CRENoteID
Where AnalysisName = 'Default'
and tr.type in (
  'AdditionalFeesExcludedFromLevelYield',
  'PrepaymentFeeExcludedFromLevelYield',
  'OriginationFeeStripReceivable',
  'OriginationFeeStripping',
  'PIKPrincipalFunding',
  'AdditionalFeesIncludedInLevelYield',
  'OriginationFee',
  'ManagementFee',
  'UnusedFeeExcludedFromLevelYield',
  'StubInterest',
  'PrepaymentFeeExcludedFromLevelYield',
  'CapitalizedClosingCost',
  'PurchasedInterest',
  'FloatInterest',
  'Balloon',
  'AcoreOriginationFeeExcludedFromLevelYield',
  'Discount/Premium',
  'ExitFeeExcludedFromLevelYield',
  'InitialFunding',
  'ExitFeeStrippingExcldfromLevelYield',
  'AdditionalFeesStripReceivable',
  'FundingOrRepayment',
  'ExtensionFeeExcludedFromLevelYield',
  'AdditionalFeesExcludedFromLevelYield',
  'ExitFeeStripReceivable',
  'PIKInterest',
  'OriginationFeeIncludedInLevelYield',
  'ScheduledPrincipalPaid',
  'InterestPaid'
  )




END



