-- [dbo].[usp_GetNoteDealFundingScheduleDealID_TEST] '8221fe2d-bf76-4751-b364-084ddc1aa2f6','8221fe2d-bf76-4751-b364-084ddc1aa2f6',1

CREATE PROCEDURE [dbo].[usp_GetNoteDealFundingScheduleDealID_TEST] 
(
    @UserID UNIQUEIDENTIFIER,
    @DealID UNIQUEIDENTIFIER,
	@IsShowUseRuleN bit=0
)
	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @ColPivot AS NVARCHAR(MAX),
    @query  AS NVARCHAR(MAX),
	@query1 as nvarchar(MAX)

Declare @UseRuletoDetermineNoteFundingAsYes int=(Select LookupID from CORE.Lookup where Name = 'Y' and Parentid = 2)
Declare @UseRuletoDetermineNoteFundingAsNo int= (Select LookupID from CORE.Lookup where Name = 'N' and Parentid = 2)
Declare  @FundingSchedule  int  =10;
DECLARE @Active int = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
Declare @InActive as nvarchar(256)=(select LookupID from core.lookup where name ='InActive' and ParentID=1);

Declare @OrderBy nvarchar(256);

	IF(@IsShowUseRuleN=0) --'Y'
	BEGIN
		set @query1='select a.DealFundingID,
