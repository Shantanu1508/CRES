
CREATE PROCEDURE [dbo].[usp_LCGetLIBORScheduleMasterByCRENoteID] --'1265'
(
	@CRENoteID NVARCHAR(256)
)
	
AS
BEGIN

SET NOCOUNT ON;
SET FMTONLY OFF;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED   

DECLARE @cols AS NVARCHAR(MAX),
@query  AS NVARCHAR(MAX)


--DECLARE @LScheduleLookupID INT;
DECLARE @AccountID UNIQUEIDENTIFIER;

--Select @LScheduleLookupID = LookupID from CORE.[Lookup] where Name = 'LiborSchedule';
SELECT @AccountID = Account_AccountID FROM [CRE].[Note] WHERE CRENoteID = @CRENoteID;

CREATE TABLE #tmpLIBORSchedule
(
    [EventID] UNIQUEIDENTIFIER
)

INSERT INTO #tmpLIBORSchedule
(
  [EventID] 
)
SELECT  
  [EventID] 
 FROM [CORE].[LIBORSchedule] ls
WHERE ls.EventId IN 
    (SELECT EventId FROM [CORE].[Event] eve 
      WHERE eve.AccountID =@AccountID 
	) 
   
   

select Top 1 EffectiveStartDate from (
select distinct CONVERT(NVARCHAR(256),eve.EffectiveStartDate,101) EffectiveStartDate
from #tmpLIBORSchedule rs
INNER JOIN [CORE].[Event] eve ON eve.EventID = rs.EventId
INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
			
LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
where n.CRENoteID = @CRENoteID and  acc.IsDeleted = 0
group by eve.EffectiveStartDate
--order by eve.EffectiveStartDate
                
union

select  distinct CONVERT(NVARCHAR(256),n.ClosingDate,101) EffectiveStartDate
from [CRE].[Note] n INNER JOIN [CORE].[Event] eve ON eve.AccountID = n.Account_AccountID
INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
where n.CRENoteID = @CRENoteID and  acc.IsDeleted = 0
) a
			
Drop Table #tmpLIBORSchedule
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

END

