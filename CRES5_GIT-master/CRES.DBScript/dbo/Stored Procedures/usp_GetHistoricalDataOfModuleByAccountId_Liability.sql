--[dbo].[usp_GetHistoricalDataOfModuleByAccountId_Liability] '4d6e8b40-8f77-4722-a8ed-16b64ef21fc7','b0e6697b-3534-4c09-be0a-04473401ab93','InterestExpenseSchedule','ccee6ee3-d5b2-4d4b-9c83-0eaedc34026f'

CREATE PROCEDURE [dbo].[usp_GetHistoricalDataOfModuleByAccountId_Liability] --'7f3ee63d-fcc6-4e7c-b371-5a189268e660','b0e6697b-3534-4c09-be0a-04473401ab93','RateSpreadScheduleLiability',Null
(
	@AccountId UNIQUEIDENTIFIER,
	@UserID UNIQUEIDENTIFIER,
	@ModuleName nvarchar(256),
	@AdditionalAccountId UNIQUEIDENTIFIER = NULL
)
	
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF;


IF(@AdditionalAccountId is null)
BEGIN
	SET @AdditionalAccountId = '00000000-0000-0000-0000-000000000000'
END

DECLARE @cols AS NVARCHAR(MAX),
@query  AS NVARCHAR(MAX)


