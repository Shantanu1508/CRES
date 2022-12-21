------------------------------------------------------------
-- Author:		<NewCon Infosystem>
-- Create date: <11/05/2012>
------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_GetAmortRecordSet]	 
 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 select 
n.creNoteID,
rs.Date  , 
rs.Value,
rs.UpdatedBy
 from Core.AmortSchedule  rs
inner JOIN [CORE].[Event] eve  ON eve.EventID =rs.EventId
inner join cre.note n  on eve.EventID = rs.EventId
INNER JOIN [CORE].[Account] acc ON n.Account_AccountID = acc.AccountID 
where 1<>1
END


