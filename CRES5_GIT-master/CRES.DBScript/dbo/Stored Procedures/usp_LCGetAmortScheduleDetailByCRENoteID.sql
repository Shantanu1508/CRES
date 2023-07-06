


CREATE PROCEDURE [dbo].[usp_LCGetAmortScheduleDetailByCRENoteID] --'ALDEN_A'
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

select @cols = STUFF((SELECT ',' + QUOTENAME( Convert (nvarchar(MAX), eve.EffectiveStartDate , 101) ) 
             from [CORE].AmortSchedule rs
				INNER JOIN [CORE].[Event] eve ON eve.EventID = rs.EventId
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
			
				LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
				where n.CRENoteID = @CRENoteID and acc.IsDeleted = 0 and eve.StatusID = 1
                group by eve.EffectiveStartDate
                   
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')



	
set @query = N' 
SELECT Cast([Date] as DateTime) as Date,' + @cols + N'
FROM (			
		Select 
				
		eve.EffectiveStartDate  as [Effective Date]
		, rs.[Date] as [Date]
		,rs.[Value] as [Value]
				
		from [CORE].AmortSchedule rs
		INNER JOIN [CORE].[Event] eve ON eve.EventID = rs.EventId
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
				
		where n.CRENoteID = '''+ cast(@CRENoteID as varchar(256))+''' and acc.IsDeleted = 0 and eve.StatusID = 1
	
) as sq_up
PIVOT (
MIN([Value])
FOR [Effective Date] IN (' + @cols + N')
) as p

order by p.[Date]

'


PRINT(@query);
EXEC(@query);

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END