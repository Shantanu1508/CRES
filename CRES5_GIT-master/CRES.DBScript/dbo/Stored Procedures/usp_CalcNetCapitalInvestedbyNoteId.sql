--[dbo].[usp_CalcNetCapitalInvestedbyNoteId] 'EC0C4EAC-9F14-40EB-8728-E7B05651A1C0'
CREATE PROCEDURE [dbo].[usp_CalcNetCapitalInvestedbyNoteId]  
 @NoteID as uniqueidentifier   
AS   
BEGIN   
    
	SET NOCOUNT ON;   
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED   

	DECLARE @DealID UNIQUEIDENTIFIER = (SELECT DealID FROM [CRE].[Note] WHERE NoteID = @NoteID)
	DECLARE @NetCapitalInvested DECIMAL (28, 15)

    SELECT 
        @NetCapitalInvested = CASE 
            WHEN EXISTS (
                SELECT 1 
                FROM [CRE].[Note] n2 
                WHERE n2.DealID = @DealID 
                  AND n2.NoteType = 901
            ) 
            THEN ISNULL(n.UPBAtForeclosure, 0) + ISNULL(ff.FFValue, 0)
            ELSE NULL 
        END 

    FROM [CRE].[Note] n

    LEFT JOIN (
        SELECT 
            n.NoteID, 
            SUM(fs.Value) AS FFValue
        FROM [CORE].[FundingSchedule] fs
        INNER JOIN [CORE].[Event] e ON e.EventID = fs.EventId
        INNER JOIN (
            SELECT 
                acc.AccountID,
                MAX(eve.EffectiveStartDate) AS EffectiveStartDate,
                eve.EventTypeID,
                eve.StatusID
            FROM [CORE].[Event] eve
            INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
            INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
            WHERE eve.EventTypeID = (SELECT LookupID FROM CORE.[Lookup] WHERE Name = 'FundingSchedule')
              AND acc.IsDeleted = 0
              AND eve.StatusID = (SELECT LookupID FROM Core.Lookup WHERE name = 'Active' AND ParentID = 1)
            GROUP BY acc.AccountID, eve.EventTypeID, eve.StatusID
        ) sEvent ON sEvent.AccountID = e.AccountID 
                  AND e.EffectiveStartDate = sEvent.EffectiveStartDate 
                  AND e.EventTypeID = sEvent.EventTypeID
        INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
        INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
        WHERE sEvent.StatusID = e.StatusID
          AND acc.IsDeleted = 0
          AND n.NoteID = @NoteID
          AND fs.Date >= n.ClosingDate
          AND fs.Date <= CAST(GETDATE() AS DATE)
          AND fs.PurposeID != 875

        GROUP BY n.NoteID

    ) ff ON ff.NoteID = n.NoteID

	where n.NoteID = @NoteID

	UPDATE [CRE].[Note]
    SET [CRE].[Note].NetCapitalInvested = @NetCapitalInvested
    WHERE NoteID = @NoteID

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED

	END
   