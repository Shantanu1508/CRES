-- Procedure

CREATE Procedure [dbo].[usp_GetAflac_ACR_Pricing]
(
@JsonReportParamters NVARCHAR(MAX)=null
)
AS
BEGIN
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

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
	--US Eastern time zone


	--declare @TimeZoneName nvarchar(256)='US Eastern Standard Time'
	--declare @currentdatetime datetime = [dbo].[ufn_GetTimeByTimeZoneName](getdate(),@TimeZoneName)

	 --===============================================
	If(OBJECT_ID('tempdb..#tempReadJsonData') Is Not Null)
		Drop Table #tempReadJsonData
	
	CREATE TABLE #tempReadJsonData(Date date)
	INSERT INTO #tempReadJsonData (Date)
	SELECT * FROM OPENJSON(@JsonReportParamters)  WITH (Date Date '$.Date');

	declare @currentdatetime datetime	
	SET @currentdatetime = (Select date from #tempReadJsonData);
	--===============================================

Select 
	CONVERT(varchar, @currentdatetime, 101) as [DATE],
	b.[Value] as PRICE,
	'AFLAC' as PURPOSE,
	'ACR'+REPLICATE('0',6-LEN(RTRIM(n.crenoteid))) + RTRIM(n.crenoteid) as CLIENT_ID,
	'ACR' as SOURCE
	From cre.Note n
	inner join core.account acc on acc.accountid = n.account_accountid
	left join cre.FinancingSourcemaster fs on fs.FinancingSourcemasterID = n.FinancingSourceID
	left join (
	Select Noteid,Date,Value
		From(
			Select na.Noteid,na.Date,na.Value ,Row_number() over(Partition by na.Noteid order by na.date desc) as rno
			from [CRE].[NoteAttributesbyDate] na
			inner join cre.TransactionTypes ty on ty.TransactionTypesID = na.ValueTypeID
			where ty.TransactionName = 'MarketPrice'
			and cast(na.Date as date) <=cast(@currentdatetime as date)
		)a where rno =  1) b
	on b.Noteid=n.crenoteid  
	where acc.IsDeleted <> 1
	and ISNUMERIC(n.crenoteid) = 1	
	and fs.FinancingSourceName in ('AFLAC US','TRE ACR Portfolio')
	and (n.ActualPayOffDate is null OR n.ActualPayOffDate >= Cast(@currentdatetime as date))
	
	and n.ClosingDate <= Cast(@currentdatetime as date)
	
	order by CAST(n.crenoteid as int)

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
