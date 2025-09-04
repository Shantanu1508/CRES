CREATE PROCEDURE [dbo].[usp_DeleteInterestExpenseSchedule] 
	@DebtAccountID UNIQUEIDENTIFIER, 
	@AdditionalAccountID UNIQUEIDENTIFIER = NULL
AS
BEGIN

	Delete FROM [CORE].[InterestExpenseSchedule] WHERE EventID IN (
		Select EventID
		From Core.Event
		Where EventTypeID=914	--914 LookUpID for LiabilityInterestExpense
		AND AccountID=@DebtAccountID  
		and 1 = (CASE WHEN @AdditionalAccountID = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN @AdditionalAccountID <> '00000000-0000-0000-0000-000000000000' and AdditionalAccountID = @AdditionalAccountID THEN 1 END)
	)

	DELETE From Core.Event
		Where EventTypeID=914	--914 LookUpID for LiabilityInterestExpense
		AND AccountID=@DebtAccountID  
		and 1 = (CASE WHEN @AdditionalAccountID = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN @AdditionalAccountID <> '00000000-0000-0000-0000-000000000000' and AdditionalAccountID = @AdditionalAccountID THEN 1 END)
END