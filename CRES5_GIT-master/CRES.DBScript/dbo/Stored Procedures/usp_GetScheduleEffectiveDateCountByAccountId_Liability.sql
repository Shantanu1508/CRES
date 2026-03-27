CREATE PROCEDURE [dbo].[usp_GetScheduleEffectiveDateCountByAccountId_Liability]
(
	@AccountId UNIQUEIDENTIFIER, 
	@AdditionalAccountId UNIQUEIDENTIFIER = NULL
)
	
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


	Select  Count(Distinct e.EffectiveStartDate) EffectiveStartDateCounts,'RateSpreadScheduleLiability' as ScheduleType
		from [Core].[RateSpreadScheduleLiability] fs
		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId 
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		--INNER JOIN [CRE].[LiabilityNote] n ON n.AccountID = acc.AccountID
		where ISNULL(e.StatusID,1) = 1 
		and acc.AccountID = @AccountId
		and (@AdditionalAccountId IS NULL OR e.AdditionalAccountID = @AdditionalAccountId)

UNION
	Select  Count(Distinct e.EffectiveStartDate) EffectiveStartDateCounts,'PrepayAndAdditionalFeeScheduleLiability' as ScheduleType
		from [Core].[PrepayAndAdditionalFeeScheduleLiability] fs
		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId 
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		--INNER JOIN [CRE].[Debt] n ON n.AccountID = acc.AccountID
		where ISNULL(e.StatusID,1)= 1 
		and acc.AccountID = @AccountId
		and (@AdditionalAccountId IS NULL OR e.AdditionalAccountID = @AdditionalAccountId)

UNION
	Select  Count(Distinct e.EffectiveStartDate) EffectiveStartDateCounts,'GeneralSetupDetailsLiabilityNote' as ScheduleType
		from [CORE].GeneralSetupDetailsLiabilityNote fs
		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId 
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[LiabilityNote] n ON n.AccountID = acc.AccountID
		where ISNULL(e.StatusID,1)= 1 
		and n.AccountID = @AccountId

UNION
	Select  Count(Distinct e.EffectiveStartDate) EffectiveStartDateCounts,'GeneralSetupDetailsDebt' as ScheduleType
		from [CORE].GeneralSetupDetailsDebt fs
		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId 
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Debt] n ON n.AccountID = acc.AccountID
		where ISNULL(e.StatusID,1)= 1 
		and n.AccountID = @AccountId

UNION
	Select  Count(Distinct e.EffectiveStartDate) EffectiveStartDateCounts,'GeneralSetupDetailsEquity' as ScheduleType
		from [CORE].GeneralSetupDetailsEquity fs
		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId 
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Equity] n ON n.AccountID = acc.AccountID
		where ISNULL(e.StatusID,1)= 1 
		and n.AccountID = @AccountId

UNION
	Select  Count(Distinct e.EffectiveStartDate) EffectiveStartDateCounts,'InterestExpenseSchedule' as ScheduleType
		from [Core].[InterestExpenseSchedule] fs
		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId 
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		--INNER JOIN [CRE].[Debt] n ON n.AccountID = acc.AccountID
		where ISNULL(e.StatusID,1)= 1 
		and acc.AccountID = @AccountId
		and (@AdditionalAccountId IS NULL OR e.AdditionalAccountID = @AdditionalAccountId)

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END