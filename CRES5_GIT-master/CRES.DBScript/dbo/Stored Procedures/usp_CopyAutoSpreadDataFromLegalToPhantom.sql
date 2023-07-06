
CREATE PROCEDURE [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom]
(
	@CREDealID nvarchar(256)
)
  
AS
BEGIN
SET NOCOUNT ON;  

	IF EXISTS(Select dealid from cre.Deal where LinkedDealID = @CREDealID and IsDeleted=0)
	BEGIN
		Declare @PhtmDealid UNIQUEIDENTIFIER = (Select dealid from cre.Deal where LinkedDealID = @CREDealID and IsDeleted=0 )
		Declare @LegalDealid UNIQUEIDENTIFIER = (Select dealid from cre.Deal where CREDealID = @CREDealID and IsDeleted=0 )

		---Copy legal Auto Spread data into phantom-----------
		Delete from [CRE].[DealProjectedPayOffAccounting] where dealid = @PhtmDealid

		INSERT INTO [CRE].[DealProjectedPayOffAccounting](DealID,AsOfDate,CumulativeProbability,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate)  
		SELECT @PhtmDealid as DealID,AsOfDate,CumulativeProbability,CreatedBy,getdate(),updatedBy,getdate() 
		FROM [CRE].[DealProjectedPayOffAccounting]  
		Where dealid = @LegalDealid

		Update CRE.Deal SET 
		CRE.Deal.RepaymentAutoSpreadMethodID = a.RepaymentAutoSpreadMethodID,
		CRE.Deal.PossibleRepaymentdayofthemonth	= a.PossibleRepaymentdayofthemonth,
		CRE.Deal.Repaymentallocationfrequency= a.Repaymentallocationfrequency,
		CRE.Deal.Blockoutperiod= a.Blockoutperiod,
		CRE.Deal.EnableAutoSpreadRepayments= a.EnableAutoSpreadRepayments,
		CRE.Deal.ApplyNoteLevelPaydowns= a.ApplyNoteLevelPaydowns,
		CRE.Deal.AutoUpdateFromUnderwriting= a.AutoUpdateFromUnderwriting,

		CRE.Deal.ExpectedFullRepaymentDate= a.ExpectedFullRepaymentDate,
		CRE.Deal.EarliestPossibleRepaymentDate= a.EarliestPossibleRepaymentDate,
		CRE.Deal.LatestPossibleRepaymentDate= a.LatestPossibleRepaymentDate,
		CRE.Deal.AutoPrepayEffectiveDate= a.AutoPrepayEffectiveDate

		From(
			Select RepaymentAutoSpreadMethodID
			,PossibleRepaymentdayofthemonth	
			,Repaymentallocationfrequency
			,Blockoutperiod
			,EnableAutoSpreadRepayments
			,ApplyNoteLevelPaydowns
			,AutoUpdateFromUnderwriting

			,ExpectedFullRepaymentDate
			,EarliestPossibleRepaymentDate
			,LatestPossibleRepaymentDate
			,AutoPrepayEffectiveDate
			From CRE.Deal where dealid = @LegalDealid
		)a
		where CRE.Deal.dealid = @PhtmDealid

	END
END