


CREATE PROCEDURE [dbo].[usp_LCGetFundingScheduleMasterByCRENoteID] --'4464'
(
	@CRENoteID NVARCHAR(256)
)
	
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF;
   

DECLARE @cols AS NVARCHAR(MAX),
@query  AS NVARCHAR(MAX)


select   CONVERT(NVARCHAR(256),eve.EffectiveStartDate,101) 
from [CORE].FundingSchedule rs
INNER JOIN [CORE].[Event] eve ON eve.EventID = rs.EventId
INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
			
LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
where n.CRENoteID = @CRENoteID and  acc.IsDeleted = 0
and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active'  and Parentid = 1)

and ISNULL(rs.PurposeID,1) <> 351

group by eve.EffectiveStartDate
order by eve.EffectiveStartDate
                


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED

END