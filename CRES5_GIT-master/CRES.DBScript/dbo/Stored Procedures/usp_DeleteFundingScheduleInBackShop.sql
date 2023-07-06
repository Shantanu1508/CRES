
CREATE PROCEDURE [dbo].[usp_DeleteFundingScheduleInBackShop] --'1479'
(
	@CRENoteID nvarchar(256)
)
AS
BEGIN


Begin Try 
	
	Delete from core.Exceptions where ObjectID in (Select top 1  NoteId from cre.note where CRENoteID = @CRENoteID) and FieldName = 'M61 and Backshop funding mismatch' and ObjectTypeID = 182

	IF((Select top 1 [Value] from app.AppConfig where [Key] = 'AllowBackshopFF') = 1)
	BEGIN
		IF ((SELECT ISNUMERIC(@CRENoteID)) = 1) --Because backshop's procedure take crenoteid as int
		BEGIN
				Declare @count int;

				Select @count = Count(*)
				from [CORE].FundingSchedule fs
				INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
				INNER JOIN 
				(
						
					Select 
						(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
						MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
						from [CORE].[Event] eve
						INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
						INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
						where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')
						and n.CRENoteID = @CRENoteID
						and acc.IsDeleted=0
						and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
						GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID

				) sEvent

				ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID

				left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID
				left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID 
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
				
				where sEvent.StatusID = e.StatusID and acc.IsDeleted=0


				IF(@count = 0)
				BEGIN
					exec sp_NoteFundingsDeleteByNoteId @CRENoteID
				END


		END
	END
End Try 
Begin Catch 
  
End catch 


END



