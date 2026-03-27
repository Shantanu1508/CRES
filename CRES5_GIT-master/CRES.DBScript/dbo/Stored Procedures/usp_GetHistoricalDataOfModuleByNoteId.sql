
--[dbo].[usp_GetHistoricalDataOfModuleByNoteId] '336e6a38-7d3b-47b7-808d-89cf1a577a09', '432E2FDC-1C2D-4C95-BE79-1EC45AD45A2E','PIKSchedule','C10F3372-0FC2-4861-A9F5-148F1F80804F'


CREATE PROCEDURE [dbo].[usp_GetHistoricalDataOfModuleByNoteId] --'9c6c2b1a-bbaa-47b9-b73c-797e984eb9fc', '432E2FDC-1C2D-4C95-BE79-1EC45AD45A2E','FeeCouponStripReceivable','C10F3372-0FC2-4861-A9F5-148F1F80804F'
(
	@NoteId UNIQUEIDENTIFIER,
	@UserID UNIQUEIDENTIFIER,
	@ModuleName nvarchar(256),
	@AnalysisID NVARCHAR(256)
	--@PageIndex INT,
	--@PageSize INT
	--@TotalCount INT OUTPUT 
)
	
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF;
   

DECLARE @cols AS NVARCHAR(MAX),
@query  AS NVARCHAR(MAX),@query1  AS NVARCHAR(MAX) = '',@query2  AS NVARCHAR(MAX) = '',@query3  AS NVARCHAR(MAX) = ''


