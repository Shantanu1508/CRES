


CREATE PROCEDURE [dbo].[usp_GetScenarioByScenarioID] --'b55d8909-25ef-4778-8756-6997e33ad9f5','852224d0-0532-4ea7-9ef4-cb47c68b8833',0,30,0
(
 @UserID UNIQUEIDENTIFIER,
@ScenarioID UNIQUEIDENTIFIER,
 @PgeIndex INT,
 @PageSize INT,
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
@daysinterval int=15,
@checkdaysinterval int=30


SET @indexLookUPId=32

	Select 	@TotalCount =count(Date) 	
			 from Core.Indexes 
			 where AnalysisID=@ScenarioID

if(@TotalCount>=30)
Begin
	Select  @rowcount=count(Date) 
					from Core.Indexes 
			 where AnalysisID=@ScenarioID and date between getdate()-@daysinterval and getdate()+@daysinterval
			 IF(@rowcount<30)
			 BEGIN
				while(@rowcount<30)
				BEGIN

	set @daysinterval=@daysinterval+30;
	Select  @rowcount=count(Date) 
					from Core.Indexes 
			 where AnalysisID=@ScenarioID and date between getdate()-@daysinterval and getdate()+@daysinterval


			
						if(@rowcount>=30)
							BEGIN
							break;
							END

				END
			END
END


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

	if(@TotalCount>=30)
		BEGIN
PRINT 'if'

	set @query = N' 
	SELECT ISNULL(Date,'''') as Date ,' + @cols + N'
	FROM (Select 				
		  ind.Date      
		  ,l.Name
		  ,CAST(isnull(ind.Value,0) as VARCHAR)  as Value
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
	) as p where p.Date between getdate() -'+ Cast(ABS(@daysinterval) as varchar(50)) + ' and  getdate()+ '+ Cast(ABS(@daysinterval) as varchar(50)) +' order by p.date'


	end
	else
	begin
	PRINT 'ELSE'
	set @query = N' 
	SELECT ISNULL(Date,'''') as Date ,' + @cols + N'
	FROM (Select 				
		  ind.Date      
		  ,l.Name
		  ,CAST(isnull(ind.Value,0) as VARCHAR)  as Value
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
	) as p  order by p.date'


	end

Select 	@TotalCount=cOUNT(DISTINCT ind.Date )
			 from Core.Indexes ind left join Core.lookup l on ind.IndexType =l.LookupID
			 where AnalysisID=@ScenarioID

PRINT(@query)
EXEC sp_executesql @query;


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
 END


 

