

CREATE PROCEDURE [dbo].[usp_GetNoteFundingForAutoSpread] --'e484c0c5-0a6f-4d0f-8bcb-bff9f3282ee1','12/10/2022'
 @DealID nvarchar(256),
 @Date date
AS  
BEGIN  
  
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  


	select n.noteid,fs.date,SUM(fs.value) as [value]  ---,fs.PurposeID ,LPurposeID.name as PurposeText
	from [CORE].FundingSchedule fs
	INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
	INNER JOIN 	(
						
					Select 
						(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
						MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
						from [CORE].[Event] eve
						INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
						INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
						where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')
						and n.DealID = @DealID  and acc.IsDeleted = 0
						and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
						GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID

				) sEvent

	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID

	left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID
	left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID 
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0
	and LPurposeID.name <> 'Amortization'
	--and fs.value >= 0
	and fs.date = @Date

	group by n.noteid,fs.date

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  