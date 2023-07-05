


CREATE PROCEDURE [dbo].[usp_LCGetPIKScheduleByCRENoteID] --'N09262016'
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

select @cols = STUFF((SELECT ',' + QUOTENAME( Convert (nvarchar(MAX), cast((ROW_NUMBER() over (order by pik.PIKScheduleID))  as varchar(50)), 101) ) 
					from [CORE].[PIKSchedule] pik
			INNER JOIN [CORE].[Event] eve ON eve.EventID = pik.EventId
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
			LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
			where n.CRENoteID = @CRENoteID and  acc.IsDeleted = 0
					group by eve.EffectiveStartDate,pik.PIKScheduleID
                   
					FOR XML PATH(''), TYPE
					).value('.', 'NVARCHAR(MAX)') 
					,1,1,'')
					
	PRINT(@cols)

	set @query = N'SELECT ' + @cols + N'
  FROM (
  
	SELECT [RowCount], Amount, [0]
	FROM (			
			Select 
			cast((ROW_NUMBER() over (order by pik.PIKScheduleID))  as varchar(MAX))   as [RowCount]
			,ISNULL(Convert (nvarchar(MAX), eve.EffectiveStartDate, 101),'''') [Effective Date],
			ISNULL(CAST(	accSourceAccount.Name	 as nvarchar(MAX)),'''') as 	[PIK Source Note]	,
			ISNULL(CAST(	accTargetAccount.Name	 as nvarchar(MAX)),'''') as 	[PIK Target Note]	,
			ISNULL(CAST(	pik.AdditionalIntRate	 as nvarchar(MAX)),'''') as 	[Additional PIK interest Rate]	,
			ISNULL(CAST(	pik.AdditionalSpread	 as nvarchar(MAX)),'''') as 	[Additional PIK Spread]	,
			ISNULL(CAST(	pik.IndexFloor	 as nvarchar(MAX)),'''') as 	[PIK Index Floor]	,
			ISNULL(CAST(	pik.IntCompoundingRate	 as nvarchar(MAX)),'''') as 	[PIK Interest Compounding Rate]	,
			ISNULL(CAST(	pik.IntCompoundingSpread	 as nvarchar(MAX)),'''') as 	[PIK Interest Compounding Spread]	,
			ISNULL(Convert (nvarchar(MAX),	pik.StartDate	, 101),'''') as 	[PIK Start Date]	,
			ISNULL(Convert (nvarchar(MAX),	pik.EndDate	, 101),'''') as 	[PIK End Date]	,
			ISNULL(CAST(	pik.IntCapAmt	 as nvarchar(MAX)),'''') as 	[PIK Interest Cap ($)]	,
			ISNULL(CAST(	pik.PurBal	 as nvarchar(MAX)),'''') as 	[Purchased PIK Balance]	,
			ISNULL(CAST(	pik.AccCapBal	 as nvarchar(MAX)),'''') as 	[Note & PIK Cap Balance]	
			
			from [CORE].[PIKSchedule] pik
			INNER JOIN [CORE].[Event] eve ON eve.EventID = pik.EventId
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
			left JOIN [CORE].[Account] accSourceAccount ON accSourceAccount.AccountID= pik.SourceAccountID
			left JOIN [CORE].[Account] accTargetAccount ON accTargetAccount.AccountID= pik.TargetAccountID

			LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
			where n.CRENoteID = '''+ cast(@CRENoteID as varchar(256))+'''  and  acc.IsDeleted = 0


			) as sq_source
		UNPIVOT (Amount FOR [0] IN
		([Effective Date],[PIK Source Note],[PIK Target Note],[Additional PIK interest Rate],[Additional PIK Spread],[PIK Index Floor],[PIK Interest Compounding Rate],[PIK Interest Compounding Spread],[PIK Start Date],[PIK End Date],[PIK Interest Cap ($)],[Purchased PIK Balance],[Note & PIK Cap Balance])


	) as sq_up
         
		 
		 ) as sq  
     PIVOT (
        MIN(Amount)
        FOR [RowCount] IN
           (' + @cols + N')
           ) as p


ORDER BY CASE WHEN [0] = ''Effective Date'' THEN 1
WHEN [0] = ''PIK Source Note'' THEN 2
WHEN [0] = ''PIK Target Note'' THEN 3
WHEN [0] = ''Additional PIK interest Rate'' THEN 4
WHEN [0] = ''Additional PIK Spread'' THEN 5
WHEN [0] = ''PIK Index Floor'' THEN 6
WHEN [0] = ''PIK Interest Compounding Rate'' THEN 7
WHEN [0] = ''PIK Interest Compounding Spread'' THEN 8
WHEN [0] = ''PIK Start Date'' THEN 9
WHEN [0] = ''PIK End Date'' THEN 10
WHEN [0] = ''PIK Interest Cap ($)'' THEN 11
WHEN [0] = ''Purchased PIK Balance'' THEN 12
WHEN [0] = ''Note & PIK Cap Balance'' THEN 13
ELSE [0] END ASC
		    '


EXEC(@query);

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
