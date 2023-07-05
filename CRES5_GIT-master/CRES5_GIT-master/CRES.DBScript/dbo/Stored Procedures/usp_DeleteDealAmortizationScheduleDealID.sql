
CREATE PROCEDURE [dbo].[usp_DeleteDealAmortizationScheduleDealID] --'87bc5d89-416a-4c74-9f86-e73c9d0b8533'
	@DealID UNIQUEIDENTIFIER
AS
BEGIN

	 Delete from [CRE].[DealAmortizationSchedule] where DealAmortizationScheduleAutoID in (
	select DealAmortizationScheduleAutoID from [CRE].[DealAmortizationSchedule] where DealID=@DealID)
	
		Delete from CORE.AmortSchedule where amortscheduleautoid in (
		select amortscheduleautoid from CORE.AmortSchedule where eventid in (
			Select Distinct e.eventid from cre.note n 
			inner join cre.deal d on n.dealid = d.dealid
			inner join core.event e on e.accountid = n.account_accountid and eventtypeid = 19
			where d.dealid = @DealID
		)
		)
		Delete from CORE.[Event] where eventtypeid = 19 and eventautoid in (
			Select Distinct e.eventautoid from cre.note n 
			inner join cre.deal d on n.dealid = d.dealid
			inner join core.event e on e.accountid = n.account_accountid and eventtypeid = 19
			where d.dealid = @DealID
		)
END
