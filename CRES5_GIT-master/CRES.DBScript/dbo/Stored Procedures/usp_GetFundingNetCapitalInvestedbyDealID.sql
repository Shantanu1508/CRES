--[dbo].[usp_GetFundingNetCapitalInvestedbyDealID] '8D99AA6B-67A9-4C22-AD25-B3E56379B47F'

Create PROCEDURE [dbo].[usp_GetFundingNetCapitalInvestedbyDealID]
(
    @DealID UNIQUEIDENTIFIER
)
	
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	Select 
	NoteID,
	ISNULL(UPBAtForeclosure, 0) AS UPBAtForeclosure,
    ISNULL(FFValue, 0) AS FFValue,
	NoteType,
	CASE 
        WHEN EXISTS (SELECT 1 FROM [CRE].[Note] n2 WHERE n2.DealID = @DealID AND n2.NoteType = 901) 
        THEN ISNULL(UPBAtForeclosure, 0) + ISNULL(FFValue, 0)
        ELSE NULL 
    END AS NetCapitalInvested

	FROM
    (
	Select n.noteid as NoteID,n.UPBAtForeclosure,SUM(fs.Value) as FFValue, n.NoteType as NoteType
	from [CORE].FundingSchedule fs
	INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
	INNER JOIN 
				(
						
					Select 
						(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
						MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
						from [CORE].[Event] eve
						INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
						INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
						where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')
						and acc.IsDeleted = 0
						and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
						GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID

				) sEvent

	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID

	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID

	where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0
	and n.DealID = @DealID  
	and fs.Date >= n.ClosingDate
	AND fs.Date <= CAST(GETDATE() AS DATE)

	group by n.noteid,UPBAtForeclosure, n.NoteType

	) as result

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END