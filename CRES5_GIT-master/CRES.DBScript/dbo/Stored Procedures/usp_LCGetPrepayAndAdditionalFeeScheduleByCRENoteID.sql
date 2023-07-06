
CREATE PROCEDURE [dbo].[usp_LCGetPrepayAndAdditionalFeeScheduleByCRENoteID] --'7831'
(
	@CRENoteID NVARCHAR(256)
)
	
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF;
   

DECLARE @cols AS NVARCHAR(MAX),
@query  AS NVARCHAR(MAX)

select @cols = STUFF((SELECT ',' + QUOTENAME( Convert (nvarchar(MAX), cast((ROW_NUMBER() over (order by pafs.PrepayAndAdditionalFeeScheduleID))  as varchar(50)), 101) ) 
		from [CORE].[PrepayAndAdditionalFeeSchedule] pafs
		INNER JOIN [CORE].[Event] eve ON eve.EventID = pafs.EventId
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
		LEFT JOIN [CRE].[FeeSchedulesConfig] LValueTypeID ON LValueTypeID.FeeTypeNameID = pafs.ValueTypeID
		LEFT JOIN [CORE].[Lookup] LApplyTrueUpFeature ON LApplyTrueUpFeature.LookupID = pafs.ApplyTrueUpFeature
		where n.CRENoteID = @CRENoteID and  acc.IsDeleted = 0
				and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)
                group by eve.EffectiveStartDate,pafs.PrepayAndAdditionalFeeScheduleID
                   
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')


PRINT(@cols);

	set @query = N'SELECT ' + @cols + N'
  FROM (
  
	SELECT [RowCount], Amount, [0]
	FROM (			
			Select 
			cast((ROW_NUMBER() over (order by eve.EffectiveStartDate,pafs.[StartDate],pafs.PrepayAndAdditionalFeeScheduleID))  as varchar(50))   as [RowCount]
			,ISNULL(CAST(pafs.FeeName  as nvarchar(MAX)) ,'''') as [FeeName]
			,ISNULL(Convert (nvarchar(MAX), eve.EffectiveStartDate, 101),'''') [Effective Date]
			,ISNULL(Convert (nvarchar(MAX), pafs.[StartDate], 101),'''') as [Start Date]
			,ISNULL(Convert (nvarchar(MAX), pafs.[EndDate], 101),'''') as [End Date]
			,ISNULL(CAST(LValueTypeID.FeeTypeNameText  as nvarchar(MAX)) ,'''') as [Fee Type]
			,ISNULL(CAST(pafs.Value  as nvarchar(MAX)) ,'''') as [Fee]
			,ISNULL(Cast(pafs.FeeAmountOverride  as nvarchar(MAX)) ,'''')as [FeeAmountOverride]
			,ISNULL(Cast(pafs.BaseAmountOverride  as nvarchar(MAX)) ,'''')as [BaseAmountOverride]
			,ISNULL(CAST(LApplyTrueUpFeature.Name  as nvarchar(MAX)) ,'''') as [ApplyTrueUpFeature]
			,ISNULL(Cast(pafs.IncludedLevelYield  as nvarchar(MAX)) ,'''') as [Included Level Yield]
			,ISNULL(Cast(pafs.FeetobeStripped  as nvarchar(MAX)) ,'''')as [FeetobeStripped]
			
			from [CORE].[PrepayAndAdditionalFeeSchedule] pafs
			INNER JOIN [CORE].[Event] eve ON eve.EventID = pafs.EventId
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
			LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
			LEFT JOIN [CRE].[FeeSchedulesConfig] LValueTypeID ON LValueTypeID.FeeTypeNameID = pafs.ValueTypeID
			LEFT JOIN [CORE].[Lookup] LApplyTrueUpFeature ON LApplyTrueUpFeature.LookupID = pafs.ApplyTrueUpFeature

			where n.CRENoteID = '''+ cast(@CRENoteID as varchar(256))+'''  and  acc.IsDeleted = 0
			and eve.StatusID = (Select LookupID from Core.Lookup where name = ''Active'' and parentid = 1)

			) as sq_source
		UNPIVOT (Amount FOR [0] IN
		([FeeName],[Effective Date],[Start Date],[End Date],[Fee Type],[Fee],[FeeAmountOverride],[BaseAmountOverride],[ApplyTrueUpFeature],[Included Level Yield],[FeetobeStripped])

	) as sq_up


		 ) as sq
     PIVOT (
        MIN(Amount)
        FOR [RowCount] IN
           (' + @cols + N')
           ) as p

ORDER BY CASE WHEN [0] = ''FeeName'' THEN ''A''
WHEN [0] = ''Effective Date'' THEN ''B''
WHEN [0] = ''Start Date'' THEN ''C''
WHEN [0] = ''End Date'' THEN ''D''
WHEN [0] = ''Fee Type'' THEN ''E''
WHEN [0] = ''Fee'' THEN ''F''
WHEN [0] = ''FeeAmountOverride'' THEN ''G''
WHEN [0] = ''BaseAmountOverride'' THEN ''H''
WHEN [0] = ''ApplyTrueUpFeature'' THEN ''I''
WHEN [0] = ''Included Level Yield'' THEN ''J''
WHEN [0] = ''FeetobeStripped'' THEN ''K''
ELSE [0] END ASC
'

EXEC(@query);
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED

END
