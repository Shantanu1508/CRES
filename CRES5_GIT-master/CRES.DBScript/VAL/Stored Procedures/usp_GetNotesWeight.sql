-- Procedure
  --[VAL].[usp_GetNotesWeight]  '3/31/2024'
  
CREATE PROCEDURE [VAL].[usp_GetNotesWeight] 
(
	@MarkedDate date
) 
AS    
BEGIN    
    
	SET NOCOUNT ON;    
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
     

	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = @MarkedDate)

	DECLARE @cols_Header AS NVARCHAR(MAX), @query AS NVARCHAR(MAX) ;

	SELECT @cols_Header = STUFF((SELECT ',' + QUOTENAME(cAST(Header as nvarchar(100)))   
    From(  
		 Select Distinct Header,SortOrder
		 from [val].[NotesWeight] ds  
		 where ds.MarkedDateMasterID = @MarkedDateMasterID
    )a   
	order by SortOrder
	FOR XML PATH(''), TYPE  
	).value('.', 'NVARCHAR(MAX)')   
	,1,1,'')  ;


set @query = N'  
SELECT PropertyType , '+@cols_Header+'
FROM  
(
  SELECT PropertyType, [Value], [Header]
  FROM [val].[NotesWeight] Where MarkedDateMasterID = ' + Cast(@MarkedDateMasterID as nvarchar(256)) + '
) AS SourceTable  
PIVOT  
(  
  AVG([Value])  
  FOR Header IN ('+@cols_Header+')  
) AS PivotTable;  '

--print(@query)  

IF @cols_Header IS NULL
BEGIN
	Select 
		NULL as 'PropertyType',
		NULL as '1',
		NULL as '2',
		NULL as '3',
		NULL as '4',
		NULL as '5',
		NULL as 'M',
		NULL as 'P'
END
ELSE
BEGIN
	EXEC(@query)
END

 SET TRANSACTION ISOLATION LEVEL READ COMMITTED  

END