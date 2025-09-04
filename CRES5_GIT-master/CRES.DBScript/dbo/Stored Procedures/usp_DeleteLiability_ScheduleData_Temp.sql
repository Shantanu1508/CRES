CREATE Procedure [dbo].[usp_DeleteLiability_ScheduleData_Temp] 
as 
BEGIN
	SET NOCOUNT ON;



	Declare @tbleventtemp as TABLE(
		eventid UNIQUEIDENTIFIER
	)


	INSERT INTO @tbleventtemp(eventid)
	Select EventId from (	
		Select EventId from [Core].RateSpreadScheduleLiability
		UNION ALL
		Select EventId from [Core].PrepayAndAdditionalFeeScheduleLiability
		UNION ALL
		Select EventId from [Core].[InterestExpenseSchedule]
	)a

	delete from [Core].RateSpreadScheduleLiability where eventid in (select eventid from @tbleventtemp)
	delete from [Core].PrepayAndAdditionalFeeScheduleLiability where eventid in (select eventid from @tbleventtemp)
	delete from [Core].[InterestExpenseSchedule] where eventid in (select eventid from @tbleventtemp)
	delete from core.Event where eventtypeid in (909,908,914) and eventid in (select eventid from @tbleventtemp)

	delete from cre.DebtExt


END
GO