IF(@ModuleName = 'RateSpreadScheduleLiability')
BEGIN
	select @cols = STUFF((SELECT ',' + QUOTENAME( Convert (nvarchar(MAX), cast((ROW_NUMBER() over (order by RateSpreadScheduleLiabilityID))  as varchar(50)), 101) ) 
             from [Core].[RateSpreadScheduleLiability] rs
				INNER JOIN [CORE].[Event] eve ON eve.EventID = rs.EventId
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
				--INNER JOIN [CRE].[LiabilityNote] n ON n.AccountID = acc.AccountID
				LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID
				LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = rs.IntCalcMethodID
				LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
				where acc.AccountID = @AccountId  and acc.IsDeleted = 0
				and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)
				and 1 = (CASE WHEN @AdditionalAccountId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN @AdditionalAccountId <> '00000000-0000-0000-0000-000000000000' and eve.AdditionalAccountID = @AdditionalAccountId THEN 1 END)
                group by eve.EffectiveStartDate,RateSpreadScheduleLiabilityID
                   
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
				from [Core].[RateSpreadScheduleLiability] rs
				INNER JOIN [CORE].[Event] eve ON eve.EventID = rs.EventId
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
				LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID
				LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = rs.IntCalcMethodID
				LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
				LEFT JOIN [CORE].[Lookup] Lindexname ON Lindexname.LookupID = rs.IndexNameID
				LEFT JOIN app.HoliDaysMaster LDeterminationDateHolidayList ON LDeterminationDateHolidayList.HolidayMasterID = rs.DeterminationDateHolidayList				
				where acc.AccountID = '''+ cast(@AccountId as varchar(256))+'''  and acc.IsDeleted = 0
				and eve.StatusID = 1				
				and 1 = (CASE WHEN '''+ cast(@AdditionalAccountId as varchar(256))+''' = ''00000000-0000-0000-0000-000000000000'' THEN 1 WHEN '''+ cast(@AdditionalAccountId as varchar(256))+''' <> ''00000000-0000-0000-0000-000000000000'' and eve.AdditionalAccountID = '''+ cast(@AdditionalAccountId as varchar(256))+''' THEN 1 END)
               
			
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

IF(@ModuleName = 'PrepayAndAdditionalFeeScheduleLiability')
BEGIN

	
select @cols = STUFF((SELECT ',' + QUOTENAME( Convert (nvarchar(MAX), cast((ROW_NUMBER() over (order by pafs.PrepayAndAdditionalFeeScheduleLiabilityID))  as varchar(50)), 101) ) 
		from [Core].[PrepayAndAdditionalFeeScheduleLiability] pafs
		INNER JOIN [CORE].[Event] eve ON eve.EventID = pafs.EventId
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
		--INNER JOIN [CRE].[Debt] n ON n.AccountID = acc.AccountID
		LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
		--LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = pafs.ValueTypeID
		LEFT JOIN cre.FeeSchedulesConfig LValueTypeID ON LValueTypeID.FeeTypeNameID = pafs.ValueTypeID
		LEFT JOIN [CORE].[Lookup] LApplyTrueUpFeature ON LApplyTrueUpFeature.LookupID = pafs.ApplyTrueUpFeature
		where acc.AccountID = @AccountId  and acc.IsDeleted = 0
				and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)
				and 1 = (CASE WHEN @AdditionalAccountId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN @AdditionalAccountId <> '00000000-0000-0000-0000-000000000000' and eve.AdditionalAccountID = @AdditionalAccountId THEN 1 END)               
                group by eve.EffectiveStartDate,pafs.PrepayAndAdditionalFeeScheduleLiabilityID
                   
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

			from [Core].[PrepayAndAdditionalFeeScheduleLiability] pafs
			INNER JOIN [CORE].[Event] eve ON eve.EventID = pafs.EventId
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
			LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
						
			LEFT JOIN cre.FeeSchedulesConfig LValueTypeID ON LValueTypeID.FeeTypeNameID = pafs.ValueTypeID
			LEFT JOIN [CORE].[Lookup] LApplyTrueUpFeature ON LApplyTrueUpFeature.LookupID = pafs.ApplyTrueUpFeature

			where acc.AccountID = '''+ cast(@AccountId as varchar(256))+'''  and acc.IsDeleted = 0
			and eve.StatusID = 1
			and 1 = (CASE WHEN '''+ cast(@AdditionalAccountId as varchar(256))+''' = ''00000000-0000-0000-0000-000000000000'' THEN 1 WHEN '''+ cast(@AdditionalAccountId as varchar(256))+''' <> ''00000000-0000-0000-0000-000000000000'' and eve.AdditionalAccountID = '''+ cast(@AdditionalAccountId as varchar(256))+''' THEN 1 END)
               
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

IF(@ModuleName = 'GeneralSetupDetailsLiabilityNote')
BEGIN
select @cols = STUFF((SELECT ',' + QUOTENAME( Convert (nvarchar(MAX), cast((ROW_NUMBER() over (order by GeneralSetupDetailsLiabilityID))  as varchar(50)), 101) ) 
             from [CORE].GeneralSetupDetailsLiabilityNote ln
				INNER JOIN [CORE].[Event] eve ON eve.EventID = ln.EventId
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
				INNER JOIN [CRE].[LiabilityNote] n ON n.AccountID = acc.AccountID
				LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
				where n.AccountID = @AccountId  and acc.IsDeleted = 0
				and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)
                group by eve.EffectiveStartDate,GeneralSetupDetailsLiabilityID
                   
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')
		PRINT(@cols);

	set @query = N'SELECT [0],' + @cols + N'
  FROM (
  SELECT [RowCount], Amount, [0]
	FROM (			
			Select 
			cast((ROW_NUMBER() over (order by eve.EffectiveStartDate))  as varchar(50))   as [RowCount]
			,ISNULL(Convert (nvarchar(MAX), eve.EffectiveStartDate, 101),'''') as [Effective Date]
			,Cast(ISNULL(cast(cast(ln.[PaydownAdvanceRate] as DECIMAL(28,5)) as float),0)as nvarchar(MAX)) as [Paydown Equity (%)]
			,Cast(ISNULL(cast(cast(ln.[FundingAdvanceRate] as DECIMAL(28,5)) as float),0)as nvarchar(MAX)) as [Funding Equity (%)]
			,Cast(ISNULL(cast(cast(ln.[TargetAdvanceRate] as DECIMAL(28,5)) as float),0)as nvarchar(MAX)) as [Target Equity (%)]
			,ISNULL(Convert (nvarchar(MAX), ln.MaturityDate, 101),'''') as [Maturity Date]
			,ISNULL(Convert (nvarchar(MAX), ln.PledgeDate, 101),'''') as [Pledge Date]
			,ISNULL(Cast(lLiabilitySource.Name as nvarchar(MAX)),'''') as [Liability Source]
			
			from [CORE].GeneralSetupDetailsLiabilityNote ln
				INNER JOIN [CORE].[Event] eve ON eve.EventID = ln.EventId
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
				INNER JOIN [CRE].[LiabilityNote] n ON n.AccountID = acc.AccountID
				LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
				Left Join core.lookup lLiabilitySource on lLiabilitySource.lookupid = ln.LiabilitySourceID

			where n.AccountID = '''+ cast(@AccountId as varchar(256))+'''  and acc.IsDeleted = 0
				and eve.StatusID = (Select LookupID from Core.Lookup where name = ''Active'' and parentid = 1)

			) as sq_source
		UNPIVOT (Amount FOR [0] IN
		([Effective Date],[Paydown Equity (%)],[Funding Equity (%)],[Target Equity (%)],[Maturity Date],[Pledge Date],[Liability Source])

	) as sq_up  
		 ) as sq  
     PIVOT (
        MIN(Amount)
        FOR [RowCount] IN
           (' + @cols + N')
           ) as p

		   
ORDER BY CASE WHEN [0] = ''Effective Date'' THEN ''a''
WHEN [0] = ''Paydown Equity (%)'' THEN ''b''
WHEN [0] = ''Funding Equity (%)'' THEN ''c''
WHEN [0] = ''Target Equity (%)'' THEN ''d''
WHEN [0] = ''Maturity Date'' THEN ''e''
WHEN [0] = ''Pledge Date'' THEN ''f''
WHEN [0] = ''Liability Source'' THEN ''g''
ELSE [0] END ASC
'

END

IF(@ModuleName = 'GeneralSetupDetailsDebt')
BEGIN
select @cols = STUFF((SELECT ',' + QUOTENAME( Convert (nvarchar(MAX), cast((ROW_NUMBER() over (order by GeneralSetupDetailsDebtID))  as varchar(50)), 101) ) 
             from [CORE].GeneralSetupDetailsDebt ln
				INNER JOIN [CORE].[Event] eve ON eve.EventID = ln.EventId
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
				INNER JOIN [CRE].[Debt] n ON n.AccountID = acc.AccountID
				LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
				where n.AccountID = @AccountId  and acc.IsDeleted = 0
				and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)
                group by eve.EffectiveStartDate,GeneralSetupDetailsDebtID
                   
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')
		PRINT(@cols);

	set @query = N'SELECT [0],' + @cols + N'
  FROM (
  SELECT [RowCount], Amount, [0]
	FROM (			
			Select 
			cast((ROW_NUMBER() over (order by eve.EffectiveStartDate))  as varchar(50))   as [RowCount]
			,ISNULL(Convert (nvarchar(MAX), eve.EffectiveStartDate, 101),'''') as [Effective Date]
			,Cast(ISNULL(cast(ln.Commitment as DECIMAL(28,5)),0)as nvarchar(MAX)) as [Commitment]
			,ISNULL(Convert (nvarchar(MAX), ln.InitialMaturityDate, 101),'''') as [Initial Maturity Date]
			
			from [CORE].GeneralSetupDetailsDebt ln
				INNER JOIN [CORE].[Event] eve ON eve.EventID = ln.EventId
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
				INNER JOIN [CRE].[Debt] n ON n.AccountID = acc.AccountID
				LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID

			where n.AccountID = '''+ cast(@AccountId as varchar(256))+'''  and acc.IsDeleted = 0
				and eve.StatusID = (Select LookupID from Core.Lookup where name = ''Active'' and parentid = 1)

			) as sq_source
		UNPIVOT (Amount FOR [0] IN
		([Effective Date],[Commitment],[Initial Maturity Date])

	) as sq_up  
		 ) as sq  
     PIVOT (
        MIN(Amount)
        FOR [RowCount] IN
           (' + @cols + N')
           ) as p

		   
ORDER BY CASE WHEN [0] = ''Effective Date'' THEN ''a''
WHEN [0] = ''Commitment'' THEN ''b''
WHEN [0] = ''Initial Maturity Date'' THEN ''c''
ELSE [0] END ASC
'

END

IF(@ModuleName = 'GeneralSetupDetailsEquity')
BEGIN
select @cols = STUFF((SELECT ',' + QUOTENAME( Convert (nvarchar(MAX), cast((ROW_NUMBER() over (order by GeneralSetupDetailsEquityID))  as varchar(50)), 101) ) 
             from [CORE].GeneralSetupDetailsEquity ln
				INNER JOIN [CORE].[Event] eve ON eve.EventID = ln.EventId
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
				INNER JOIN [CRE].[Equity] n ON n.AccountID = acc.AccountID
				LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
				where n.AccountID = @AccountId  and acc.IsDeleted = 0
				and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)
                group by eve.EffectiveStartDate,GeneralSetupDetailsEquityID
                   
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')
		PRINT(@cols);

	set @query = N'SELECT [0],' + @cols + N'
  FROM (
  SELECT [RowCount], Amount, [0]
	FROM (			
			Select 
			cast((ROW_NUMBER() over (order by eve.EffectiveStartDate))  as varchar(50))   as [RowCount]
			,ISNULL(Convert (nvarchar(MAX), eve.EffectiveStartDate, 101),'''') as [Effective Date]
			,Cast(ISNULL(cast(ln.Commitment as DECIMAL(28,5)),0)as nvarchar(MAX)) as [Commitment]
			,ISNULL(Convert (nvarchar(MAX), ln.InitialMaturityDate, 101),'''') as [Initial Maturity Date]
			
			from [CORE].GeneralSetupDetailsEquity ln
				INNER JOIN [CORE].[Event] eve ON eve.EventID = ln.EventId
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
				INNER JOIN [CRE].[Equity] n ON n.AccountID = acc.AccountID
				LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID

			where n.AccountID = '''+ cast(@AccountId as varchar(256))+'''  and acc.IsDeleted = 0
				and eve.StatusID = (Select LookupID from Core.Lookup where name = ''Active'' and parentid = 1)

			) as sq_source
		UNPIVOT (Amount FOR [0] IN
		([Effective Date],[Commitment],[Initial Maturity Date])

	) as sq_up  
		 ) as sq  
     PIVOT (
        MIN(Amount)
        FOR [RowCount] IN
           (' + @cols + N')
           ) as p

		   
ORDER BY CASE WHEN [0] = ''Effective Date'' THEN ''a''
WHEN [0] = ''Commitment'' THEN ''b''
WHEN [0] = ''Initial Maturity Date'' THEN ''c''
ELSE [0] END ASC
'

END

IF(@ModuleName = 'InterestExpenseSchedule')
BEGIN

	
select @cols = STUFF((SELECT ',' + QUOTENAME( Convert (nvarchar(MAX), cast((ROW_NUMBER() over (order by iES.InterestExpenseScheduleID))  as varchar(50)), 101) ) 
		from [Core].[InterestExpenseSchedule] iES
		INNER JOIN [CORE].[Event] eve ON eve.EventID = iES.EventId
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
		--INNER JOIN [CRE].[Debt] n ON n.AccountID = acc.AccountID
		LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
		where acc.AccountID = @AccountId  and acc.IsDeleted = 0
				and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)
				and 1 = (CASE WHEN @AdditionalAccountId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN @AdditionalAccountId <> '00000000-0000-0000-0000-000000000000' and eve.AdditionalAccountID = @AdditionalAccountId THEN 1 END)               
                group by eve.EffectiveStartDate,iES.InterestExpenseScheduleID
                   
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')


PRINT(@cols);

	set @query = N'SELECT [0],' + @cols + N'
  FROM (
  
	SELECT [RowCount], Amount, [0]
	FROM (			
			Select 
			cast((ROW_NUMBER() over (order by eve.EffectiveStartDate))  as varchar(50))   as [RowCount]
			,ISNULL(Convert (nvarchar(MAX), eve.EffectiveStartDate, 101),'''') [Effective Date]
			,ISNULL(Convert (nvarchar(MAX), iES.[InitialInterestAccrualEndDate], 101),'''') as [Initial Interest Accrual End Date]
			,Cast(ISNULL(cast(cast(iES.[PaymentDayOfMonth] as DECIMAL(28,5)) as float),0)as nvarchar(MAX)) as [Payment Day Of Month]
			,Cast(ISNULL(cast(iES.PaymentDateBusinessDayLag as DECIMAL(28,5)),0)as nvarchar(MAX)) as [Payment Date Business Day Lag]
			,Cast(ISNULL(cast(iES.DeterminationDateLeadDays as DECIMAL(28,5)),0)as nvarchar(MAX)) as [Determination Date Lead Days]
			,Cast(ISNULL(cast(iES.DeterminationDateReferenceDayOftheMonth as DECIMAL(28,5)),0)as nvarchar(MAX)) as [Determination Date Reference Day Of the Month]
			,Cast(ISNULL(cast(iES.InitialIndexValueOverride as DECIMAL(28,5)),0)as nvarchar(MAX)) as [Initial Index Value Override]
			,ISNULL(Convert (nvarchar(MAX), iES.[FirstRateIndexResetDate], 101),'''') as [First Rate Index Reset Date]

			from [Core].[InterestExpenseSchedule] iES
			INNER JOIN [CORE].[Event] eve ON eve.EventID = iES.EventId
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
			LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID

			where acc.AccountID = '''+ cast(@AccountId as varchar(256))+'''  and acc.IsDeleted = 0
			and eve.StatusID = 1
			and 1 = (CASE WHEN '''+ cast(@AdditionalAccountId as varchar(256))+''' = ''00000000-0000-0000-0000-000000000000'' THEN 1 WHEN '''+ cast(@AdditionalAccountId as varchar(256))+''' <> ''00000000-0000-0000-0000-000000000000'' and eve.AdditionalAccountID = '''+ cast(@AdditionalAccountId as varchar(256))+''' THEN 1 END)
               
			) as sq_source
		UNPIVOT (Amount FOR [0] IN
		([Effective Date],[Initial Interest Accrual End Date],[Payment Day Of Month],[Payment Date Business Day Lag] , [Determination Date Lead Days], [Determination Date Reference Day Of the Month],
		[Initial Index Value Override],[First Rate Index Reset Date])

	) as sq_up  
		 ) as sq  
     PIVOT (
        MIN(Amount)
        FOR [RowCount] IN
           (' + @cols + N')
           ) as p

		   
ORDER BY CASE WHEN [0] = ''Effective Date'' THEN ''a''
WHEN [0] = ''Initial Interest Accrual End Date'' THEN ''b''
WHEN [0] = ''Payment Day Of Month'' THEN ''c''
WHEN [0] = ''Payment Date Business Day Lag'' THEN ''d''
WHEN [0] = ''Determination Date Lead Days'' THEN ''e''
WHEN [0] = ''Determination Date Reference Day Of the Month'' THEN ''f''
WHEN [0] = ''Initial Index Value Override'' THEN ''g''
WHEN [0] = ''First Rate Index Reset Date'' THEN ''h''
ELSE [0] END ASC
'

END

PRINT(@query)
exec sp_executesql @query;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
