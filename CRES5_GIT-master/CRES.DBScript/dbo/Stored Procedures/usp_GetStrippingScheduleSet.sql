------------------------------------------------------------
-- Author:		<NewCon Infosystem>
-- Create date: <11/05/2012>
------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_GetStrippingScheduleSet]	 
 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
     select 
n.CRENoteID,
rs.StartDate as StartDate ,
rs.ValueTypeID,
rs.Value,
rs.IncludedLevelYield,
n.ClosingDate,
rs.IncludedBasis,
rs.UpdatedBy
 from Core.StrippingSchedule  rs
inner JOIN [CORE].[Event] eve  ON eve.EventID =rs.EventId
inner join cre.note n  on eve.EventID = rs.EventId
INNER JOIN [CORE].[Account] acc ON n.Account_AccountID = acc.AccountID 
where 1<>1
END


