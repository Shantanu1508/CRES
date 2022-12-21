
--[dbo].[usp_LCGetFundingScheduleDetailByCRENoteID] '1684'
--[dbo].[usp_LCGetFundingScheduleDetailByCRENoteID] '9265'

CREATE PROCEDURE [dbo].[usp_LCGetFundingScheduleDetailByCRENoteID] --'11346'
(
	@CRENoteID NVARCHAR(256)
)
	
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF;
   

--Check multiple funding
IF OBJECT_ID('tempdb..#tempMultipleFunding') IS NOT NULL     
DROP TABLE #tempMultipleFunding
CREATE TABLE #tempMultipleFunding ([Date] DateTime) 
insert into #tempMultipleFunding
		Select 	distinct rs.[Date] 	
		from [CORE].FundingSchedule rs
		INNER JOIN [CORE].[Event] eve ON eve.EventID = rs.EventId
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID				
		where n.CRENoteID = @CRENoteID and  acc.IsDeleted = 0
		and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active'  and Parentid = 1)
		and rs.[Value] is not null and rs.[Value]!=0

	group by rs.[Date],eve.EffectiveStartDate having count(rs.[Date])>1


--Created a temporary table to insert data
IF OBJECT_ID('tempdb..#temp') IS NOT NULL     
DROP TABLE #temp
CREATE TABLE #temp ([Date] DateTime)   
DECLARE @cols AS NVARCHAR(MAX),
@query  AS NVARCHAR(MAX)
set @cols='ALTER TABLE #temp ADD'
set @cols =@cols+ STUFF((SELECT ',' + QUOTENAME( Convert (nvarchar(MAX), eve.EffectiveStartDate , 101) )+'decimal(28,15)' 
             from [CORE].FundingSchedule rs
				INNER JOIN [CORE].[Event] eve ON eve.EventID = rs.EventId
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
			
				LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
				where n.CRENoteID = @CRENoteID and  acc.IsDeleted = 0
				and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active'  and Parentid = 1)
                
				
				group by eve.EffectiveStartDate
                   
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')
--select @cols
  EXEC (@cols)
  
  --SELECT * FROM #temp 
 --DROP TABLE #temp
  ----------------------------------

if exists(select * from #tempMultipleFunding)
begin
DECLARE @Date datetime,
@EffectiveStartDate datetime,
@Value decimal(28,15),
@FundingScheduleID nvarchar(256),
@InsertQuery nvarchar(MAX)
IF CURSOR_STATUS('global','MyCur')>=-1  
BEGIN  
DEALLOCATE MyCur  
END 
  
DECLARE MyCur CURSOR   
FOR  
Select 
		distinct rs.[Date] 				
		,eve.EffectiveStartDate 
		,rs.[Value] as [Value]
		,rs.FundingScheduleID		
		from [CORE].FundingSchedule rs
		INNER JOIN [CORE].[Event] eve ON eve.EventID = rs.EventId
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID				
		where n.CRENoteID = @CRENoteID and  acc.IsDeleted = 0
		and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active'  and Parentid = 1)
		and rs.[Value] is not null and rs.[Value]!=0 and rs.[Date] 	in (select * from #tempMultipleFunding)

		and ISNULL(rs.PurposeID,1) <> 351
	group by rs.[Date],eve.EffectiveStartDate,rs.[Value],rs.FundingScheduleID

OPEN MyCur   
  
FETCH NEXT FROM MyCur  
INTO @Date, @EffectiveStartDate,@Value,@FundingScheduleID
WHILE @@FETCH_STATUS = 0 
BEGIN

set @InsertQuery='
if not exists(SELECT distinct Date from #temp where Date= '''+ Convert (nvarchar(MAX), @Date , 101)+''' and (' +QUOTENAME( Convert (nvarchar(MAX), @EffectiveStartDate, 101 ))+'=0 or ' +QUOTENAME( Convert (nvarchar(MAX), @EffectiveStartDate, 101 ))+' is null))
Begin
INSERT INTO #temp(Date,' +QUOTENAME( Convert (nvarchar(MAX), @EffectiveStartDate, 101 ))+') SELECT '''+ Convert (nvarchar(MAX), @Date , 101)+''',''' + Convert (nvarchar(MAX), @Value )+''' 
End
Else
Begin
update t set t.' +QUOTENAME( Convert (nvarchar(MAX), @EffectiveStartDate, 101 ))+' = ''' + Convert (nvarchar(MAX), @Value )+''' 
 from (select top 1 * from #temp where Date='''+ Convert (nvarchar(MAX), @Date , 101)+''' and (' +QUOTENAME( Convert (nvarchar(MAX), @EffectiveStartDate, 101 ))+'=0 or ' +QUOTENAME( Convert (nvarchar(MAX), @EffectiveStartDate, 101 ))+'is null ) )t


End
'
exec (@InsertQuery)
--print (@InsertQuery)
FETCH NEXT FROM MyCur INTO  @Date, @EffectiveStartDate,@Value,@FundingScheduleID
End
CLOSE MyCur   
DEALLOCATE MyCur
End


set @cols = STUFF((SELECT ',' + QUOTENAME( Convert (nvarchar(MAX), eve.EffectiveStartDate , 101) ) 
             from [CORE].FundingSchedule rs
				INNER JOIN [CORE].[Event] eve ON eve.EventID = rs.EventId
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
			
				LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
				where n.CRENoteID = @CRENoteID and  acc.IsDeleted = 0
				and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active'  and Parentid = 1)
                group by eve.EffectiveStartDate
                   
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')



	
set @query = N' 
SELECT Cast([Date] as DateTime) as Date,' + @cols + N'
FROM (			
		Select 
				
		eve.EffectiveStartDate  as [Effective Date]
		, rs.[Date] as [Date]
		,rs.[Value] as [Value]
				
		from [CORE].FundingSchedule rs
		INNER JOIN [CORE].[Event] eve ON eve.EventID = rs.EventId
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
				
		where n.CRENoteID = '''+ cast(@CRENoteID as varchar(256))+'''  and  acc.IsDeleted = 0
		and eve.StatusID = (Select LookupID from Core.Lookup where name = ''Active''  and Parentid = 1) and rs.[Date] not in (select * from #tempMultipleFunding)
		and ISNULL(rs.PurposeID,1) <> 351 
) as sq_up
PIVOT (
MIN([Value])
FOR [Effective Date] IN (' + @cols + N')
) as p

--order by p.[Date]
'

set @query=@query + 'union select * from #temp order by [Date]'
--PRINT(@query);
EXEC(@query);
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END