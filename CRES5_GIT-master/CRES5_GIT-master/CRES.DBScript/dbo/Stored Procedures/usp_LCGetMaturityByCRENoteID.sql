


CREATE PROCEDURE [dbo].[usp_LCGetMaturityByCRENoteID] --'N09262016'
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


 
 select @cols = STUFF((SELECT ',' + QUOTENAME( Convert (nvarchar(MAX), cast((ROW_NUMBER() over (order by mat.MaturityID))  as varchar(50)), 101) ) 
					from [CORE].[Maturity] mat
					INNER JOIN [CORE].[Event] eve ON eve.EventID = mat.EventId
					INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
					INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
					LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
					where n.CRENoteID = @CRENoteID and acc.IsDeleted = 0 and eve.StatusID = 1
					group by eve.EffectiveStartDate,mat.MaturityID
                   
					FOR XML PATH(''), TYPE
					).value('.', 'NVARCHAR(MAX)') 
					,1,1,'')
					
	PRINT(@cols)
	set @query = N'SELECT ' + @cols + N'
  FROM (
  
	SELECT [RowCount], Amount, [0]
	FROM (			
			Select 
			cast((ROW_NUMBER() over (order by mat.MaturityID))  as varchar(50))   as [RowCount]
			,ISNULL(Convert (nvarchar(MAX), eve.EffectiveStartDate, 101),'''') [Effective Date]
			,ISNULL(Convert (nvarchar(MAX), mat.SelectedMaturityDate, 101) ,'''') as [Selected Maturity Date]
			from [CORE].[Maturity] mat
			INNER JOIN [CORE].[Event] eve ON eve.EventID = mat.EventId
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
			LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
			where n.CRENoteID = '''+ cast(@CRENoteID as varchar(256))+'''  and acc.IsDeleted = 0  and eve.StatusID = 1


			) as sq_source
		UNPIVOT (Amount FOR [0] IN
		([Effective Date],[Selected Maturity Date])


	) as sq_up
         
		 
		 ) as sq  
     PIVOT (
        MIN(Amount)
        FOR [RowCount] IN
           (' + @cols + N')
           ) as p


ORDER BY CASE WHEN [0] = ''Effective Date'' THEN ''1''
WHEN [0] = ''Selected Maturity Date'' THEN ''2''
ELSE [0] END ASC

		    '

EXEC(@query);

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