a.DealID,
a.Date,
a.Value,
a.PurposeText,
a.SNO,
b.FundingScheduleID,
a.Comment,
b.date as FF_Date,
b.FF_Amount,
b.crenoteid,
a.credealid,
a.dealname,
a.Applied as WireConfirm,
b.noteid
 from(	
		Select
		 fs.DealFundingID DealFundingID 
		,fs.[DealID] DealID
		,d.credealid
		,d.dealname
		,fs.[Date] Date
		,fs.[Amount] Value
		,fs.[Comment] Comment
		,fs.[Comment] OldComment
		,fs.[PurposeID] PurposeID
		,fs.UpdatedDate UpdatedDate
		,l1.name PurposeText
		,ISNULL(fs.Applied,0) Applied
		,DrawFundingId
		,fs.[Date] as orgDate
		,fs.[Amount] as orgValue
		,ISNULL(fs.Applied,0) as OrgApplied
		,fs.[PurposeID] as orgPurposeID
		,l1.name  as OrgPurposeText
		,fs.Issaved as Issaved
		,ISNULL(fs.DealFundingRowno,0) as DealFundingRowno
		,(SELECT TOP 1 sm.StatusName FROM [CRE].[WFTaskDetail] td 
		INNER JOIN [CRE].[WFStatusPurposeMapping] spm ON spm.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
		INNER JOIN [CRE].[WFStatusMaster] sm ON sm.WFStatusMasterID = spm.WFStatusMasterID
		WHERE TaskId = fs.DealFundingID 
		ORDER BY WFTaskDetailID DESC ) as WF_CurrentStatus
		,ISNULL
		( (
		SELECT TOP 1 1 FROM [CRE].[WFTaskDetail] td 
		INNER JOIN [CRE].[WFStatusPurposeMapping] spm ON spm.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
		INNER JOIN [CRE].[WFStatusMaster] sm ON sm.WFStatusMasterID = spm.WFStatusMasterID
		WHERE TaskId = fs.DealFundingID  and spm.OrderIndex = (
		 SELECT MAX(OrderIndex) FROm [CRE].[WFStatusPurposeMapping] WHERE PurposetypeId = spm.PurposeTypeId 
		) ORDER BY WFTaskDetailID DESC )
		,ISNULL(fs.Applied,0) ) AS WF_IsCompleted
		,(SELECT ISNULL((SELECT TOP 1 1 FROM [CRE].[WFStatusPurposeMapping] WHERE PurposetypeId = fs.[PurposeID] AND IsEnable = 1),0)) as WF_IsAllow
		,ISNULL
		(([dbo].[Fn_GetGetWorkflowAccessPermissionByTaskAndUserID](fs.DealFundingID,'''+convert(varchar(MAX),@UserID)+''',''all'',null,null,null,null,null)),1) as wf_isUserCurrentFlow,
		(Select Top 1 Count(wl.WFTaskDetailID)  from [CRE].WFTaskDetail wl where wl.TaskID=fs.DealFundingID) as WF_isParticipate
		,(SELECT CASE WHEN (SELECT MIN(OrderIndex) FROm [CRE].[WFStatusPurposeMapping] WHERE PurposetypeId = fs.[PurposeID] ) !=
		 (SELECT TOP 1 spm.OrderIndex  FROM [CRE].[WFTaskDetail] td 
		INNER JOIN [CRE].[WFStatusPurposeMapping] spm ON spm.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
		INNER JOIN [CRE].[WFStatusMaster] sm ON sm.WFStatusMasterID = spm.WFStatusMasterID
		WHERE TaskId = fs.DealFundingID
		ORDER BY WFTaskDetailID DESC
		)
		THEN 1 ELSE 0 END
		) AS WF_IsFlowStart,
		ROW_NUMBER() OVER (PARTITION BY  fs.dealid ORDER BY fs.dealid,fs.[Date],fs.[PurposeID]) AS SNO

		from [CRE].[DealFunding] fs
		left join cre.deal d on d.DealID = fs.DealID
		Left Join Core.Lookup l1 on fs.PurposeID=l1.LookupID
		where fs.DealID = '''+convert(varchar(MAX),@DealID)+''' and d.IsDeleted = 0
		--order by fs.[Date]
		) a
		'

		SET @ColPivot = STUFF((SELECT  ',' + QUOTENAME(cast(acc.Name as nvarchar(256)) )                   
						   from [CORE].[Event] e
							INNER JOIN [CRE].[Note] n ON n.Account_AccountID = e.AccountID
							INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
							INNER JOIN (
								Select 
								(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
								MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
								from [CORE].[Event] eve
								INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
								INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
								where EventTypeID = @FundingSchedule
								and n.DealID = @DealID
								and eve.StatusID = @Active
								and acc.IsDeleted = 0
								GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID
							) sEvent ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
							where e.EventTypeID = @FundingSchedule
							and n.DealID = @DealID 
							and e.StatusID = @Active
							and acc.IsDeleted = 0 and n.UseRuletoDetermineNoteFunding=@UseRuletoDetermineNoteFundingAsYes					
							order by ISNULL(n.lienposition,99999), n.Priority,n.InitialFundingAmount desc, acc.Name 

					FOR XML PATH(''), TYPE
					).value('.', 'NVARCHAR(MAX)') 
				,1,1,'')

		set @query = 'left join( SELECT DealID, Date,PurposeID as b_PurposeID,DealFundingRowno as b_DealFundingRowno,' + @ColPivot + ' ,FundingScheduleID,FF_Amount,crenoteid,noteid
		from (						
		Select  ROW_NUMBER() OVER (PARTITION BY  fs.[Date],fs.[PurposeID],df.DealFundingRowno,acc.Name  ORDER BY fs.[Date]) AS SNO
		,df.DealID DealID
		,acc.Name Name
		,fs.[Date] Date
		,fs.PurposeID
		,fs.Value Value
		,ISNULL(fs.DealFundingRowno,ISNULL(df.DealFundingRowno,0)) as DealFundingRowno,
		fs.FundingScheduleID
		,fs.Value FF_Amount
		,n.crenoteid
		,n.noteid
		from 
		[CRE].[DealFunding] df
		left join cre.deal d on d.DealID = df.DealID and d.DEalID='''+convert(varchar(MAX),@DealID)+'''
		left join [CORE].FundingSchedule fs on df.[Date]=fs.[Date]  and ISNULL(df.purposeid,1)=ISNULL(fs.purposeid,1) and ISNULL(df.DealFundingRowno,0)=ISNULL(fs.DealFundingRowno,ISNULL(df.DealFundingRowno,0))
		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
		INNER JOIN (Select 
							(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
							MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
							from [CORE].[Event] eve
							INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
							INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
							where EventTypeID = '''+convert(varchar(MAX),@FundingSchedule)+''' 
							and n.DealID = '''+convert(varchar(MAX),@DealID)+'''
							and eve.StatusID ='''+convert(varchar(MAX),@Active)+'''  
							and acc.IsDeleted = 0
							GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID
					) sEvent
		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		where sEvent.StatusID = e.StatusID and n.UseRuletoDetermineNoteFunding=(Select LookupID from Core.Lookup where name = ''Y'' and parentId=2)
		--and isnull(acc.StatusID, '''+convert(varchar(MAX),@Active)+''')!= '''+convert(varchar(MAX),@InActive)+''' 
		and acc.IsDeleted = 0 and 
		df.DealID ='''+convert(varchar(MAX),@DealID)+''' and d.IsDeleted = 0
		) x 
		pivot 
		(
			sum(Value)
			for 
			Name in (' + @ColPivot + ')
		) p '

		set @query=@query + ') b on a.DealID=b.DealID and a.Date=b.Date and ISNULL(a.PurposeID,1)=ISNULL(b.b_PurposeID,1) and a.DealFundingRowno=b.b_DealFundingRowno '

		SET @OrderBy  = ' order by a.Date,ISNULL(a.DealFundingRowno,0)' 

	END
	ELSE
	BEGIN

		IF EXISTS(Select * from cre.dealfunding where dealid = @DealID)
		BEGIN
		
			set @query1='select a.DealFundingID,
a.DealID,
a.Date,
a.Value,
a.PurposeText,
a.SNO,
b.FundingScheduleID,
a.Comment ,
b.date as FF_Date,
b.FF_Amount,
b.crenoteid,
a.credealid,
a.dealname,
a.Applied as WireConfirm,
b.noteid
from(	
			Select
			 fs.DealFundingID DealFundingID 
			,fs.[DealID] DealID
			,d.credealid
			,d.dealname
			,fs.[Date] Date
			,fs.[Amount] Value
			,fs.[Comment] Comment
			,fs.[Comment] OldComment
			,fs.[PurposeID] PurposeID
			,fs.UpdatedDate UpdatedDate
			,l1.name PurposeText
			,ISNULL(fs.Applied,0) Applied
			,DrawFundingId
			,fs.[Date] as orgDate
			,fs.[Amount] as orgValue
			,ISNULL(fs.Applied,0) as OrgApplied
			,fs.[PurposeID] as orgPurposeID
			,l1.name  as OrgPurposeText
			,fs.Issaved as Issaved
			,ISNULL(fs.DealFundingRowno,0) as DealFundingRowno
			,(SELECT TOP 1 sm.StatusName FROM [CRE].[WFTaskDetail] td 
			INNER JOIN [CRE].[WFStatusPurposeMapping] spm ON spm.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
			INNER JOIN [CRE].[WFStatusMaster] sm ON sm.WFStatusMasterID = spm.WFStatusMasterID
			WHERE TaskId = fs.DealFundingID 
			ORDER BY WFTaskDetailID DESC ) as WF_CurrentStatus
			,ISNULL
			( (
			SELECT TOP 1 1 FROM [CRE].[WFTaskDetail] td 
			INNER JOIN [CRE].[WFStatusPurposeMapping] spm ON spm.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
			INNER JOIN [CRE].[WFStatusMaster] sm ON sm.WFStatusMasterID = spm.WFStatusMasterID
			WHERE TaskId = fs.DealFundingID  and spm.OrderIndex = (
			 SELECT MAX(OrderIndex) FROm [CRE].[WFStatusPurposeMapping] WHERE PurposetypeId = spm.PurposeTypeId 
			) ORDER BY WFTaskDetailID DESC )
			,ISNULL(fs.Applied,0) ) AS WF_IsCompleted
			,(SELECT ISNULL((SELECT TOP 1 1 FROM [CRE].[WFStatusPurposeMapping] WHERE PurposetypeId = fs.[PurposeID] AND IsEnable = 1),0)) as WF_IsAllow
			,ISNULL
			(([dbo].[Fn_GetGetWorkflowAccessPermissionByTaskAndUserID](fs.DealFundingID,'''+convert(varchar(MAX),@UserID)+''',''all'',null,null,null,null,null)),1) as wf_isUserCurrentFlow,
			(Select Top 1 Count(wl.WFTaskDetailID)  from [CRE].WFTaskDetail wl where wl.TaskID=fs.DealFundingID) as WF_isParticipate
			,(SELECT CASE WHEN (SELECT MIN(OrderIndex) FROm [CRE].[WFStatusPurposeMapping] WHERE PurposetypeId = fs.[PurposeID] ) !=
			 (SELECT TOP 1 spm.OrderIndex  FROM [CRE].[WFTaskDetail] td 
			INNER JOIN [CRE].[WFStatusPurposeMapping] spm ON spm.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
			INNER JOIN [CRE].[WFStatusMaster] sm ON sm.WFStatusMasterID = spm.WFStatusMasterID
			WHERE TaskId = fs.DealFundingID
			ORDER BY WFTaskDetailID DESC
			)
			THEN 1 ELSE 0 END
			) AS WF_IsFlowStart,
			ROW_NUMBER() OVER (PARTITION BY  fs.dealid ORDER BY fs.dealid,fs.[Date],fs.[PurposeID]) AS SNO

			from [CRE].[DealFunding] fs
			left join cre.deal d on d.DealID = fs.DealID
			Left Join Core.Lookup l1 on fs.PurposeID=l1.LookupID
			where fs.DealID = '''+convert(varchar(MAX),@DealID)+''' and d.IsDeleted = 0
			--order by fs.[Date]
			) a
			'

			SET @ColPivot = STUFF((SELECT  ',' + QUOTENAME(cast(acc.Name as nvarchar(256)) )                   
							  from [CRE].[Note] n
							INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
									and n.DealID = @DealID
									and acc.IsDeleted = 0
									--and ISNULL(n.UseRuletoDetermineNoteFunding,4) =  4
								order by ISNULL(n.lienposition,99999), n.Priority,n.InitialFundingAmount desc, acc.Name 							
						FOR XML PATH(''), TYPE
						).value('.', 'NVARCHAR(MAX)') 
					,1,1,'')

	
			set @query = 'left join( SELECT DealID, Date,PurposeID as b_PurposeID,DealFundingRowno as b_DealFundingRowno,' + @ColPivot + ' ,FundingScheduleID,FF_Amount,crenoteid,noteid
				from (
				Select  ROW_NUMBER() OVER (PARTITION BY  fs.[Date],fs.[PurposeID],df.DealFundingRowno,acc.Name  ORDER BY fs.[Date]) AS SNO
			,df.DealID DealID
			,acc.Name Name
			,fs.[Date] Date
			,fs.PurposeID
			,fs.Value Value
			,ISNULL(fs.DealFundingRowno,ISNULL(df.DealFundingRowno,0)) as DealFundingRowno
			,fs.FundingScheduleID
			,fs.Value FF_Amount
			,n.crenoteid
			,n.noteid
			from 
			[CRE].[DealFunding] df
			left join cre.deal d on d.DealID = df.DealID and d.DEalID='''+convert(varchar(MAX),@DealID)+'''
			left join [CORE].FundingSchedule fs on df.[Date]=fs.[Date]  and ISNULL(df.purposeid,1)=ISNULL(fs.purposeid,1) and ISNULL(df.DealFundingRowno,0)=ISNULL(fs.DealFundingRowno,ISNULL(df.DealFundingRowno,0))
			INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
			INNER JOIN (
							Select 
							(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
							MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
							from [CORE].[Event] eve
							INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
							INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
							where EventTypeID = '''+convert(varchar(MAX),@FundingSchedule)+''' 
							and n.DealID = '''+convert(varchar(MAX),@DealID)+'''
							and eve.StatusID ='''+convert(varchar(MAX),@Active)+'''  
							and acc.IsDeleted = 0
							GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID
						) sEvent ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
			left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
			where sEvent.StatusID = e.StatusID 
			--and isnull(acc.StatusID, '''+convert(varchar(MAX),@Active)+''')!= '''+convert(varchar(MAX),@InActive)+''' 
			and acc.IsDeleted = 0 and 
			df.DealID ='''+convert(varchar(MAX),@DealID)+''' and d.IsDeleted = 0
			) x 
			pivot 
			(
				sum(Value)
				for 
				Name in (' + @ColPivot + ')
			) p '

			set @query=@query + ') b on a.DealID=b.DealID and a.Date=b.Date and ISNULL(a.PurposeID,1)=ISNULL(b.b_PurposeID,1) and a.DealFundingRowno=b.b_DealFundingRowno '
			
			SET @OrderBy  = ' order by a.Date,ISNULL(a.DealFundingRowno,0)' 

		END
		ELSE
		BEGIN
			

			SET @ColPivot = STUFF((SELECT  ',null as ' + QUOTENAME(cast(acc.Name as nvarchar(256)) )                   
							  from [CRE].[Note] n
							INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
									and n.DealID = @DealID
									and acc.IsDeleted = 0
									--and ISNULL(n.UseRuletoDetermineNoteFunding,4) =  4
								order by ISNULL(n.lienposition,99999), n.Priority,n.InitialFundingAmount desc, acc.Name 							
						FOR XML PATH(''), TYPE
						).value('.', 'NVARCHAR(MAX)') 
					,1,1,'')

			set @query1='
			
			Select
			null as DealFundingID ,
			null as DealID ,
			null as Date ,
			null as Value ,
			null as Comment ,
			null as OldComment,
			null as PurposeID ,
			null as UpdatedDate ,
			null as PurposeText ,
			null as Applied ,
			null as DrawFundingId ,
			null as orgDate ,
			null as orgValue ,
			null as OrgApplied ,
			null as orgPurposeID ,
			null as OrgPurposeText ,
			null as Issaved ,
			null as DealFundingRowno ,
			null as WF_CurrentStatus ,
			null as WF_IsCompleted ,
			null as WF_IsAllow ,
			null as wf_isUserCurrentFlow ,
			null as WF_isParticipate ,
			null as WF_IsFlowStart ,
			null as DealID ,
			null as Date ,
			null as b_PurposeID ,
			null as b_DealFundingRowno,' + @ColPivot + ' '

			set @query = ' '
			SET @OrderBy  = ' ' 

		END

	END

--Declare @OrderBy nvarchar(256) = ' order by a.Date,ISNULL(a.DealFundingRowno,0)' 


--print @query1
--print @query
--print @OrderBy


exec(@query1+@query + @OrderBy);


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END



