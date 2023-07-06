------------------------------------------------------------
-- Author:		<NewCon Infosystem>
-- Create date: <11/05/2012>
------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_GetPIKScheduleecordSet]	 
 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
     select 
    

n.creNoteID,
piks.SourceAccountID as creSourceNoteID, 
piks.TargetAccountID creTargetNoteID,
piks.AdditionalIntRate, 
piks.AdditionalSpread,
piks.IndexFloor,
piks.IntCompoundingRate,
piks.IntCompoundingSpread,
piks.StartDate ,
piks.EndDate ,
piks.IntCapAmt,
piks.PurBal,
piks.AccCapBal,  
piks.UpdatedBy
 from Core.PIKSchedule  piks
inner JOIN [CORE].[Event] eve  ON eve.EventID =piks.EventId
inner join cre.note n  on eve.EventID = piks.EventId
where 1<>1
 
END


