--Drop PROCEDURE [dbo].[usp_DeleteFundingSchedule]
CREATE PROCEDURE [dbo].[usp_DeleteFundingScheduleForPrincipalWriteOff]       
 @notefunding [TableTypeFundingSchedule] READONLY,      
 @UserID nvarchar(256)    
    
AS      
BEGIN
SET NOCOUNT ON; 
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  



Delete from [CORE].FundingSchedule Where FundingScheduleID in (

Select FundingScheduleID
from [CORE].FundingSchedule fs
INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID
left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID 
left JOIN [CORE].[Lookup] LAdjustmentType ON LAdjustmentType.LookupID = fs.AdjustmentType 
INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
Left join(

Select Distinct n.noteid ,e.effectivestartdate as Max_EffDate
	from [CORE].FundingSchedule fs
	INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
	INNER JOIN (						
			Select 
			(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
			MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
			from [CORE].[Event] eve
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
			where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')					
			and acc.IsDeleted = 0
			and n.NoteID in (Select Distinct NoteID from @notefunding)
			and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
			GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID
	) sEvent
	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0
	and n.NoteID in (Select Distinct NoteID from @notefunding)

)fflatesteffdate on fflatesteffdate.NoteID = n.NoteID

where e.StatusID = 1  and acc.IsDeleted = 0
and n.NoteID in (Select Distinct NoteID from @notefunding)
and fs.PurposeID = 840
and e.EffectiveStartDate < fflatesteffdate.Max_EffDate

)



SET TRANSACTION ISOLATION LEVEL READ COMMITTED      
END
GO

