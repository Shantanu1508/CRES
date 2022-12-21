


CREATE PROCEDURE [dbo].[usp_LCGetPIKScheduleDetailMasterByCRENoteID] --'N09262016'
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
from [CORE].PIKScheduleDetail rs
INNER JOIN [CORE].[Event] eve ON eve.EventID = rs.EventId
INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
			
LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
where n.CRENoteID = @CRENoteID and acc.IsDeleted = 0
group by eve.EffectiveStartDate
order by eve.EffectiveStartDate
                



	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
