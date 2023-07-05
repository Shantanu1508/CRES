

CREATE PROCEDURE [dbo].[usp_GetIndexesExportData] --'0ffb2916-876a-4e3c-ae6d-86672aa1508d','0ffb2916-876a-4e3c-ae6d-86672aa1508d',null
(
@UserID UNIQUEIDENTIFIER,
@ScenarioID UNIQUEIDENTIFIER,
@TotalCount INT OUTPUT 
) 
as
BEGIN

  SET NOCOUNT ON;
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @cols AS NVARCHAR(MAX);
					DECLARE @cols1 AS NVARCHAR(MAX),
@query  AS NVARCHAR(MAX),
@indexLookUPId int,
@rowcount INT,
@daysinterval int=30



	SET @indexLookUPId=32

		Select 	@TotalCount =count(Date) 	
				 from Core.Indexes WITH(NOLOCK)
				 where AnalysisID=@ScenarioID


				 select @cols = STUFF((SELECT ',ISNULL(' + QUOTENAME( col.Name ) +','''') as [' +col.Name +']'       
	from(
	select Name from core.Lookup where ParentID=@indexLookUPId and Name <>'N/A' 
	)col
				   
		FOR XML PATH(''), TYPE
		).value('.', 'NVARCHAR(MAX)') 
	,1,1,'')


	select @cols1 = STUFF((SELECT ',' + QUOTENAME( col.Name )       
	from(
	select Name from core.Lookup where ParentID=@indexLookUPId and Name <>'N/A' 
	)col
				   
		FOR XML PATH(''), TYPE
		).value('.', 'NVARCHAR(MAX)') 
	,1,1,'')


    BEGIN
		
	set @query = N' 
	SELECT LEFT(CONVERT(VARCHAR, ISNULL(Date,''''), 101), 10) as Date ,' + @cols + N'
	FROM (Select 				
		  ind.Date      
		  ,l.Name
		  ,(CAST(cast(isnull(ind.Value,0) as numeric(18,15))  as VARCHAR) ) as Value
			 from Core.Indexes ind left join Core.lookup l on ind.IndexType =l.LookupID
			 where AnalysisID='''+convert(varchar(300),@ScenarioID)+'''
			  union 
			Select 				
		  null Date      
		  ,l.Name
		  ,'''' Value
		 from Core.lookup l where ParentID='''+convert(varchar(MAX),@indexLookUPId)+'''  and Name <>''N/A'' 
		  and not exists (Select *
			 from Core.Indexes ind left join Core.lookup l on ind.IndexType =l.LookupID
			 where AnalysisID='''+convert(varchar(300),@ScenarioID)+''')

	) as sq_up
	PIVOT (
	MIN([Value])
	FOR [Name] IN (' + @cols1 + N')
	) as p order by p.date ASC'
	
PRINT(@query)
EXEC sp_executesql @query;

	END


  -- Set isolation level to original isolation level
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

 END


 

