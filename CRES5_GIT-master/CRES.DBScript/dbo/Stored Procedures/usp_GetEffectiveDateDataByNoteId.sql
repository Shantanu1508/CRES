


CREATE PROCEDURE [dbo].[usp_GetEffectiveDateDataByNoteId] --'d94b66b8-ac21-4e20-a9cf-320fd4151a17', '80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B',1,1,null
(
    @NoteId UNIQUEIDENTIFIER,
	@UserID UNIQUEIDENTIFIER,
	
	@PageIndex INT,
    @PageSize INT,
	@TotalCount INT OUTPUT 
)
	
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
   
  
  select * from
  (    
Select 
eve.EffectiveStartDate AS EffectiveDate
,eve.EventTypeID

,CASE LEventTypeID.Name
WHEN 'FundingSchedule' THEN 'FFScheduleTab'
WHEN 'PIKScheduleDetail' THEN 'PIKScheduleTab'
WHEN 'LIBORSchedule' THEN 'LIBORScheduleTab'
WHEN 'AmortSchedule' THEN 'AmortScheduleTab'
ELSE LEventTypeID.Name END as EventTypeText

from [CORE].[Event] eve
INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
INNER JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID

where n.NoteID = @NoteId  and acc.IsDeleted = 0
and LEventTypeID.Name in ('FundingSchedule','PIKScheduleDetail','LIBORSchedule','AmortSchedule')
and ( eve.StatusID is null or eve.StatusID in( (Select LookupID from Core.Lookup where name = 'Active'  and Parentid = 1),Null))
-- UNION

--Select ntd.TransactionDate as EffectiveDate, 
--NUll as EventTypeID ,
--'ServicingLogTab' as EventTypeText 
--from CRE.note n
--Inner join cre.NoteTransactionDetail ntd on ntd.NoteID = n.NoteID
--where n.NoteID = @NoteId

) a
order by a.EffectiveDate


SET @TotalCount = (SELECT @@Rowcount);

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED

END
