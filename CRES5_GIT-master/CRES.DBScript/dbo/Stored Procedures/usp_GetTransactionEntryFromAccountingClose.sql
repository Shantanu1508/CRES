
CREATE PROCEDURE [dbo].[usp_GetTransactionEntryFromAccountingClose] 
(
	@NoteID  UNIQUEIDENTIFIER,
	@AnalysisID  UNIQUEIDENTIFIER
	--@AccountingCloseDate Date
) 
AS
BEGIN
    SET NOCOUNT ON;	 
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


	Select 
	 acctr.NoteID	
	,acctr.[Date]	
	,acctr.Amount	
	,acctr.[Type]	
	,acctr.AnalysisID	
	,acctr.FeeName	
	,acctr.StrCreatedBy	
	,acctr.GeneratedBy	
	,acctr.TransactionDateByRule	
	,acctr.TransactionDateServicingLog	
	,acctr.RemitDate	
	,acctr.FeeTypeName	
	,acctr.Comment	
	,acctr.PaymentDateNotAdjustedforWorkingDay	
	,acctr.PurposeType	
	,acctr.Cash_NonCash	
	,acctr.IOTermEndDate	
	,acctr.LIBORPercentage	
	,acctr.SpreadPercentage	
	,acctr.PIKInterestPercentage	
	,acctr.PIKLiborPercentage	
	,acctr.NonCommitmentAdj	
	,acctr.AllInCouponRate	
	,p.CloseDate as accountingclosedate
	,acctr.IsDeleted	
	,acctr.CreatedBy	
	,acctr.CreatedDate	
	,acctr.UpdatedBy	
	,acctr.UpdatedDate
	,acctr.AdjustmentType
	,n.Account_AccountID as AccountId
	from [CORE].[AccountingCloseTransationArchive] acctr
	Inner Join cre.note n on n.noteid = acctr.NoteID
	Inner Join core.[period] p on p.PeriodID = acctr.PeriodID
	where acctr.IsDeleted <> 1 and p.IsDeleted	<> 1
	and acctr.noteid = @NoteID	
	and p.AnalysisID = @AnalysisID
	---and p.CloseDate <= @AccountingCloseDate
	 

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	

END      


