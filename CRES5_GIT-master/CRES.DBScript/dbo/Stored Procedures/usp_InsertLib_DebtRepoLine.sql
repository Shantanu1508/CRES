-- Procedure
-- Procedure

CREATE PROCEDURE [dbo].[usp_InsertLib_DebtRepoLine]
(
	@tbltype_Lib [TableTypeLib_DebtRepoLine] READONLY
)
AS
BEGIN
	TRUNCATE TABLE [dbo].[Lib_DebtRepoLine];
	
	INSERT INTO [dbo].[Lib_DebtRepoLine]([Debt Name],[Descriptive Name],[Debt Type],[Status],[Currency],[Match Term],[Is revolving],[Funding Notice Business Days],
		[Initial Funding Delay],[Max Advance Rate],[Target Advance Rate],[Origination Date],[Origination Fee],[Rate Type],[Paydown Delay],[Effective Date],[Commitment],
		[Initial Maturity Date],[Initial Interest Accrual End Date],[Accrual Frequency],[Payment Day of Month],[Payment Date Business Day Lag],
		[Determination Date Lead Days],[Determination Date Reference Day of the month],[Rounding method],[Index Rounding Rule],[Pay Frequency],[Default Index Name]) 
	
	SELECT [DebtName],[DescriptiveName],[DebtType],[Status],[Currency],[MatchTerm],[Isrevolving],[FundingNoticeBusinessDays],
		[InitialFundingDelay],[MaxAdvanceRate],[TargetAdvanceRate],[OriginationDate],[OriginationFee],[RateType],[PaydownDelay],[EffectiveDate],[Commitment],
		[InitialMaturityDate],[InitialInterestAccrualEndDate],[AccrualFrequency],[PaymentDayofMonth],[PaymentDateBusinessDayLag],
		[DeterminationDateLeadDays],[DeterminationDateReferenceDayofthemonth],[Roundingmethod],[IndexRoundingRule],[PayFrequency],[DefaultIndexName] FROM @tbltype_Lib;


	Truncate table [dbo].[DebtRepoLine$]

	INSERT INTO [dbo].[DebtRepoLine$]([Debt Name],[Descriptive Name],[Debt Type],[Status],[Currency],[Match Term],[Is revolving],[Funding Notice Business Days],
		[Initial Funding Delay],[Max Advance Rate],[Target Advance Rate],[Origination Date],[Origination Fee],[Rate Type],[Paydown Delay],[Effective Date],[Commitment],
		[Initial Maturity Date],[Initial Interest Accrual End Date],[Accrual Frequency],[Payment Day of Month],[Payment Date Business Day Lag],
		[Determination Date Lead Days],[Determination Date Reference Day of the month],[Rounding method],[Index Rounding Rule],[Pay Frequency],[Default Index Name]) 
	
	SELECT 
	 NULLIF([Debt Name]                                         ,'')     as [Debt Name]
	,NULLIF([Descriptive Name]									,'')	 as [Descriptive Name]
	,NULLIF([Debt Type]											,'')     as [Debt Type]
	,NULLIF([Status]											,'')	 as [Status]
	,NULLIF([Currency]											,'')	 as [Currency]
	,NULLIF([Match Term]										,'')	 as [Match Term]
	,NULLIF([Is revolving]										,'')	 as [Is revolving]
	,NULLIF([Funding Notice Business Days]						,'')	 as [Funding Notice Business Days]
	,NULLIF([Initial Funding Delay]								,'')     as [Initial Funding Delay]
	,NULLIF([Max Advance Rate]									,'')	 as [Max Advance Rate]
	,NULLIF([Target Advance Rate]								,'')	 as [Target Advance Rate]
	,NULLIF([Origination Date]									,'')	 as [Origination Date]
	,NULLIF([Origination Fee]									,'')	 as [Origination Fee]
	,NULLIF([Rate Type]											,'')	 as [Rate Type]
	,NULLIF([Paydown Delay]										,'')	 as [Paydown Delay]
	,NULLIF([Effective Date]									,'')	 as [Effective Date]
	,NULLIF([Commitment]										,'')	 as [Commitment]
	,NULLIF([Initial Maturity Date]								,'')	 as [Initial Maturity Date]
	,NULLIF([Initial Interest Accrual End Date]					,'')	 as [Initial Interest Accrual End Date]
	,NULLIF([Accrual Frequency]									,'')	 as [Accrual Frequency]
	,NULLIF([Payment Day of Month]								,'')	 as [Payment Day of Month]
	,NULLIF([Payment Date Business Day Lag]						,'')	 as [Payment Date Business Day Lag]
	,NULLIF([Determination Date Lead Days]						,'')	 as [Determination Date Lead Days]
	,NULLIF([Determination Date Reference Day of the month]		,'')	 as [Determination Date Reference Day of the month]
	,NULLIF([Rounding method]									,'')	 as [Rounding method]
	,NULLIF([Index Rounding Rule]								,'')	 as [Index Rounding Rule]
	,NULLIF([Pay Frequency]										,'')	 as [Pay Frequency]
	,NULLIF([Default Index Name] 								,'')	 as [Default Index Name] 
		FROM [Lib_DebtRepoLine];
END