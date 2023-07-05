--[dbo].[usp_GetScheduleEffectiveDateCountByDealId] 'A1CB7C9F-E974-48F4-96F2-45926C29AFA9'
Create PROCEDURE [dbo].[usp_GetScheduleEffectiveDateCountByDealId] 
(
	@DealID UNIQUEIDENTIFIER 
)
	
AS
BEGIN



Select  Count(Distinct e.EffectiveStartDate) EffectiveStartDateCounts,n.NoteId,'Maturity' as ScheduleType
		from [CORE].Maturity fs
		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId 
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		where ISNULL(e.StatusID,1)= 1 
		and n.dealID = @DealID
		
		group by noteid

		END





	