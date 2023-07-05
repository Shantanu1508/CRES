

CREATE PROCEDURE [App].[usp_GetAllFastFunction]

AS
BEGIN

--FunctionType 1-add,2-update
declare @functionname nvarchar(256)
select @functionname=FunctionName from App.FastFunction where IsDefault=1

if (@functionname IS NOT NULL)
	BEGIN
          
		   select  FunctionID, [FunctionName],
            [UpdatedDate],[IsDefault] from 
		   (
		   select    FunctionID, [FunctionName],
           UpdatedDate,Getdate() OrderByDate,[IsDefault]  FROM App.FastFunction ff where IsDefault=1
		   
		   union 
		   
		   select    FunctionID, [FunctionName],
           [UpdatedDate],[UpdatedDate] as OrderByDate,0 as [IsDefault]
		   FROM App.FastFunction ff
		   group by functionname,[UpdatedDate],FunctionID 
		   having updateddate=(select max(UpdatedDate) from App.FastFunction where FunctionName=ff.FunctionName and ff.FunctionName<>@functionname)
		   ) a
		   order by a.OrderByDate desc

	END
ELSE
	BEGIN

			select    FunctionID, [FunctionName],
           [UpdatedDate], 0 as [IsDefault]
		   FROM App.FastFunction ff
		   group by functionname,[UpdatedDate],FunctionID having updateddate=(select max(UpdatedDate) from App.FastFunction where FunctionName=ff.FunctionName)
		   order by ff.updateddate desc
		  
	END
END





