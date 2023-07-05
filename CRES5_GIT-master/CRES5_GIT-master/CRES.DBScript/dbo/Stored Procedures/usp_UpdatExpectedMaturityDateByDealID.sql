
CREATE PROCEDURE [dbo].[usp_UpdatExpectedMaturityDateByDealID]  
@DealID UNIQUEIDENTIFIER,
@ExpectedMaturityDate date,
@UserID UNIQUEIDENTIFIER
AS  
BEGIN  
    SET NOCOUNT ON;  



--Update [CORE].Maturity set maturityDate = @ExpectedMaturityDate
--Where MaturityID in (
	
--	Select mat.MaturityID  ---, n.noteid,mat.maturityType,mat.maturityDate,mat.Approved
--	from [CORE].Maturity mat  
--	INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
--	INNER JOIN   
--	(          
--		Select   
--		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
--		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
--		INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
--		where EventTypeID = 11  and eve.StatusID = 1
--		and acc.IsDeleted = 0  
--		and n.dealid = @DealID
--		GROUP BY n.Account_AccountID,EventTypeID    
--	) sEvent    
--	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.StatusID = 1
--	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
--	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
	
--	where mat.maturityType = 712
--	and n.dealid = @DealID
--)



Update cre.Note set ExpectedMaturityDate = @ExpectedMaturityDate where DealID = @DealID



END