IF(@ModuleName = 'RateSpreadSchedule')
BEGIN
	select @cols = STUFF((SELECT ',' + QUOTENAME( Convert (nvarchar(MAX), cast((ROW_NUMBER() over (order by RateSpreadScheduleID))  as varchar(50)), 101) ) 
             from [CORE].RateSpreadSchedule rs
				INNER JOIN [CORE].[Event] eve ON eve.EventID = rs.EventId
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
				LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID
				LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = rs.IntCalcMethodID
				LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
				where n.NoteID = @NoteId  and acc.IsDeleted = 0
				and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)
                group by eve.EffectiveStartDate,RateSpreadScheduleID
                   
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

	set @query = N'SELECT [0],' + @cols + N'
  FROM (
  
	SELECT [RowCount], Amount, [0]
	FROM (			
				Select 
				cast((ROW_NUMBER() over (order by eve.EffectiveStartDate,rs.[Date]))  as varchar(50))   as [RowCount],
				ISNULL(Convert (nvarchar(MAX), eve.EffectiveStartDate, 101),'''')   as [Effective Date]
				,ISNULL(Convert (nvarchar(MAX), rs.[Date], 101),'''') as [Rate or Spread Change Date]
				,Cast(ISNULL(cast(cast(rs.[Value] as DECIMAL(28,5)) as float),0)as nvarchar(MAX)) as [Value]
				,ISNULL(Cast(LIntCalcMethodID.Name as nvarchar(MAX)),'''') as [Int Calc Method]
				,ISNULL(Cast(LValueTypeID.Name as nvarchar(MAX)),'''') as [Value Type]
				,Cast(ISNULL(cast(cast(rs.[RateOrSpreadToBeStripped] as DECIMAL(28,5)) as float),0)as nvarchar(MAX)) as [Rate Or Spread To Be Stripped]
				,ISNULL(Cast(Lindexname.Name as nvarchar(MAX)),'''') as [Index Name]
				,ISNULL(Cast(LDeterminationDateHolidayList.CalendarName as nvarchar(MAX)),'''') as [Determination Date Holiday List]
				from [CORE].RateSpreadSchedule rs
				INNER JOIN [CORE].[Event] eve ON eve.EventID = rs.EventId
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
				LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID
				LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = rs.IntCalcMethodID
				LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
				LEFT JOIN [CORE].[Lookup] Lindexname ON Lindexname.LookupID = rs.IndexNameID
				LEFT JOIN app.HoliDaysMaster LDeterminationDateHolidayList ON LDeterminationDateHolidayList.HolidayMasterID = rs.DeterminationDateHolidayList				
				where n.NoteID = '''+ cast(@NoteId as varchar(256))+'''  and acc.IsDeleted = 0
				and eve.StatusID = 1
			) as sq_source
		UNPIVOT (Amount FOR [0] IN
		([Effective Date],[Rate or Spread Change Date],  [Value] , [Int Calc Method],[Value Type],[Rate Or Spread To Be Stripped],[Index Name],[Determination Date Holiday List])


	) as sq_up
         
		 
		 ) as sq  
     PIVOT (
        MIN(Amount)
        FOR [RowCount] IN
           (' + @cols + N')
           ) as p

ORDER BY CASE WHEN [0] = ''Effective Date'' THEN ''1''
WHEN [0] = ''Rate or Spread Change Date'' THEN ''2''
WHEN [0] = ''Value'' THEN ''3''
WHEN [0] = ''Int Calc Method'' THEN ''4''
WHEN [0] = ''Value Type'' THEN ''5''
WHEN [0] = ''Rate Or Spread To Be Stripped'' THEN ''6''
WHEN [0] = ''Index Name'' THEN ''7''

ELSE [0] END ASC

		    '
END


IF(@ModuleName = 'Maturity')
BEGIN

	Select ISNULL(Convert (nvarchar(MAX), e.EffectiveStartDate, 101),'')  as [Effective Date],
	lMaturityType.name as [Maturity Type],
	ISNULL(Convert (nvarchar(MAX), mat.MaturityDate, 101),'') as [Maturity Date],
	lApproved.name as Approved,
	lExtensionType.name as ExtensionType
	from [CORE].Maturity mat  
	INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
	Left JOin Core.lookup lMaturityType on lMaturityType.lookupid = mat.MaturityType
	Left JOin Core.lookup lApproved on lApproved.lookupid = mat.Approved
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 
	Left JOin Core.lookup lExtensionType on lExtensionType.lookupid = mat.ExtensionType
	where n.noteid = @NoteId and e.StatusID = 1
	ORDER BY EffectiveStartDate,lMaturityType.SortOrder,mat.MaturityDate


--	select @cols = STUFF((SELECT ',' + QUOTENAME( Convert (nvarchar(MAX), cast((ROW_NUMBER() over (order by mat.MaturityID))  as varchar(50)), 101) ) 
--					from [CORE].[Maturity] mat
--					INNER JOIN [CORE].[Event] eve ON eve.EventID = mat.EventId
--					INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
--					INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
--					LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
--					where n.NoteID = @NoteId and acc.IsDeleted = 0
--					group by eve.EffectiveStartDate,mat.MaturityID
                   
--					FOR XML PATH(''), TYPE
--					).value('.', 'NVARCHAR(MAX)') 
--					,1,1,'')
					
--	PRINT(@cols)
--	set @query = N'SELECT [0],' + @cols + N'
--  FROM (
  
--	SELECT [RowCount], Amount, [0]
--	FROM (			
--			Select 
--			cast((ROW_NUMBER() over (order by eve.EffectiveStartDate, mat.SelectedMaturityDate))  as varchar(50))   as [RowCount]
--			,ISNULL(Convert (nvarchar(MAX), eve.EffectiveStartDate, 101),'''') [Effective Date]
--			,ISNULL(Convert (nvarchar(MAX), mat.SelectedMaturityDate, 101) ,'''') as [Selected Maturity Date]
--			from [CORE].[Maturity] mat
--			INNER JOIN [CORE].[Event] eve ON eve.EventID = mat.EventId
--			INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
--			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
--			LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
--			where n.NoteID = '''+ cast(@NoteId as varchar(256))+'''  and acc.IsDeleted = 0


--			) as sq_source
--		UNPIVOT (Amount FOR [0] IN
--		([Effective Date],[Selected Maturity Date])


--	) as sq_up
         
		 
--		 ) as sq  
--     PIVOT (
--        MIN(Amount)
--        FOR [RowCount] IN
--           (' + @cols + N')
--           ) as p


--ORDER BY CASE WHEN [0] = ''Effective Date'' THEN ''1''
--WHEN [0] = ''Selected Maturity Date'' THEN ''2''
--ELSE [0] END ASC'

END


IF(@ModuleName = 'PrepayAndAdditionalFeeSchedule')
BEGIN

	
select @cols = STUFF((SELECT ',' + QUOTENAME( Convert (nvarchar(MAX), cast((ROW_NUMBER() over (order by pafs.PrepayAndAdditionalFeeScheduleID))  as varchar(50)), 101) ) 
		from [CORE].[PrepayAndAdditionalFeeSchedule] pafs
		INNER JOIN [CORE].[Event] eve ON eve.EventID = pafs.EventId
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
		--LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = pafs.ValueTypeID
		LEFT JOIN cre.FeeSchedulesConfig LValueTypeID ON LValueTypeID.FeeTypeNameID = pafs.ValueTypeID
		LEFT JOIN [CORE].[Lookup] LApplyTrueUpFeature ON LApplyTrueUpFeature.LookupID = pafs.ApplyTrueUpFeature
		where n.NoteID = @NoteId  and acc.IsDeleted = 0
				and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)
                group by eve.EffectiveStartDate,pafs.PrepayAndAdditionalFeeScheduleID
                   
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')


PRINT(@cols);

	set @query = N'SELECT [0],' + @cols + N'
  FROM (
  
	SELECT [RowCount], Amount, [0]
	FROM (			
			Select 
			cast((ROW_NUMBER() over (order by eve.EffectiveStartDate, pafs.StartDate))  as varchar(50))   as [RowCount]
			,ISNULL(Convert (nvarchar(MAX), eve.EffectiveStartDate, 101),'''') [Effective Date]
			,ISNULL(Convert (nvarchar(MAX), pafs.[StartDate], 101),'''') as [Schedule Start Date]
			,ISNULL(CAST(LValueTypeID.FeeTypeNameText  as nvarchar(MAX)) ,'''') as [Fee Type]
			,Cast(ISNULL(cast(cast(pafs.[Value] as DECIMAL(28,5)) as float),0)as nvarchar(MAX)) as [Fee (%)]
			,Cast(ISNULL(cast(pafs.IncludedLevelYield as DECIMAL(28,5)),0)as nvarchar(MAX)) as [% Included in Level Yield Calc]

			--,ISNULL(Cast(pafs.IncludedBasis  as nvarchar(MAX)) ,'''')as [Included Basis]			
			,ISNULL(Convert (nvarchar(MAX), pafs.[EndDate], 101),'''') as [Schedule End Date]
			,ISNULL(CAST(FeeName  as nvarchar(MAX)) ,'''') as [Fee Name]
			,Cast(ISNULL(cast(pafs.FeeAmountOverride as DECIMAL(28,5)),0)as nvarchar(MAX)) as [Fee Amount Override ($)]
			,Cast(ISNULL(cast(pafs.BaseAmountOverride as DECIMAL(28,5)),0)as nvarchar(MAX)) as [Base Amount Override ($)]
			,ISNULL(CAST(LApplyTrueUpFeature.[Name]  as nvarchar(MAX)) ,'''') as [Apply True-Up Feature]
			,Cast(ISNULL(cast(pafs.FeetobeStripped as DECIMAL(28,5)),0)as nvarchar(MAX)) as [% of Fee to be Stripped]

			from [CORE].[PrepayAndAdditionalFeeSchedule] pafs
			INNER JOIN [CORE].[Event] eve ON eve.EventID = pafs.EventId
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
			LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
						
			LEFT JOIN cre.FeeSchedulesConfig LValueTypeID ON LValueTypeID.FeeTypeNameID = pafs.ValueTypeID
			LEFT JOIN [CORE].[Lookup] LApplyTrueUpFeature ON LApplyTrueUpFeature.LookupID = pafs.ApplyTrueUpFeature

			where n.NoteID = '''+ cast(@NoteId as varchar(256))+'''  and acc.IsDeleted = 0
				and eve.StatusID = (Select LookupID from Core.Lookup where name = ''Active'' and parentid = 1)


			) as sq_source
		UNPIVOT (Amount FOR [0] IN
		([Effective Date],[Schedule Start Date],[Fee Type],[Fee (%)] , [% Included in Level Yield Calc], [Schedule End Date],[Fee Name],[Fee Amount Override ($)],[Base Amount Override ($)],[Apply True-Up Feature],[% of Fee to be Stripped])

	) as sq_up  
		 ) as sq  
     PIVOT (
        MIN(Amount)
        FOR [RowCount] IN
           (' + @cols + N')
           ) as p

		   
ORDER BY CASE WHEN [0] = ''Fee Name'' THEN ''a''
WHEN [0] = ''Effective Date'' THEN ''b''
WHEN [0] = ''Schedule Start Date'' THEN ''c''
WHEN [0] = ''Schedule End Date'' THEN ''d''
WHEN [0] = ''Fee Type'' THEN ''e''
WHEN [0] = ''Fee'' THEN ''f''
WHEN [0] = ''Fee Amount Override ($)'' THEN ''g''
WHEN [0] = ''Base Amount Override ($)'' THEN ''h''
WHEN [0] = ''Apply True-Up Feature'' THEN ''i''
WHEN [0] = ''% Included in Level Yield Calc'' THEN ''j''
WHEN [0] = ''% of Fee to be Stripped'' THEN ''k''
ELSE [0] END ASC
'


END



IF(@ModuleName = 'StrippingSchedule')
BEGIN

	
select @cols = STUFF((SELECT ',' + QUOTENAME( Convert (nvarchar(MAX), cast((ROW_NUMBER() over (order by ss.StrippingScheduleID))  as varchar(50)), 101) ) 
				from [CORE].[StrippingSchedule] ss
				INNER JOIN [CORE].[Event] eve ON eve.EventID = ss.EventId
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
				LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
				LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = ss.ValueTypeID
				where n.NoteID = @NoteId  and acc.IsDeleted = 0
				and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)
                group by eve.EffectiveStartDate,ss.StrippingScheduleID
                   
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

PRINT(@cols);

	set @query = N'SELECT [0],' + @cols + N'
  FROM (
  
	SELECT [RowCount], Amount, [0]
	FROM (			
			Select 
			cast((ROW_NUMBER() over (order by eve.EffectiveStartDate, ss.[StartDate]))  as varchar(50))   as [RowCount]
			,ISNULL(Convert (nvarchar(MAX), eve.EffectiveStartDate, 101),'''')   as [Effective Date]
			,ISNULL(Convert (nvarchar(MAX), ss.[StartDate], 101),'''') as [Start Date]
			,ISNULL(CAst(LValueTypeID.Name  as nvarchar(MAX)),'''') as [Value Type]
			,Cast(ISNULL(cast(cast(ss.[Value] as DECIMAL(28,5)) as float),0)as nvarchar(MAX)) as [Value]
			,ISNULL(Cast(ss.IncludedLevelYield  as nvarchar(MAX)),'''') as [Included Level Yield]
			,ISNULL(Cast(ss.IncludedBasis  as nvarchar(MAX)),'''') as [Included Basis]

			from [CORE].[StrippingSchedule] ss
			INNER JOIN [CORE].[Event] eve ON eve.EventID = ss.EventId
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
			LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
			LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = ss.ValueTypeID
			where n.NoteID = '''+ cast(@NoteId as varchar(256))+'''  and acc.IsDeleted = 0
			and eve.StatusID = (Select LookupID from Core.Lookup where name = ''Active'' and parentid = 1)


			) as sq_source
		UNPIVOT (Amount FOR [0] IN
		([Effective Date],[Start Date],   [Value Type],[Value] , [Included Level Yield], [Included Basis])


	) as sq_up
         
		 
		 ) as sq  
     PIVOT (
        MIN(Amount)
        FOR [RowCount] IN
           (' + @cols + N')
           ) as p


 ORDER BY CASE WHEN [0] = ''Effective Date'' THEN ''1''
WHEN [0] = ''Start Date'' THEN ''2''
WHEN [0] = ''Value Type'' THEN ''3''
WHEN [0] = ''Value'' THEN ''4''
WHEN [0] = ''Included Level Yield'' THEN ''5''
WHEN [0] = ''Included Basis'' THEN ''6''
ELSE [0] END ASC

		    '

END



IF(@ModuleName = 'FinancingFeeSchedule')
BEGIN

	
select @cols = STUFF((SELECT ',' + QUOTENAME( Convert (nvarchar(MAX), cast((ROW_NUMBER() over (order by ffs.FinancingFeeScheduleID))  as varchar(50)), 101) ) 
				from [CORE].[FinancingFeeSchedule] ffs
				INNER JOIN [CORE].[Event] eve ON eve.EventID = ffs.EventId
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
				LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
				LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = ffs.ValueTypeID
				where n.NoteID = @NoteId   and acc.IsDeleted = 0
				and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)
				group by eve.EffectiveStartDate,ffs.FinancingFeeScheduleID
                   
				FOR XML PATH(''), TYPE
				).value('.', 'NVARCHAR(MAX)') 
				,1,1,'')

PRINT(@cols);

set @query = N'SELECT [0],' + @cols + N'
  FROM (
  
	SELECT [RowCount], Amount, [0]
	FROM (			
			Select 
			cast((ROW_NUMBER() over (order by eve.EffectiveStartDate, ffs.[Date]))  as varchar(50))   as [RowCount]
			,ISNULL(Convert (nvarchar(MAX), eve.EffectiveStartDate, 101) ,'''')  as [Effective Date]
			,ISNULL(Convert (nvarchar(MAX), ffs.[Date], 101) ,'''') as [Date]
			,ISNULL(CAst(LValueTypeID.Name  as nvarchar(MAX)) ,'''') as [Value Type]
			,Cast(ISNULL(cast(cast(ffs.[Value] as DECIMAL(28,5)) as float),0)as nvarchar(MAX)) as [Value]
			from [CORE].[FinancingFeeSchedule] ffs
			INNER JOIN [CORE].[Event] eve ON eve.EventID = ffs.EventId
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
			LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
			LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = ffs.ValueTypeID
			where n.NoteID = '''+ cast(@NoteId as varchar(256))+'''  and acc.IsDeleted = 0
			and eve.StatusID = (Select LookupID from Core.Lookup where name = ''Active'' and parentid = 1)


			) as sq_source
		UNPIVOT (Amount FOR [0] IN
		([Effective Date],[Date], [Value Type],[Value])


	) as sq_up
         
		 
		 ) as sq  
     PIVOT (
        MIN(Amount)
        FOR [RowCount] IN
           (' + @cols + N')
           ) as p

ORDER BY CASE WHEN [0] = ''Effective Date'' THEN 1
WHEN [0] = ''Value'' THEN 2
WHEN [0] = ''Value Type'' THEN 3
WHEN [0] = ''Date'' THEN 4
ELSE [0] END ASC

    '

END





IF(@ModuleName = 'FinancingSchedule')
BEGIN

select @cols = STUFF((SELECT ',' + QUOTENAME( Convert (nvarchar(MAX), cast((ROW_NUMBER() over (order by fs.FinancingScheduleID))  as varchar(50)), 101) ) 
				from [CORE].[FinancingSchedule] fs
				INNER JOIN [CORE].[Event] eve ON eve.EventID = fs.EventId
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
				INNER JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID

				LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = fs.ValueTypeID
				LEFT JOIN [CORE].[Lookup] LIndexTypeID ON LIndexTypeID.LookupID = fs.IndexTypeID
				LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = fs.IntCalcMethodID
				where n.NoteID = @NoteId   and acc.IsDeleted = 0
				and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)
				group by eve.EffectiveStartDate,fs.FinancingScheduleID
                   
				FOR XML PATH(''), TYPE
				).value('.', 'NVARCHAR(MAX)') 
				,1,1,'')

PRINT(@cols);



	set @query = N'SELECT [0],' + @cols + N'
  FROM (
  
	SELECT [RowCount], Amount, [0]
	FROM (			
			Select 
			cast((ROW_NUMBER() over (order by eve.EffectiveStartDate, fs.[Date]))  as varchar(50))   as [RowCount]
			,ISNULL(Convert (nvarchar(MAX), eve.EffectiveStartDate, 101)  ,'''')  as [Effective Date]
			,ISNULL(Convert (nvarchar(MAX), fs.[Date], 101) ,'''') as [Date]
			,ISNULL(CAst(LValueTypeID.Name  as nvarchar(MAX)) ,'''') as [Value Type]
			,Cast(ISNULL(cast(cast(fs.[Value] as DECIMAL(28,5)) as float),0)as nvarchar(MAX)) as [Value]
			,ISNULL(Cast(LIndexTypeID.Name  as nvarchar(MAX)) ,'''') as [Index Type]
			,ISNULL(Cast(LIntCalcMethodID.Name  as nvarchar(MAX)) ,'''') as [Int Calc Method]
			,ISNULL(Cast(LCurrencyCode.Name  as nvarchar(MAX)) ,'''') as [Financing Currency]
			
			from [CORE].[FinancingSchedule] fs
				INNER JOIN [CORE].[Event] eve ON eve.EventID = fs.EventId
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
				INNER JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
				LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = fs.ValueTypeID
				LEFT JOIN [CORE].[Lookup] LIndexTypeID ON LIndexTypeID.LookupID = fs.IndexTypeID
				LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = fs.IntCalcMethodID
				LEFT JOIN [CORE].[Lookup] LCurrencyCode ON LCurrencyCode.LookupID = fs.CurrencyCode 
			where n.NoteID = '''+ cast(@NoteId as varchar(256))+'''  and acc.IsDeleted = 0
				and eve.StatusID = (Select LookupID from Core.Lookup where name = ''Active'' and parentid = 1)


			) as sq_source
		UNPIVOT (Amount FOR [0] IN
		([Effective Date],[Date], [Value Type],[Value],[Index Type], [Int Calc Method],[Financing Currency])


	) as sq_up
         
		 
		 ) as sq  
     PIVOT (
        MIN(Amount)
        FOR [RowCount] IN
           (' + @cols + N')
           ) as p


		   
ORDER BY CASE WHEN [0] = ''Effective Date'' THEN 1
WHEN [0] = ''Date'' THEN 2
WHEN [0] = ''Value'' THEN 3
WHEN [0] = ''Index Type'' THEN 4
WHEN [0] = ''Int Calc Method'' THEN 5
WHEN [0] = ''Financing Currency'' THEN 6
WHEN [0] = ''Value Type'' THEN 7
ELSE [0] END ASC

		    '

END



IF(@ModuleName = 'DefaultSchedule')
BEGIN


	
select @cols = STUFF((SELECT ',' + QUOTENAME( Convert (nvarchar(MAX), cast((ROW_NUMBER() over (order by ds.DefaultScheduleID))  as varchar(50)), 101) ) 
				from [CORE].[DefaultSchedule] ds
				INNER JOIN [CORE].[Event] eve ON eve.EventID = ds.EventId
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
				LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
				LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = ds.ValueTypeID
				where n.NoteID = @NoteId   and acc.IsDeleted = 0
				and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)
				group by eve.EffectiveStartDate,ds.DefaultScheduleID
                   
				FOR XML PATH(''), TYPE
				).value('.', 'NVARCHAR(MAX)') 
				,1,1,'')

PRINT(@cols);



	set @query = N'SELECT [0],' + @cols + N'
  FROM (
  
	SELECT [RowCount], Amount, [0]
	FROM (			
			Select 
			cast((ROW_NUMBER() over (order by eve.EffectiveStartDate, ds.[StartDate], ds.[EndDate]))  as varchar(50))   as [RowCount]
			,ISNULL(Convert (nvarchar(MAX), eve.EffectiveStartDate, 101),'''')   as [Effective Date]
			,ISNULL(Convert (nvarchar(MAX), ds.[StartDate], 101),'''') as [Start Date]
			,ISNULL(Convert (nvarchar(MAX), ds.[EndDate], 101),'''') as [End Date]
			,ISNULL(CAst(LValueTypeID.Name  as nvarchar(MAX)),'''') as [Value Type]
			,Cast(ISNULL(cast(cast(ds.[Value] as DECIMAL(28,5)) as float),0)as nvarchar(MAX)) as [Value]
			from [CORE].[DefaultSchedule] ds
			INNER JOIN [CORE].[Event] eve ON eve.EventID = ds.EventId
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
			LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
			LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = ds.ValueTypeID
			where n.NoteID = '''+ cast(@NoteId as varchar(256))+'''  and acc.IsDeleted = 0
			and eve.StatusID = (Select LookupID from Core.Lookup where name = ''Active'' and parentid = 1)


			) as sq_source
		UNPIVOT (Amount FOR [0] IN
		([Effective Date],[Start Date],[End Date], [Value Type],[Value])


	) as sq_up
         
		 
		 ) as sq  
     PIVOT (
        MIN(Amount)
        FOR [RowCount] IN
           (' + @cols + N')
           ) as p


ORDER BY CASE WHEN [0] = ''Effective Date'' THEN 1
WHEN [0] = ''Start Date'' THEN 2
WHEN [0] = ''End Date'' THEN 3
WHEN [0] = ''Value Type'' THEN 4
WHEN [0] = ''Value'' THEN 5
ELSE [0] END ASC

		    '

END





IF(@ModuleName = 'ServicingFeeSchedule')
BEGIN

	
select @cols = STUFF((SELECT ',' + QUOTENAME( Convert (nvarchar(MAX), cast((ROW_NUMBER() over (order by sfs.ServicingFeeScheduleID))  as varchar(50)), 101) ) 
				from [CORE].[ServicingFeeSchedule] sfs
				INNER JOIN [CORE].[Event] eve ON eve.EventID = sfs.EventId
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
				LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
				LEFT JOIN [CORE].[Lookup] LIsCapitalized ON LIsCapitalized.LookupID = sfs.IsCapitalized
				where n.NoteID = @NoteId   and acc.IsDeleted = 0
				and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)
				group by eve.EffectiveStartDate,sfs.ServicingFeeScheduleID
                   
				FOR XML PATH(''), TYPE
				).value('.', 'NVARCHAR(MAX)') 
				,1,1,'')

PRINT(@cols);



	set @query = N'SELECT [0],' + @cols + N'
  FROM (
  
	SELECT [RowCount], Amount, [0]
	FROM (			
			Select 
			cast((ROW_NUMBER() over (order by eve.EffectiveStartDate, sfs.[Date]))  as varchar(50))   as [RowCount]
			,ISNULL(Convert (nvarchar(MAX), eve.EffectiveStartDate, 101),'''')   as [Effective Date]
			,ISNULL(Convert (nvarchar(MAX), sfs.[Date], 101),'''') as [Transcation Date]
			,ISNULL(CAst(LIsCapitalized.Name  as nvarchar(MAX)),'''') as [Is Capitalized]
			,Cast(ISNULL(cast(cast(sfs.[Value] as DECIMAL(28,5)) as float),0)as nvarchar(MAX))as [Value]
			from [CORE].[ServicingFeeSchedule] sfs
				INNER JOIN [CORE].[Event] eve ON eve.EventID = sfs.EventId
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
				LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
				LEFT JOIN [CORE].[Lookup] LIsCapitalized ON LIsCapitalized.LookupID = sfs.IsCapitalized
			where n.NoteID = '''+ cast(@NoteId as varchar(256))+'''  and acc.IsDeleted = 0
				and eve.StatusID = (Select LookupID from Core.Lookup where name = ''Active'' and parentid = 1)


			) as sq_source
		UNPIVOT (Amount FOR [0] IN
		([Effective Date],[Transcation Date],[Is Capitalized],[Value])


	) as sq_up
         
		 
		 ) as sq  
     PIVOT (
        MIN(Amount)
        FOR [RowCount] IN
           (' + @cols + N')
           ) as p

 ORDER BY CASE WHEN [0] = ''Effective Date'' THEN 1
WHEN [0] = ''Transcation Date'' THEN 2
WHEN [0] = ''Value'' THEN 3
WHEN [0] = ''Is Capitalized'' THEN 4
ELSE [0] END ASC

   '

END



IF(@ModuleName = 'PIKSchedule')
BEGIN


			
	--ISNULL(CAST(	pik.PeriodicRateCapAmount	 as nvarchar(MAX)),'''') as 	[Periodic Rate Cap Amount],
	--ISNULL(CAST(	pik.PeriodicRateCapPercent	 as nvarchar(MAX)),'''') as 	[Periodic Rate Cap %]	

	select @cols = STUFF((SELECT ',' + QUOTENAME( Convert (nvarchar(MAX), cast((ROW_NUMBER() over (order by pik.PIKScheduleID))  as varchar(50)), 101) ) 
					from [CORE].[PIKSchedule] pik
			INNER JOIN [CORE].[Event] eve ON eve.EventID = pik.EventId
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
			LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
			where n.NoteID = @NoteId  and acc.IsDeleted = 0
					group by eve.EffectiveStartDate,pik.PIKScheduleID
                   
					FOR XML PATH(''), TYPE
					).value('.', 'NVARCHAR(MAX)') 
					,1,1,'')
					
	PRINT(@cols)
	

	set @query = N'SELECT [0],' + @cols + N'
	FROM (  
	SELECT [RowCount], Amount, [0]
	FROM (			
			Select 
			cast((ROW_NUMBER() over (order by eve.EffectiveStartDate, pik.StartDate, pik.EndDate))  as varchar(MAX))   as [RowCount]
			,ISNULL(Convert (nvarchar(MAX), eve.EffectiveStartDate, 101),'''') [Effective Date],
			ISNULL(Convert (nvarchar(MAX),	pik.StartDate	, 101),'''') as 	[Start Date]	,
			ISNULL(Convert (nvarchar(MAX),	pik.EndDate	, 101),'''') as 	[End Date]	,
			ISNULL(CAST(LPIKSetUp.name	 as nvarchar(MAX)),'''') as 	[PIK Set Up],			
			(CASE WHEN ISNULL(CAST(CAST(pik.pikpercentage * 100 as Decimal(28,9))	 as nvarchar(MAX)),'''') <> '''' THEN ISNULL(CAST(CAST(pik.pikpercentage * 100 as Decimal(28,9))	 as nvarchar(MAX)),'''') + ''%'' ELSE ISNULL(CAST(CAST(pik.pikpercentage * 100 as Decimal(28,9))	 as nvarchar(MAX)),'''') END)  as 	[PIK %],			
			(CASE WHEN ISNULL(CAST(CAST(pik.PIKCurrentPayRate * 100 as Decimal(28,9)) as nvarchar(MAX)),'''') <> '''' THEN ISNULL(CAST(CAST(pik.PIKCurrentPayRate * 100 as Decimal(28,9)) as nvarchar(MAX)),'''') + ''%'' ELSE ISNULL(CAST(CAST(pik.PIKCurrentPayRate * 100 as Decimal(28,9)) as nvarchar(MAX)),'''') END) as 	[Current Pay Rate]	,
			ISNULL(CAST(LPIKSeparateCompounding.name AS nvarchar(MAX)), ''N'') AS [PIK with Separate Compounding],		
			(CASE WHEN ISNULL(CAST(CAST(pik.IntCompoundingRate * 100 as Decimal(28,9))	 as nvarchar(MAX)),'''') <> '''' THEN ISNULL(CAST(CAST(pik.IntCompoundingRate * 100 as Decimal(28,9))	 as nvarchar(MAX)),'''') + ''%'' ELSE ISNULL(CAST(CAST(pik.IntCompoundingRate * 100 as Decimal(28,9)) as nvarchar(MAX)),'''') END)  as 	[PIK Compounding Rate]	,			
			(CASE WHEN ISNULL(CAST(CAST(pik.IntCompoundingSpread * 100 as Decimal(28,9)) as nvarchar(MAX)),'''') <> '''' THEN ISNULL(CAST(CAST(pik.IntCompoundingSpread * 100 as Decimal(28,9)) as nvarchar(MAX)),'''') + ''%'' ELSE ISNULL(CAST(CAST(pik.IntCompoundingSpread * 100 as Decimal(28,9)) as nvarchar(MAX)),'''') END)  as 	[PIK Compounding Spread]	,
			(CASE WHEN ISNULL(CAST(CAST(pik.AdditionalIntRate * 100 as Decimal(28,9)) as nvarchar(MAX)),'''') <> '''' THEN ISNULL(CAST(CAST(pik.AdditionalIntRate * 100 as Decimal(28,9)) as nvarchar(MAX)),'''') + ''%''ELSE ISNULL(CAST(CAST(pik.AdditionalIntRate * 100 as Decimal(28,9)) as nvarchar(MAX)),'''') END )   as 	[PIK Rate]	,
			(CASE WHEN ISNULL(CAST(CAST(pik.AdditionalSpread * 100 as Decimal(28,9)) as nvarchar(MAX)),'''') <> '''' THEN ISNULL(CAST(CAST(pik.AdditionalSpread * 100 as Decimal(28,9)) as nvarchar(MAX)),'''') + ''%'' ELSE ISNULL(CAST(CAST(pik.AdditionalSpread * 100 as Decimal(28,9)) as nvarchar(MAX)),'''') END) as 	[PIK Spread]	,
			(CASE WHEN ISNULL(CAST(CAST(pik.IndexFloor * 100 as Decimal(28,9)) as nvarchar(MAX)),'''') <> '''' THEN ISNULL(CAST(CAST(pik.IndexFloor * 100 as Decimal(28,9)) as nvarchar(MAX)),'''') + ''%'' ELSE ISNULL(CAST(CAST(pik.IndexFloor * 100 as Decimal(28,9)) as nvarchar(MAX)),'''') END)  as 	[Index Floor]	,
			ISNULL(CAST(LPIKIntCalcMethodID.name	 as nvarchar(MAX)),'''') as 	[PIK Interest Calc method],	
			CONVERT(NVARCHAR(MAX), ISNULL(CAST(pik.PurBal AS DECIMAL(28,2)), 0)) AS [Pur Balance],
			ISNULL(CAST(pik.PIKComments	 as nvarchar(MAX)),'''') as 	[PIK Comments],
			ISNULL(CAST(LPIKReasonCode.name	 as nvarchar(MAX)),'''') as 	[PIK Reason Code],
			ISNULL(CAST(LImpactCommitmentCalc.name	 as nvarchar(MAX)),'''') as 	[Impact in Commitment Calc],
			ISNULL(CAST(LPIKInterestAddedToBalanceBasedOnBusinessAdjustedDate.name	 as nvarchar(MAX)),'''') as 	[Cash Interest Calc-PIK Balance updated on Business Adjusted Pmt Date],
			ISNULL(CAST(	accSourceAccount.Name	 as nvarchar(MAX)),'''') as 	[Source Account]	,
			ISNULL(CAST(	accTargetAccount.Name	 as nvarchar(MAX)),'''') as 	[Target Account]	,
			CONVERT(NVARCHAR(MAX), ISNULL(CAST(pik.IntCapAmt AS DECIMAL(28,2)), 0)) AS [Cap Amount],
			CONVERT(NVARCHAR(MAX), ISNULL(CAST(pik.AccCapBal AS DECIMAL(28,2)), 0)) AS [Acc Cap Balance]
			'SET @query1 = 'from [CORE].[PIKSchedule] pik
			INNER JOIN [CORE].[Event] eve ON eve.EventID = pik.EventId
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
			left JOIN [CORE].[Account] accSourceAccount ON accSourceAccount.AccountID= pik.SourceAccountID
			left JOIN [CORE].[Account] accTargetAccount ON accTargetAccount.AccountID= pik.TargetAccountID
			LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
			'SET @query2 = 'LEFT JOIN [CORE].[Lookup] LPIKReasonCode ON LPIKReasonCode.LookupID = pik.PIKReasonCodeID
			LEFT JOIN [CORE].[Lookup] LPIKIntCalcMethodID ON LPIKIntCalcMethodID.LookupID = pik.PIKIntCalcMethodID 
			LEFT JOIN [CORE].[Lookup] LPIKSetUp ON LPIKSetUp.LookupID = pik.PIKSetUp 
			LEFT JOIN [CORE].[Lookup] LPIKSeparateCompounding ON LPIKSeparateCompounding.LookupID = pik.PIKSeparateCompounding  
			LEFT JOIN [CORE].[Lookup] LImpactCommitmentCalc ON LImpactCommitmentCalc.LookupID = n.ImpactCommitmentCalc
			LEFT JOIN [CORE].[Lookup] LPIKInterestAddedToBalanceBasedOnBusinessAdjustedDate ON LPIKInterestAddedToBalanceBasedOnBusinessAdjustedDate.LookupID = n.PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate	
			where n.NoteID = '''+ cast(@NoteId as varchar(256))+'''  and acc.IsDeleted = 0		
		) as sq_source
		UNPIVOT (Amount FOR [0] IN
		([Effective Date],[Start Date],[End Date],[PIK Set Up],[PIK %],[Current Pay Rate],[PIK with Separate Compounding],[PIK Compounding Rate],[PIK Compounding Spread],[PIK Rate],[PIK Spread],[Index Floor],[PIK Interest Calc method],[Pur Balance],[PIK Comments],[PIK Reason Code],[Impact in Commitment Calc],[Cash Interest Calc-PIK Balance updated on Business Adjusted Pmt Date],[Source Account],[Target Account],[Cap Amount],[Acc Cap Balance])		
	) as sq_up  
) as sq  
PIVOT (
	MIN(Amount)
	FOR [RowCount] IN
	(' + @cols + N')
) as p
'SET @query3 = '
ORDER BY CASE WHEN [0] = ''Effective Date'' THEN 1
WHEN [0] = ''Start Date'' THEN 2
WHEN [0] = ''End Date'' THEN 3
WHEN [0] = ''PIK Set Up'' THEN 4
WHEN [0] = ''PIK %'' THEN 5
WHEN [0] = ''Current Pay Rate'' THEN 6
WHEN [0] = ''PIK with Separate Compounding'' THEN 7
WHEN [0] = ''PIK Compounding Rate'' THEN 8
WHEN [0] = ''PIK Compounding Spread'' THEN 9
WHEN [0] = ''PIK Rate'' THEN 10
WHEN [0] = ''PIK Spread'' THEN 11
WHEN [0] = ''Index Floor'' THEN 12
WHEN [0] = ''PIK Interest Calc method'' THEN 13
WHEN [0] = ''Pur Balance'' THEN 14
WHEN [0] = ''PIK Comments'' THEN 15
WHEN [0] = ''PIK Reason Code'' THEN 16
WHEN [0] = ''Impact in Commitment Calc'' THEN 17
WHEN [0] = ''Cash Interest Calc-PIK Balance updated on Business Adjusted Pmt Date'' THEN 18
WHEN [0] = ''Source Account'' THEN 19
WHEN [0] = ''Target Account'' THEN 20
WHEN [0] = ''Cap Amount'' THEN 21
WHEN [0] = ''Acc Cap Balance'' THEN 22
ELSE [0] END ASC'

END

-----[PIK Interest Compounding Rate],[PIK Interest Compounding Spread],[Periodic Rate Cap Amount],[Periodic Rate Cap %]

IF(@ModuleName = 'FundingSchedule')
BEGIN
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
		where n.NoteID = @NoteID  and acc.IsDeleted = 0
		and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active'  and Parentid = 1)
		and eve.EventTypeID = (Select LookupID from Core.Lookup where name = 'FundingSchedule'  and Parentid = 3)
		and rs.[Value] is not null and rs.[Value]!=0 
	group by rs.[Date],eve.EffectiveStartDate having count(rs.[Date])>1


--Created a temporary table to insert data
IF OBJECT_ID('tempdb..#temp') IS NOT NULL     
DROP TABLE #temp
CREATE TABLE #temp ([Date] DateTime)   

set @cols='ALTER TABLE #temp ADD'
set @cols =@cols+ STUFF((SELECT ',' + QUOTENAME( Convert (nvarchar(MAX), eve.EffectiveStartDate , 101) )+'decimal(28,15)' 
             from [CORE].FundingSchedule rs
				INNER JOIN [CORE].[Event] eve ON eve.EventID = rs.EventId
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
			
				LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
				where n.NoteID = @NoteId  and acc.IsDeleted = 0
				and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active'  and Parentid = 1)
                and eve.EventTypeID = (Select LookupID from Core.Lookup where name = 'FundingSchedule'  and Parentid = 3)
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
		where n.NoteID = @NoteId  and acc.IsDeleted = 0
		and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active'  and Parentid = 1)
		and eve.EventTypeID = (Select LookupID from Core.Lookup where name = 'FundingSchedule'  and Parentid = 3)
		and rs.[Value] is not null and rs.[Value]!=0 and rs.[Date] 	in (select * from #tempMultipleFunding)
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
				where n.NoteID = @NoteId and acc.IsDeleted = 0
				and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active'  and Parentid = 1)
                and eve.EventTypeID = (Select LookupID from Core.Lookup where name = 'FundingSchedule'  and Parentid = 3)
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
		where n.NoteID = '''+ cast(@NoteId as varchar(256))+'''  and acc.IsDeleted = 0
		and eve.StatusID = (Select LookupID from Core.Lookup where name = ''Active''  and Parentid = 1)
		and eve.EventTypeID = (Select LookupID from Core.Lookup where name = ''FundingSchedule''  and Parentid = 3)
		and rs.[Date] not in (select * from #tempMultipleFunding)
	
) as sq_up
PIVOT (
MIN([Value])
FOR [Effective Date] IN (' + @cols + N')
) as p

'

set @query=@query + 'union select * from #temp order by [Date]'

END



IF(@ModuleName = 'LIBORSchedule')
BEGIN


select @cols = STUFF((SELECT ',' + QUOTENAME( Convert (nvarchar(MAX), eve.EffectiveStartDate , 101) ) 
             from [CORE].LIBORSchedule rs
				INNER JOIN [CORE].[Event] eve ON eve.EventID = rs.EventId
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
			
				LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
				where n.NoteID = @NoteId  and acc.IsDeleted = 0
                group by eve.EffectiveStartDate
                    order by  eve.EffectiveStartDate 
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')



	
set @query = N' 
SELECT  Convert (nvarchar(MAX), [Date], 101) as Date,' + @cols + N'
FROM (			
		Select 
				
		  eve.EffectiveStartDate   as [Effective Date]
		, rs.[Date]  as [Date]
	    ,cast(cast(rs.[Value] as DECIMAL(28,5)) as float) as [Value]
		
		from [CORE].LIBORSchedule rs
		INNER JOIN [CORE].[Event] eve ON eve.EventID = rs.EventId
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
				
		where n.NoteID =  '''+ cast(@NoteId as varchar(256))+'''  and acc.IsDeleted = 0
	
) as sq_up
PIVOT (
MIN([Value])
FOR [Effective Date] IN (' + @cols + N')
) as p
'

END


IF(@ModuleName = 'AmortSchedule')
BEGIN


select @cols = STUFF((SELECT ',' + QUOTENAME( Convert (nvarchar(MAX), eve.EffectiveStartDate , 101) ) 
             from [CORE].AmortSchedule rs
				INNER JOIN [CORE].[Event] eve ON eve.EventID = rs.EventId
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
			
				LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
				where n.NoteID = @NoteId  and acc.IsDeleted = 0
                and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active'  and Parentid = 1)
				and eve.EventTypeID = (Select LookupID from Core.Lookup where name = 'AmortSchedule'  and Parentid = 3)
				group by eve.EffectiveStartDate
                   order by  eve.EffectiveStartDate 
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')



	
set @query = N' 
SELECT  Convert (nvarchar(MAX), [Date], 101) as Date,' + @cols + N'
FROM (			
		Select 
				
		eve.EffectiveStartDate   as [Effective Date]
		,rs.[Date] as [Date]	    
		,cast(cast(rs.[Value] as DECIMAL(28,5)) as float) as [Value]				
		from [CORE].AmortSchedule rs
		INNER JOIN [CORE].[Event] eve ON eve.EventID = rs.EventId
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
				
		where n.NoteID =  '''+ cast(@NoteId as varchar(256))+'''  and acc.IsDeleted = 0
		and eve.StatusID = (Select LookupID from Core.Lookup where name = ''Active''  and Parentid = 1)
		and eve.EventTypeID = (Select LookupID from Core.Lookup where name = ''AmortSchedule''  and Parentid = 3)

	
) as sq_up
PIVOT (
MIN([Value])
FOR [Effective Date] IN (' + @cols + N')
) as p
'

END


IF(@ModuleName = 'PIKScheduleDetail')
BEGIN



select @cols = STUFF((SELECT ',' + QUOTENAME( Convert (nvarchar(MAX), eve.EffectiveStartDate , 101) ) 
             from [CORE].PIKScheduleDetail rs
				INNER JOIN [CORE].[Event] eve ON eve.EventID = rs.EventId
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
			
				LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
				where n.NoteID = @NoteId  and acc.IsDeleted = 0
                group by eve.EffectiveStartDate
                 order by  eve.EffectiveStartDate   
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')



	
set @query = N' 
SELECT  Convert (nvarchar(MAX), [Date], 101) as Date,' + @cols + N'
FROM (			
		Select 
				
		  eve.EffectiveStartDate    as [Effective Date]
		, rs.[Date]  as [Date]
	    ,cast(cast(rs.[Value] as DECIMAL(28,5)) as float) as [Value]
				
		from [CORE].PIKScheduleDetail rs
		INNER JOIN [CORE].[Event] eve ON eve.EventID = rs.EventId
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
				
		where n.NoteID =  '''+ cast(@NoteId as varchar(256))+'''  and acc.IsDeleted = 0
	
) as sq_up
PIVOT (
MIN([Value])
FOR [Effective Date] IN (' + @cols + N')
) as p
'

END


IF(@ModuleName = 'FeeCouponStripReceivable')
BEGIN

set @query = N' 
Select 
Convert (nvarchar(MAX),eve.EffectiveStartDate, 101)  AS EffectiveDate
,Convert (nvarchar(MAX),fr.[Date], 101) as [Date]
,Cast(ISNULL(cast(cast(fr.[Value] as DECIMAL(28,5)) as float),0)as nvarchar(MAX)) as [Value]
,LRuleTypeID.FeeTypeNameText+'' Strip'' RuleType 
,nSource.crenoteid as SourceNoteId
from [CORE].[FeeCouponStripReceivable] fr
INNER JOIN [CORE].[Event] eve ON eve.EventID = fr.EventId
INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
INNER JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
left JOIN [CRE].[FeeSchedulesConfig] LRuleTypeID ON LRuleTypeID.FeeTypeNameID = fr.RuleTypeID
left JOIN Core.[Lookup] l1 ON LRuleTypeID.FeeNameTransID = l1.LookupID
left JOIN [CRE].[Note] nSource ON nSource.noteid =fr.SourceNoteId
where n.NoteID = '''+ cast(@NoteId as varchar(256))+'''   and acc.IsDeleted = 0
AND fr.AnalysisID = '''+@AnalysisID+'''
ORDER BY eve.EffectiveStartDate,fr.[Date] DESC'


--select @cols = STUFF((SELECT ',' + QUOTENAME( Convert (nvarchar(MAX), eve.EffectiveStartDate , 101) ) 
--             from [CORE].FeeCouponStripReceivable rs
--				INNER JOIN [CORE].[Event] eve ON eve.EventID = rs.EventId
--				INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
--				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
			
--				LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
--				where n.NoteID = @NoteId  and acc.IsDeleted = 0 AND rs.AnalysisID = @AnalysisID
--                group by eve.EffectiveStartDate
--                   order by  eve.EffectiveStartDate 
--            FOR XML PATH(''), TYPE
--            ).value('.', 'NVARCHAR(MAX)') 
--        ,1,1,'')
	
--set @query = N' 
--SELECT  Convert (nvarchar(MAX), [Date], 101) as Date,' + @cols + N'
--FROM (			
--		Select 
				
--		 eve.EffectiveStartDate    as [Effective Date]
--		,  rs.[Date]  as [Date]
--	    ,cast(cast(rs.[Value] as DECIMAL(28,5)) as float) as [Value]
			
--		from [CORE].FeeCouponStripReceivable rs
--		INNER JOIN [CORE].[Event] eve ON eve.EventID = rs.EventId
--		INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
--		LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
				
--		where n.NoteID =  '''+ cast(@NoteId as varchar(256))+'''  and acc.IsDeleted = 0  and rs.AnalysisID = '''+@AnalysisID+'''
	
--) as sq_up
--PIVOT (
--MIN([Value])
--FOR [Effective Date] IN (' + @cols + N')
--) as p
--'

END

PRINT(@query)  
PRINT(@query1) 
PRINT(@query2) 
PRINT(@query3)

Declare @query_full nvarchar(max);
SET @query_full = (@query + @query1 + @query2 + @query3)

exec sp_executesql @query_full;
	
	
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
