


CREATE PROCEDURE [dbo].[usp_LCGetStrippingScheduleByCRENoteID] --'N09262016'
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

	
select @cols = STUFF((SELECT ',' + QUOTENAME( Convert (nvarchar(MAX), cast((ROW_NUMBER() over (order by ss.StrippingScheduleID))  as varchar(50)), 101) ) 
				from [CORE].[StrippingSchedule] ss
				INNER JOIN [CORE].[Event] eve ON eve.EventID = ss.EventId
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
				LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
				LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = ss.ValueTypeID
				where n.CRENoteID = @CRENoteID and  acc.IsDeleted = 0
				and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)
                group by eve.EffectiveStartDate,ss.StrippingScheduleID
                   
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

PRINT(@cols);

	set @query = N'SELECT  ' + @cols + N'
  FROM (
  
	SELECT [RowCount], Amount, [0]
	FROM (			
			Select 
			cast((ROW_NUMBER() over (order by ss.StrippingScheduleID))  as varchar(50))   as [RowCount]
			,ISNULL(Convert (nvarchar(MAX), eve.EffectiveStartDate, 101),'''')   as [Effective Date]
			,ISNULL(Convert (nvarchar(MAX), ss.[StartDate], 101),'''') as [Start Date]
			,ISNULL(CAst(LValueTypeID.Name  as nvarchar(MAX)),'''') as [Value Type]
			,ISNULL(Cast(ss.Value as nvarchar(MAX)),'''') as [Value]
			,ISNULL(Cast(ss.IncludedLevelYield  as nvarchar(MAX)),'''') as [Included Level Yield]
			,ISNULL(Cast(ss.IncludedBasis  as nvarchar(MAX)),'''') as [Included Basis]

			from [CORE].[StrippingSchedule] ss
			INNER JOIN [CORE].[Event] eve ON eve.EventID = ss.EventId
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
			LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
			LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = ss.ValueTypeID
			where n.CRENoteID = '''+ cast(@CRENoteID as varchar(256))+''' and  acc.IsDeleted = 0
				and eve.StatusID = (Select LookupID from Core.Lookup where name = ''Active'' and parentid = 1)


			) as sq_source
		UNPIVOT (Amount FOR [0] IN
		([Effective Date],[Start Date],   [Value Type],[Value] , [Included Level Yield], [Included Basis])


	) as sq_up
         
		 
		 ) as sq  
     PIVOT (
        MIN(Amount)
        FOR [RowCount] IN
           (' + @cols + N')
           ) as p


 ORDER BY CASE WHEN [0] = ''Effective Date'' THEN ''1''
WHEN [0] = ''Start Date'' THEN ''2''
WHEN [0] = ''Value Type'' THEN ''3''
WHEN [0] = ''Value'' THEN ''4''
WHEN [0] = ''Included Level Yield'' THEN ''5''
WHEN [0] = ''Included Basis'' THEN ''6''
ELSE [0] END ASC

		    '


EXEC(@query);
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED

END
