
CREATE Procedure [dbo].[usp_Get_AFlac_TREcancel]
(
  @JsonReportParamters NVARCHAR(MAX)=null
)
AS
BEGIN
	SET NOCOUNT ON;
	/*--read paramter from the json
	DECLARE @SheetName NVARCHAR(256),
			@SheetJsonParamters NVARCHAR(MAX),
			@SheetJsonParamtersRoot NVARCHAR(MAX),
			@Client_ID NVARCHAR(10),@SOURCE NVARCHAR(10)
	
	Select @SheetName=SheetName From App.ReportFileSheet where ReportFileSheetID=2
	
	SELECT @SheetJsonParamters=[value]
    FROM OPENJSON (@JsonReportParamters,'$.Root') where [key]=@SheetName
	print @SheetJsonParamters
	IF (@SheetJsonParamters IS NOT NULL)
	BEGIN
	    select @Client_ID=value from OPENJSON(@SheetJsonParamters) where [key]='CLIENT_ID'
	    select @SOURCE=value from OPENJSON(@SheetJsonParamters) where [key]='SOURCE'
	END
	--
	*/
	
	----------------------========================----------------
	If(OBJECT_ID('tempdb..#tempReadJsonData') Is Not Null)
		Drop Table #tempReadJsonData
	
	CREATE TABLE #tempReadJsonData(Date date)
	INSERT INTO #tempReadJsonData (Date)
	SELECT * FROM OPENJSON(@JsonReportParamters)  WITH (Date Date '$.Date');

	declare @currentdatetime datetime	
	SET @currentdatetime = (Select date from #tempReadJsonData);
	-------------=============================---------------

	Select NUll as PORTFOLIO,NULL as EXT_ID1 where 1=0

END