


CREATE PROCEDURE [dbo].[usp_LCGetFinancingScheduleByCRENoteID] --'N09262016'
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


select @cols = STUFF((SELECT ',' + QUOTENAME( Convert (nvarchar(MAX), cast((ROW_NUMBER() over (order by fs.FinancingScheduleID))  as varchar(50)), 101) ) 
				from [CORE].[FinancingSchedule] fs
				INNER JOIN [CORE].[Event] eve ON eve.EventID = fs.EventId
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
				INNER JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID

				LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = fs.ValueTypeID
				LEFT JOIN [CORE].[Lookup] LIndexTypeID ON LValueTypeID.LookupID = fs.IndexTypeID
				LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LValueTypeID.LookupID = fs.IntCalcMethodID
				where n.CRENoteID = @CRENoteID  and  acc.IsDeleted = 0
				and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)
				group by eve.EffectiveStartDate,fs.FinancingScheduleID
                   
				FOR XML PATH(''), TYPE
				).value('.', 'NVARCHAR(MAX)') 
				,1,1,'')

PRINT(@cols);



	set @query = N'SELECT ' + @cols + N'
  FROM (
  
	SELECT [RowCount], Amount, [0]
	FROM (			
			Select 
			cast((ROW_NUMBER() over (order by fs.FinancingScheduleID))  as varchar(50))   as [RowCount]
			,ISNULL(Convert (nvarchar(MAX), eve.EffectiveStartDate, 101)  ,'''')  as [Effective Date]
			,ISNULL(Convert (nvarchar(MAX), fs.[Date], 101) ,'''') as [Date]
			,ISNULL(CAst(LValueTypeID.Name  as nvarchar(MAX)) ,'''') as [Value Type]
			,ISNULL(Cast(fs.Value as nvarchar(MAX)) ,'''') as [Value]
			,ISNULL(Cast(LIndexTypeID.Name  as nvarchar(MAX)) ,'''') as [Index Type]
			,ISNULL(Cast(LIntCalcMethodID.Name  as nvarchar(MAX)) ,'''') as [Int Calc Method]
			,ISNULL(Cast(LCurrencyCode.Name  as nvarchar(MAX)) ,'''') as [Financing Currency]
			
			from [CORE].[FinancingSchedule] fs
				INNER JOIN [CORE].[Event] eve ON eve.EventID = fs.EventId
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
				INNER JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
				LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = fs.ValueTypeID
				LEFT JOIN [CORE].[Lookup] LIndexTypeID ON LValueTypeID.LookupID = fs.IndexTypeID
				LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LValueTypeID.LookupID = fs.IntCalcMethodID
				LEFT JOIN [CORE].[Lookup] LCurrencyCode ON LCurrencyCode.LookupID = fs.CurrencyCode 
			where n.CRENoteID = '''+ cast(@CRENoteID as varchar(256))+''' and  acc.IsDeleted = 0
				and eve.StatusID = (Select LookupID from Core.Lookup where name = ''Active'' and parentid = 1)


			) as sq_source
		UNPIVOT (Amount FOR [0] IN
		([Effective Date],[Date], [Value Type],[Value],[Index Type], [Int Calc Method],[Financing Currency])


	) as sq_up
         
		 
		 ) as sq  
     PIVOT (
        MIN(Amount)
        FOR [RowCount] IN
           (' + @cols + N')
           ) as p


		   
ORDER BY CASE WHEN [0] = ''Effective Date'' THEN 1
WHEN [0] = ''Date'' THEN 2
WHEN [0] = ''Value'' THEN 3
WHEN [0] = ''Index Type'' THEN 4
WHEN [0] = ''Int Calc Method'' THEN 5
WHEN [0] = ''Financing Currency'' THEN 6
WHEN [0] = ''Value Type'' THEN 7
ELSE [0] END ASC
'


EXEC(@query);

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
