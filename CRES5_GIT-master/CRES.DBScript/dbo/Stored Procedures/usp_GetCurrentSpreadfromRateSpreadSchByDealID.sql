CREATE PROCEDURE [dbo].[usp_GetCurrentSpreadfromRateSpreadSchByDealID]    
(      
 @DealID nvarchar(256)  
)      
AS      
      
BEGIN      
 SET NOCOUNT ON;      
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


 Select DealID, NoteID, CRENoteID, CurrentSpread, ValueType
 From(
	Select d.dealid as DealID, n.noteid as NoteID, n.CRENoteID, rs.Date, LValueTypeID.name as ValueType,rs.value as CurrentSpread,
	ROW_number() Over (Partition by n.noteid order by n.noteid,rs.Date desc) rno
	from [CORE].RateSpreadSchedule rs  
	INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId  
	LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID  		 
	INNER JOIN   
	   (  
		Select   
		 (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
		 MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
		 INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
		 INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
		 where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'RateSpreadSchedule')  
		 and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)       
		 and acc.IsDeleted = 0  
		 and n.dealid = @DealID
		 GROUP BY n.Account_AccountID,EventTypeID  
	   ) sEvent  
	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	INNER JOIN [CRE].[Deal] d ON d.dealid = n.dealid
	where e.StatusID = 1
	and acc.IsDeleted = 0
	and LValueTypeID.name = 'Spread'
	and rs.Date <= CAST(getdate() as date)
	and d.dealid = @DealID
)a
where rno = 1


 SET TRANSACTION ISOLATION LEVEL READ COMMITTED      
      
END  