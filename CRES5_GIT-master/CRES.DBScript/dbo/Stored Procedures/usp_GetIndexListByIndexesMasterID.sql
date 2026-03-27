-- [dbo].[usp_GetIndexListByIndexesMasterID] 'b0e6697b-3534-4c09-be0a-04473401ab93','eec4e3cb-dc63-4ed9-9c0b-5a7d7f65c96b',0,30,0

CREATE PROCEDURE [dbo].[usp_GetIndexListByIndexesMasterID] --'a617c185-a618-4320-ada5-9f3d07d35185','a617c185-a618-4320-ada5-9f3d07d35185',0,30,0
(
 @UserID UNIQUEIDENTIFIER,
 @IndexesMasterGuid UNIQUEIDENTIFIER,
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
@daysinterval int=30,
@checkdaysinterval int=30


  DECLARE @IndexesMasterID int
  SET @IndexesMasterID = (SELECT IndexesMasterID FROM core.IndexesMaster WHERE IndexesMasterGuid = @IndexesMasterGuid )


SET @indexLookUPId=32

	Select 	@TotalCount =count(Date) 	
			 from Core.Indexes 
			 where IndexesMasterID=@IndexesMasterID

if(@TotalCount>=30)
Begin
	Select  @rowcount=count(Date) 
					from Core.Indexes 
			 where IndexesMasterID=@IndexesMasterID and date between getdate()-@daysinterval and getdate()+@daysinterval
			 IF(@rowcount<30)
			 BEGIN
				while(@rowcount<30)
				BEGIN

	set @daysinterval=@daysinterval+30;
	Select  @rowcount=count(Date) 
					from Core.Indexes 
			 where IndexesMasterID=@IndexesMasterID and date between getdate()-@daysinterval and getdate()+@daysinterval


			
						if(@rowcount>=30)
							BEGIN
							break;
							END

				END
			END
END


select @cols = STUFF((SELECT ',ISNULL(' + QUOTENAME( col.Name ) +','''') as [' +col.Name +']'       
from(
select Name from core.Lookup where ParentID=@indexLookUPId and Name <>'N/A' and ISNULL(statusid,1) = 1
)col
				   
    FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)') 
,1,1,'')


select @cols1 = STUFF((SELECT ',' + QUOTENAME( col.Name )       
from(
select Name from core.Lookup where ParentID=@indexLookUPId and Name <>'N/A' and ISNULL(statusid,1) = 1
)col
				   
    FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)') 
,1,1,'')


print @TotalCount


	if(@TotalCount>=30)
		BEGIN
PRINT 'if'

	set @query = N' 
	SELECT ISNULL(Date,'''') as Date ,' + @cols + N'
	FROM (Select 				
		  ind.Date      
		  ,l.Name
		  ,CAST(CAST(isnull(ind.Value,0)as decimal(28,7)) as nvarchar(256)) as  Value
			 from Core.Indexes ind 
			 left join Core.lookup l on ind.IndexType =l.LookupID and ISNULL(l.statusid,1) = 1
			 where IndexesMasterID='''+convert(varchar(300),@IndexesMasterID)+'''
			  union 
			Select 				
		  null Date      
		  ,l.Name
		  ,'''' Value
		 from Core.lookup l where ParentID='''+convert(varchar(MAX),@indexLookUPId)+'''  and Name <>''N/A'' and ISNULL(statusid,1) = 1
		  and not exists (Select *
			 from Core.Indexes ind left join Core.lookup l on ind.IndexType =l.LookupID and ISNULL(statusid,1) = 1
			 where IndexesMasterID='''+convert(varchar(300),@IndexesMasterID)+''')

	) as sq_up
	PIVOT (
	MIN([Value])
	FOR [Name] IN (' + @cols1 + N')
	) as p where p.[Date] BETWEEN DATEADD(MONTH, -2, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)) AND (SELECT MAX([Date]) FROM Core.Indexes) ORDER BY p.[Date]'

	end
	else if(@IndexesMasterGuid = '00000000-0000-0000-0000-000000000000')
	begin
	PRINT 'ELSE'
	set @query = N' 
	SELECT ISNULL(Date,''1900-01-01T00:00:00'') as Date ,' + @cols + N'
	FROM (Select 				
		  null Date      
		  ,l.Name
		  ,'''' Value
		 from Core.lookup l where ParentID='''+convert(varchar(MAX),@indexLookUPId)+'''  and Name <>''N/A'' and ISNULL(statusid,1) = 1
		  
	) as sq_up
	PIVOT (
	MIN([Value])
	FOR [Name] IN (' + @cols1 + N')
	) as p  order by p.date'


	end
	----
	else
	begin
	PRINT 'ELSE'
	set @query = N' 
	SELECT ISNULL(Date,'''') as Date ,' + @cols + N'
	FROM (Select 				
		  ind.Date      
		  ,l.Name
		  ,CAST(CAST(isnull(ind.Value,0)as decimal(28,7)) as nvarchar(256)) as Value
			 from Core.Indexes ind left join Core.lookup l on ind.IndexType =l.LookupID and ISNULL(statusid,1) = 1
			 where IndexesMasterID='''+convert(varchar(300),@IndexesMasterID)+'''
			  union 
			Select 				
		  null Date      
		  ,l.Name
		  ,'''' Value
		 from Core.lookup l where ParentID='''+convert(varchar(MAX),@indexLookUPId)+'''  and Name <>''N/A'' and ISNULL(statusid,1) = 1
		  and not exists (Select *
			 from Core.Indexes ind left join Core.lookup l on ind.IndexType =l.LookupID and ISNULL(statusid,1) = 1
			 where IndexesMasterID='''+convert(varchar(300),@IndexesMasterID)+'''
			 )

	) as sq_up
	PIVOT (
	MIN([Value])
	FOR [Name] IN (' + @cols1 + N')
	) as p  order by p.date'


	end

Select 	@TotalCount=cOUNT(DISTINCT ind.Date )
			 from Core.Indexes ind 
			 left join Core.lookup l on ind.IndexType =l.LookupID and ISNULL(statusid,1) = 1
			 where IndexesMasterID=@IndexesMasterID



PRINT(@IndexesMasterID)
PRINT(@query)
EXEC sp_executesql @query;


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
 END
GO

