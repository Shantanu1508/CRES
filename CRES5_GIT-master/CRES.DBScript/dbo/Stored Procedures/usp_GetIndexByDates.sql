

CREATE PROCEDURE [dbo].[usp_GetIndexByDates] --null,null--'01/1/2016' ,  '01/01/2016'
(
@StartDate Date=null,
@EndDate  Date=null
) 
as
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @cols AS NVARCHAR(MAX),
 @cols2 AS NVARCHAR(MAX),
@query  AS NVARCHAR(MAX),
@indexLookUPId int


SET @indexLookUPId=32




  if(@StartDate is null and @EndDate is null)

BEGIN
print 'StartDate EndDate is null'

select @cols = STUFF((SELECT ',ISNULL(' + QUOTENAME( col.Name  )  +',0) as '   +    QUOTENAME( col.Name  )       
from(
select Name from core.Lookup where ParentID=@indexLookUPId and Name <>'N/A' 
)col
				   
    FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)') 
,1,1,'')
	

	select @cols2 = STUFF((SELECT ',' + QUOTENAME( col.Name )        
from(
select Name from core.Lookup where ParentID=@indexLookUPId and Name <>'N/A' 
)col
				   
    FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)') 
,1,1,'')


PRINT(@cols)
PRINT(@cols2)


set @query = N' 
SELECT Date,' + @cols + N'
FROM (			
		Select 				
      ind.Date      
	  ,l.Name
	  ,isnull(ind.Value,0) as Value
		 from    Core.Indexes ind left join Core.lookup l on ind.IndexType =l.LookupID
) as sq_up
PIVOT (
MIN([Value])
FOR [Name] IN (' + @cols2 + N')
) as p'


END
ELSE
BEGIN

if( @EndDate is NULL) 
BEGIN
print 'END'
SET @EndDate=GETDATE();

select @cols = STUFF((SELECT ',ISNULL(' + QUOTENAME( col.Name  )  +',0) as '   +    QUOTENAME( col.Name  )   
from(
select Name from core.Lookup where ParentID=@indexLookUPId and Name <>'N/A'
)col
				   
    FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)') 
,1,1,'')

	
select @cols2 = STUFF((SELECT ',' + QUOTENAME( col.Name )        
from(
select Name from core.Lookup where ParentID=32
)col
				   
    FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)') 
,1,1,'')

set @query = N' 
SELECT Date,' + @cols + N'
FROM (			
	Select 				
      ind.Date      
	  ,l.Name
    ,isnull(ind.Value,0) as Value
		 from    Core.Indexes ind left join Core.lookup l on ind.IndexType =l.LookupID
		   where ind.Date between '''+ cast(@StartDate as varchar(20))  +''' and   '''+ cast(@EndDate as  Varchar(20))  +' ''
) as sq_up
PIVOT (
MIN([Value])
FOR [Name] IN (' + @cols2 + N')
) as p'

  END
  


  if( (@StartDate is not NULL)  or (@EndDate is not null)) 
BEGIN
--SET @EndDate=GETDATE();

select @cols = STUFF((SELECT ',ISNULL(' + QUOTENAME( col.Name  )  +',0) as '   +    QUOTENAME( col.Name  )   
from(
select Name from core.Lookup where ParentID=@indexLookUPId and Name <>'N/A'
)col
				   
    FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)') 
,1,1,'')

	
select @cols2 = STUFF((SELECT ',' + QUOTENAME( col.Name )        
from(
select Name from core.Lookup where ParentID=32
)col
				   
    FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)') 
,1,1,'')

set @query = N' 
SELECT Date,' + @cols + N'
FROM (			
	Select 				
      ind.Date      
	  ,l.Name
    ,isnull(ind.Value,0) as Value
		 from    Core.Indexes ind left join Core.lookup l on ind.IndexType =l.LookupID
		   where ind.Date between '''+ cast(@StartDate as varchar(20))  +''' and   '''+ cast(@EndDate as  Varchar(20))  +' ''
) as sq_up
PIVOT (
MIN([Value])
FOR [Name] IN (' + @cols2 + N')
) as p'

  END




END

PRINT(@query)
exec sp_executesql @query;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
 END
