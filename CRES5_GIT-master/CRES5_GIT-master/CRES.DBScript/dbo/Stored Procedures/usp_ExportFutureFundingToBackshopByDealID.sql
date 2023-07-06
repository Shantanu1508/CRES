  
CREATE PROCEDURE [dbo].[usp_ExportFutureFundingToBackshopByDealID]    
(  
	@dealid Uniqueidentifier,
	@UserID Uniqueidentifier
)  
AS    
BEGIN    
   
 SET NOCOUNT ON;    
  
 --Declare @CreatedBy Uniqueidentifier = (Select top 1 UserID  from app.[user] where FirstName = 'Krishna')
	Declare @CreatedBy Uniqueidentifier = (Select top 1 UserID  from app.[user] where UserID = @UserID)
  
 DECLARE @noteFundingSchedule [TableTypeFundingSchedule]  
  
 INSERT INTO @noteFundingSchedule(NoteId,AccountId)  
 Select n.noteid, acc.AccountID  
 from cre.Note n  
 inner join core.Account acc on acc.AccountID = n.Account_AccountID  
 inner join cre.Deal d on d.DealID = n.DealID  
 where d.dealid = @dealid  
  
 exec [dbo].[usp_ExportFutureFundingFromCRES] @noteFundingSchedule,@CreatedBy,@CreatedBy,0  
  
  
  
END  