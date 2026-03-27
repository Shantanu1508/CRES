-- exec [dbo].[usp_IndexesBydates] 'b0e6697b-3534-4c09-be0a-04473401ab93','852224d0-0532-4ea7-9ef4-cb47c68b8833',null,'2015-02-01',0

CREATE PROCEDURE [dbo].[usp_GetIndexListByDates] --'0ffb2916-876a-4e3c-ae6d-86672aa1508d','0ffb2916-876a-4e3c-ae6d-86672aa1508d',null,'2017-01-10',0
(
@UserID UNIQUEIDENTIFIER,
@IndexesMasterGuid UNIQUEIDENTIFIER,
@Fromdate date=null,
@Todate date=null,
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
@daysinterval int=180

Declare @MinDate Date;
Declare @MaxDate Date;

DECLARE @IndexesMasterID int
  SET @IndexesMasterID = (SELECT IndexesMasterID FROM core.IndexesMaster WHERE IndexesMasterGuid = @IndexesMasterGuid );


Select  @MinDate= MIN(Date) from Core.Indexes where IndexesMasterID=@IndexesMasterID 
Select  @MaxDate= MAX(Date) from Core.Indexes where IndexesMasterID=@IndexesMasterID 


SET @indexLookUPId=32
Select 	@TotalCount =count(Date) from Core.Indexes where IndexesMasterID=@IndexesMasterID

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
	if(@Fromdate IS NULL)
	BEGIN
		set @Fromdate =  DATEADD(day,-(@daysinterval),@Todate); 
		set @Todate = DATEADD(day,-1,@Todate);
	
		-----------Start----------------
		Select 	@TotalCount =count(Date) from Core.Indexes  where IndexesMasterID=@IndexesMasterID and date between @Fromdate and @Todate
		
		if(@TotalCount = 0)
		Begin	
			Select 	@rowcount =count(Date) from Core.Indexes  where IndexesMasterID=@IndexesMasterID and date between @Fromdate and @Todate
			
			while(@rowcount < 30)
			BEGIN
				set @daysinterval = @daysinterval + 30;
				Select  @rowcount=count(Date) from Core.Indexes where IndexesMasterID=@IndexesMasterID and date between DATEADD(day,-(@daysinterval),@Todate) and @Todate

				if(@rowcount>=30)
				BEGIN					
					set @Fromdate =  DATEADD(day,-(@daysinterval),@Todate); 
					set @Todate = @Todate;
					
					break;
				END
				ELSE
				BEGIN
					IF(DATEADD(day,-(@daysinterval),@Todate) <= @MinDate ) 
					BEGIN					
						set @Fromdate =  DATEADD(day,-(@daysinterval),@Todate); 
						set @Todate = @Todate;
					
						break;
					END
				END
			END
		END
		----------END-----------------
		
		print 'if'
		print @Fromdate
		print @Todate

		set @query = N' 
		SELECT ISNULL(Date,'''') as Date ,' + @cols + N'
		FROM (
			Select 				
			ind.Date      
			,l.Name
			,CAST(CAST(isnull(ind.Value,0)as decimal(28,7)) as nvarchar(256))  as Value
			from Core.Indexes ind left join Core.lookup l on ind.IndexType =l.LookupID
			where IndexesMasterID='''+convert(varchar(300),@IndexesMasterID)+'''
			union 
			Select 				
			null Date      
			,l.Name
			,'''' Value
			from Core.lookup l where ParentID='''+convert(varchar(MAX),@indexLookUPId)+'''  and Name <>''N/A'' 
			and not exists (Select *
			from Core.Indexes ind left join Core.lookup l on ind.IndexType =l.LookupID
			where IndexesMasterID='''+convert(varchar(300),@IndexesMasterID)+''')

		) as sq_up
		PIVOT (
		MIN([Value])
		FOR [Name] IN (' + @cols1 + N')
		) as p where p.Date between + ''' +  Cast(@Fromdate  as varchar(50))  + ''' and ''' + Cast(@Todate as varchar(50)) +''' order by p.date ASC'
	

	Select 	@TotalCount =count(Date) from Core.Indexes  where IndexesMasterID=@IndexesMasterID and date between @Fromdate and @Todate

PRINT(@query)
EXEC sp_executesql @query;

END
ELSE
BEGIN	
	print 'ELSE'	
	set @Todate = DATEADD(day,+@daysinterval,@Fromdate); --@Todate + @daysinterval;
	set @Fromdate =DATEADD(day,1,@Fromdate);--@Fromdate


	---------Start------------------
	Select 	@TotalCount =count(Date) from Core.Indexes  where IndexesMasterID=@IndexesMasterID and date between @Fromdate and @Todate
		
	if(@TotalCount = 0)
	Begin	
		Select 	@rowcount =count(Date) from Core.Indexes  where IndexesMasterID=@IndexesMasterID and date between @Fromdate and @Todate
		while(@rowcount < 30)
		BEGIN
			set @daysinterval = @daysinterval + 30;
			Select  @rowcount=count(Date) from Core.Indexes where IndexesMasterID=@IndexesMasterID and date between @Fromdate and DATEADD(day,+(@daysinterval),@Fromdate)

			if(@rowcount>=30)
			BEGIN					
				set @Fromdate =  @Fromdate; 
				set @Todate = DATEADD(day,+(@daysinterval),@Fromdate);
					
				break;
			END
			ELSE
			BEGIN
				IF(DATEADD(day,+(@daysinterval),@Fromdate) >= @MaxDate ) 
				BEGIN					
					set @Fromdate = @Fromdate; 
					set @Todate = DATEADD(day,+(@daysinterval),@Fromdate);
					
					break;
				END
			END

		END			
	END
	--------END-------------------

	print @Todate
	print @Fromdate

	set @query = N' 
	SELECT ISNULL(Date,'''') as Date ,' + @cols + N'
	FROM (
		Select 				
		ind.Date      
		,l.Name
		,CAST(CAST(isnull(ind.Value,0) as decimal(28,7)) as nvarchar(256))  as Value
		from Core.Indexes ind left join Core.lookup l on ind.IndexType =l.LookupID
		where IndexesMasterID='''+convert(varchar(300),@IndexesMasterID)+'''
		union 
		Select 				
		null Date      
		,l.Name
		,'''' Value
		from Core.lookup l where ParentID='''+convert(varchar(MAX),@indexLookUPId)+'''  and Name <>''N/A'' 
		and not exists (Select *
		from Core.Indexes ind left join Core.lookup l on ind.IndexType =l.LookupID
		where IndexesMasterID='''+convert(varchar(300),@IndexesMasterID)+''')

	) as sq_up
	PIVOT (
	MIN([Value])
	FOR [Name] IN (' + @cols1 + N')
	) as p where p.Date between + ''' +  Cast(@Fromdate  as varchar(50))  + ''' and ''' + Cast(@Todate as varchar(50)) +''' order by p.date '
	
	Select 	@TotalCount =count(Date) from Core.Indexes  where IndexesMasterID=@IndexesMasterID and date between @Fromdate and @Todate

	PRINT(@query)
	EXEC sp_executesql @query;
		
END


END
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
GO

