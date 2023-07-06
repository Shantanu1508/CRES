--  [dbo].[usp_GetMaturityEffectiveDateInvalidateValidation] '67768252-7E43-4272-8ACE-02366FF8FE66','7042C856-8C8A-4299-91C9-40CF1049D3F0'

CREATE PROCEDURE [dbo].[usp_GetMaturityEffectiveDateInvalidateValidation]    
(      
	@DealID varchar(50),    
	--@EffectiveStartDate Date,
	--@MaturityMethodID int,
	@UserID varchar(50)    
)      
AS    
BEGIN      
	Select Distinct nt.CRENoteID
	,acc1.name as NoteName
	,e.EffectiveStartDate as EffectiveDate    	
	
	from [CORE].Maturity mat      
	INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
	INNER JOIN     
	(       
		Select       
		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,         
		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve      
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID      
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID      
		where EventTypeID = 11
		and acc.IsDeleted = 0
		and n.dealID = @DealID
		--and n.MaturityMethodID = @MaturityMethodID
		and eve.StatusID = 1		
		GROUP BY n.Account_AccountID,EventTypeID     
	) sEvent      
	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID     and e.StatusID = 1 
	INNER JOIN [CRE].[Note] nt   on nt.Account_AccountID = sEvent.AccountID      
	INNER JOIN [CORE].[Account] acc1 ON acc1.AccountID = nt.Account_AccountID      
	Where nt.dealid = @DealID
	--and nt.MaturityMethodID = @MaturityMethodID
	




     
END  