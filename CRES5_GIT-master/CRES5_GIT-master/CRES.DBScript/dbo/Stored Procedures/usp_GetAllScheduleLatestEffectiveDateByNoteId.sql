


CREATE PROCEDURE [dbo].[usp_GetAllScheduleLatestEffectiveDateByNoteId]-- 'aa750dc0-9c79-4c8e-bab6-201c16f11608' 
(
    @NoteId UNIQUEIDENTIFIER
)
	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
   
     	
Select 
(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID and ac.IsDeleted=0) AccountID ,
MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID 
from [CORE].[Event] eve
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')
and n.NoteID = @NoteId and acc.IsDeleted=0
and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID


UNION

--Select 
--(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
--MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
--INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
--INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
--where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'LiborSchedule')
--and n.NoteID = @NoteId
--GROUP BY n.Account_AccountID,EventTypeID


--UNION

Select 
(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID and ac.IsDeleted=0) AccountID ,
MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'AmortSchedule')
and n.NoteID = @NoteId and acc.IsDeleted=0
and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID
UNION

Select 
(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID and ac.IsDeleted=0) AccountID ,
MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'PIKScheduleDetail') 
and n.NoteID = @NoteId and acc.IsDeleted=0
GROUP BY n.Account_AccountID,EventTypeID


UNION


Select 
(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID and ac.IsDeleted=0) AccountID ,
MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FeeCouponStripReceivable')
and n.NoteID = @NoteId and acc.IsDeleted=0
GROUP BY n.Account_AccountID,EventTypeID
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END

