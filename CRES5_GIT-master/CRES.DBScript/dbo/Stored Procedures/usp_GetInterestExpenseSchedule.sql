CREATE PROCEDURE [dbo].[usp_GetInterestExpenseSchedule] 
	@DebtAccountID UNIQUEIDENTIFIER, 
	@AdditionalAccountID UNIQUEIDENTIFIER
AS
BEGIN

	Select
	Es.InterestExpenseScheduleID,
	E.AccountID as DebtAccountID,
	E.AdditionalAccountID,
	E.EventID,
	E.EffectiveStartDate as EffectiveDate,
	Es.InitialInterestAccrualEndDate,
	Es.PaymentDayOfMonth,
	Es.PaymentDateBusinessDayLag,
	Es.DeterminationDateLeadDays,
	Es.DeterminationDateReferenceDayOftheMonth,
	Es.InitialIndexValueOverride,
    Es.FirstRateIndexResetDate,
	ES.Recourse
	FROM [CORE].[InterestExpenseSchedule] Es
	INNER JOIN (
		Select EventID, AccountID, AdditionalAccountID, EffectiveStartDate,
		ROW_NUMBER() Over (Partition By AccountID, AdditionalAccountID Order By EffectiveStartDate Desc) as LatestSchedule
		From Core.Event
		Where EventTypeID=914	--914 LookUpID for LiabilityInterestExpense
		AND AccountID=@DebtAccountID  
		and StatusID = 1
		and 1 = (CASE WHEN @AdditionalAccountID = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN @AdditionalAccountID <> '00000000-0000-0000-0000-000000000000' and AdditionalAccountID = @AdditionalAccountID THEN 1 END)
	) E On Es.EventID = E.EventID AND LatestSchedule=1
END