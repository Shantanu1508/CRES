------------------------------------------------------------
-- Author:		<NewCon Infosystem>
-- Create date: <11/05/2012>
------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_GetFundingScheduleRecordSet]	 
 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
  select
n.creNoteID,
rs.Date ,
rs.Value ,
rs.PurposeID,
rs.UpdatedBy
 from Core.FundingSchedule  rs
inner JOIN [CORE].[Event] eve  ON eve.EventID =rs.EventId
inner join cre.note n  on eve.EventID = rs.EventId

where 1<>1

END


