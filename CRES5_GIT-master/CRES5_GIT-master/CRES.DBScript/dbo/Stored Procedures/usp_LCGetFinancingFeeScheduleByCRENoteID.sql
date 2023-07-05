


CREATE PROCEDURE [dbo].[usp_LCGetFinancingFeeScheduleByCRENoteID] --'N09262016'
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

select @cols = STUFF((SELECT ',' + QUOTENAME( Convert (nvarchar(MAX), cast((ROW_NUMBER() over (order by ffs.FinancingFeeScheduleID))  as varchar(50)), 101) ) 
				from [CORE].[FinancingFeeSchedule] ffs
				INNER JOIN [CORE].[Event] eve ON eve.EventID = ffs.EventId
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
				LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
				LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = ffs.ValueTypeID
				where n.CRENoteID = @CRENoteID and  acc.IsDeleted = 0 
				and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)
				group by eve.EffectiveStartDate,ffs.FinancingFeeScheduleID
                   
				FOR XML PATH(''), TYPE
				).value('.', 'NVARCHAR(MAX)') 
				,1,1,'')

PRINT(@cols);

set @query = N'SELECT ' + @cols + N'
  FROM (
  
	SELECT [RowCount], Amount, [0]
	FROM (			
			Select 
			cast((ROW_NUMBER() over (order by ffs.FinancingFeeScheduleID))  as varchar(50))   as [RowCount]
			,ISNULL(Convert (nvarchar(MAX), eve.EffectiveStartDate, 101) ,'''')  as [Effective Date]
			,ISNULL(Convert (nvarchar(MAX), ffs.[Date], 101) ,'''') as [Date]
			,ISNULL(CAst(LValueTypeID.Name  as nvarchar(MAX)) ,'''') as [Value Type]
			,ISNULL(Cast(ffs.Value as nvarchar(MAX)) ,'''') as [Value]
			
			from [CORE].[FinancingFeeSchedule] ffs
			INNER JOIN [CORE].[Event] eve ON eve.EventID = ffs.EventId
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
			LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
			LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = ffs.ValueTypeID
			where n.CRENoteID = '''+ cast(@CRENoteID as varchar(256))+''' and  acc.IsDeleted = 0
			and eve.StatusID = (Select LookupID from Core.Lookup where name = ''Active'' and parentid = 1)


			) as sq_source
		UNPIVOT (Amount FOR [0] IN
		([Effective Date],[Date], [Value Type],[Value])


	) as sq_up
         
		 
		 ) as sq  
     PIVOT (
        MIN(Amount)
        FOR [RowCount] IN
           (' + @cols + N')
           ) as p

ORDER BY CASE WHEN [0] = ''Effective Date'' THEN 1
WHEN [0] = ''Value'' THEN 2
WHEN [0] = ''Value Type'' THEN 3
WHEN [0] = ''Date'' THEN 4
ELSE [0] END ASC'


PRINT(@query);
EXEC(@query);

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
