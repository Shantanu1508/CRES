
CREATE PROCEDURE [dbo].[usp_GetScheduleEffectiveDateCountByNoteId] 
(
	@NoteId UNIQUEIDENTIFIER 
)
	
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


	Select  Count(Distinct e.EffectiveStartDate) EffectiveStartDateCounts,'RateSpreadSchedule' as ScheduleType
		from [CORE].RateSpreadSchedule fs
		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId 
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		where ISNULL(e.StatusID,1) = 1 
		and n.noteid = @NoteId

UNION
	Select  Count(Distinct e.EffectiveStartDate) EffectiveStartDateCounts,'PrepayAndAdditionalFeeSchedule' as ScheduleType
		from [CORE].PrepayAndAdditionalFeeSchedule fs
		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId 
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		where ISNULL(e.StatusID,1)= 1 
		and n.noteid = @NoteId
	

UNION
	Select  Count(Distinct e.EffectiveStartDate) EffectiveStartDateCounts,'FinancingFeeSchedule' as ScheduleType
		from [CORE].FinancingFeeSchedule fs
		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId 
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		where ISNULL(e.StatusID,1)= 1 
		and n.noteid = @NoteId
	

UNION
	Select  Count(Distinct e.EffectiveStartDate) EffectiveStartDateCounts,'FinancingSchedule' as ScheduleType
		from [CORE].FinancingSchedule fs
		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId 
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		where ISNULL(e.StatusID,1)= 1 
		and n.noteid = @NoteId

UNION
	Select  Count(Distinct e.EffectiveStartDate) EffectiveStartDateCounts,'PIKSchedule' as ScheduleType
		from [CORE].PIKSchedule fs
		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId 
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		where ISNULL(e.StatusID,1)= 1 
		and n.noteid = @NoteId

	

UNION
	Select  Count(Distinct e.EffectiveStartDate) EffectiveStartDateCounts,'DefaultSchedule' as ScheduleType
		from [CORE].DefaultSchedule fs
		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId 
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		where ISNULL(e.StatusID,1)= 1 
		and n.noteid = @NoteId


--UNION
--	Select  Count(Distinct e.EffectiveStartDate) EffectiveStartDateCounts,'FeeCouponSchedule' as ScheduleType
--		from [CORE].FeeCouponSchedule fs
--		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId 
--		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
--		where ISNULL(e.StatusID,1)= 1 
--		and n.noteid = @NoteId

UNION
	Select  Count(Distinct e.EffectiveStartDate) EffectiveStartDateCounts,'AmortSchedule' as ScheduleType
		from [CORE].AmortSchedule fs
		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId 
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		where ISNULL(e.StatusID,1)= 1 
		and n.noteid = @NoteId
	
UNION
	Select  Count(Distinct e.EffectiveStartDate) EffectiveStartDateCounts,'FundingSchedule' as ScheduleType
		from [CORE].FundingSchedule fs
		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId 
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		where ISNULL(e.StatusID,1)= 1 
		and n.noteid = @NoteId
	
UNION
	Select  Count(Distinct e.EffectiveStartDate) EffectiveStartDateCounts,'Maturity' as ScheduleType
		from [CORE].Maturity fs
		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId 
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		where ISNULL(e.StatusID,1)= 1 
		and n.noteid = @NoteId
	

--UNION
--	Select  Count(Distinct e.EffectiveStartDate) EffectiveStartDateCounts,'BalanceTransactionSchedule' as ScheduleType
--		from [CORE].BalanceTransactionSchedule fs
--		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId 
--		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
--		where ISNULL(e.StatusID,1)= 1 
--		and n.noteid = @NoteId
	

--UNION
--	Select  Count(Distinct e.EffectiveStartDate) EffectiveStartDateCounts,'ServicingFeeSchedule' as ScheduleType
--		from [CORE].ServicingFeeSchedule fs
--		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId 
--		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
--		where ISNULL(e.StatusID,1)= 1 
--		and n.noteid = @NoteId


--UNION
--	Select  Count(Distinct e.EffectiveStartDate) EffectiveStartDateCounts,'StrippingSchedule' as ScheduleType
--		from [CORE].StrippingSchedule fs
--		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId 
--		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
--		where ISNULL(e.StatusID,1)= 1 
--		and n.noteid = @NoteId

UNION
	Select  Count(Distinct e.EffectiveStartDate) EffectiveStartDateCounts,'PIKScheduleDetail' as ScheduleType
		from [CORE].PIKScheduleDetail fs
		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId 
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		where ISNULL(e.StatusID,1)= 1 
		and n.noteid = @NoteId
	

UNION
	Select  Count(Distinct e.EffectiveStartDate) EffectiveStartDateCounts,'FeeCouponStripReceivable' as ScheduleType
		from [CORE].FeeCouponStripReceivable fs
		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId 
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		where ISNULL(e.StatusID,1)= 1 
		and n.noteid = @NoteId
	

--UNION
--	Select  Count(Distinct e.EffectiveStartDate) EffectiveStartDateCounts,'LIBORSchedule' as ScheduleType
--		from [CORE].LIBORSchedule fs
--		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId 
--		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
--		where ISNULL(e.StatusID,1)= 1 
--		and n.noteid = @NoteId
	


SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
