 
--[dbo].[usp_GetNoteDealFundingScheduleDealID]  'b0e6697b-3534-4c09-be0a-04473401ab93', '50dee1cb-0776-430c-b68d-0800cca947e8',1      
--[dbo].[usp_GetNoteDealFundingScheduleDealID]  'b4718098-fbab-46b6-8d0a-4905b80f6493', 'B9A7EDE5-A3B7-4326-A7C0-BC5929000539'  ,0  
   --41--116

CREATE PROCEDURE [dbo].[usp_GetNoteDealFundingScheduleDealID]        
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
@query1 as nvarchar(MAX) ,
@query2 as nvarchar(MAX) ,
@query3 as nvarchar(MAX)  ,
@query4 as nvarchar(MAX) ,
@query5 as nvarchar(MAX)     
      
Declare @UseRuletoDetermineNoteFundingAsYes int=(Select LookupID from CORE.Lookup where Name = 'Y' and Parentid = 2)      
Declare @UseRuletoDetermineNoteFundingAsNo int= (Select LookupID from CORE.Lookup where Name = 'N' and Parentid = 2)      
Declare  @FundingSchedule  int  =10;      
DECLARE @Active int = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)      
Declare @InActive as nvarchar(256)=(select LookupID from core.lookup where name ='InActive' and ParentID=1),@TaskTypeID int=502     
      
Declare @OrderBy nvarchar(256)

Declare @SkipWorkflowNotification bit =1

      
 IF(@IsShowUseRuleN=0) --'Y'      
 BEGIN      
  SET @ColPivot = STUFF((SELECT  ',' + QUOTENAME(cast(acc.Name as nvarchar(256)) )                         
         from [CRE].[Note] n      
       INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID      
         and n.DealID = @DealID      
         and acc.IsDeleted = 0      
         and ISNULL(n.UseRuletoDetermineNoteFunding,4) =  3      
        order by ISNULL(n.lienposition,99999), n.Priority,n.InitialFundingAmount desc, acc.Name              
      FOR XML PATH(''), TYPE      
      ).value('.', 'NVARCHAR(MAX)')       
     ,1,1,'')      
      
   
      
  set @query1='select a.DealFundingID      
  ,a.Value      
  ,a.Comment      
  ,a.OldComment      
  ,a.PurposeText      
  ,a.EquityAmount       
  ,a.RequiredEquity      
  ,a.AdditionalEquity       
  --,a.SubPurposeType      
  ,a.UpdatedDate      
  ,a.Applied    
  ,a.AdjustmentType  
  ,a.DrawFundingId      
  ,a.orgDate      
  ,a.orgValue      
  ,a.OrgApplied      
  ,a.orgPurposeID      
  ,a.OrgPurposeText      
  ,a.Issaved      
  ,a.WF_CurrentStatus      
  ,(case when a.WF_CurrentStatus is null then null else a.WF_CurrentStatusDisplayName end) as WF_CurrentStatusDisplayName      
  ,a.WF_IsCompleted      
  ,a.WF_IsAllow      
  ,a.wf_isUserCurrentFlow      
  ,a.WF_isParticipate      
  ,a.WF_IsFlowStart
  ,a.DealID,a.Date,a.PurposeID,a.DealFundingRowno, a.DrawFeeStatus,a.DrawFeeStatusName,a.DrawFeeFile,a.IsShowDrawStatus,a.GeneratedByText,a.GeneratedByUserID ' + IIF(ISNULL(@ColPivot,'') = '','',','+ISNULL(@ColPivot,'')) + '       
   from(       
  Select      
   fs.DealFundingID DealFundingID       
  ,fs.[DealID] DealID      
  ,fs.[Date] Date      
  ,fs.[Amount] Value      
  ,fs.[Comment] Comment      
  ,fs.[Comment] OldComment      
  ,fs.[PurposeID] PurposeID      
  ,l1.name PurposeText      
  ,fs.EquityAmount      
  ,fs.RequiredEquity      
  ,fs.AdditionalEquity      
  --,fs.SubPurposeType      
  ,fs.UpdatedDate UpdatedDate        
  ,ISNULL(fs.Applied,0) Applied  
  ,fs.AdjustmentType    
  ,DrawFundingId      
  ,fs.[Date] as orgDate      
  ,fs.[Amount] as orgValue      
  ,ISNULL(fs.Applied,0) as OrgApplied      
  ,fs.[PurposeID] as orgPurposeID      
  ,l1.name  as OrgPurposeText      
  ,fs.Issaved as Issaved      
  'SET @query2 = N'
  ,ISNULL(fs.DealFundingRowno,0) as DealFundingRowno 
	,(CASE WHEN tblPhtm.dealid is not null THEN NULL ELSE tblWF.WF_CurrentStatus END) as WF_CurrentStatus
	,tblWF.WF_CurrentStatusDisplayName as WF_CurrentStatusDisplayName
	,(SELECT CASE WHEN (SELECT MAX(OrderIndex) FROm [CRE].[WFStatusPurposeMapping] WHERE PurposetypeId = fs.[PurposeID] ) = tblWF.OrderIndex then 1 ELSE 0 END) as WF_IsCompleted
	,(SELECT ISNULL((SELECT TOP 1 1 FROM [CRE].[WFStatusPurposeMapping] WHERE PurposetypeId = fs.[PurposeID] AND IsEnable = 1),0)) as WF_IsAllow
	--,ISNULL(([dbo].[Fn_GetGetWorkflowAccessPermissionByTaskAndUserID]('''+convert(varchar(MAX),@TaskTypeID)+''',fs.DealFundingID,'''+convert(varchar(MAX),@UserID)+''',''all'',null,null,null,null,null)),1) as wf_isUserCurrentFlow 
	,0 as wf_isUserCurrentFlow 
	,iSNULL(tblWF.WF_isParticipate,0) as WF_isParticipate   
	,(SELECT CASE WHEN (SELECT MIN(OrderIndex) FROm [CRE].[WFStatusPurposeMapping] WHERE PurposetypeId = fs.[PurposeID] ) <> tblWF.OrderIndex then 1 ELSE 0 END) as WF_IsFlowStart
	,i.DrawFeeStatus      
  ,LDrawFeeStatusID.Name as DrawFeeStatusName      
  ,i.FileName as DrawFeeFile  
  ,IsShowDrawStatus= case when i.DrawFeeStatus is not null and ((fs.Applied=1 and i.DrawFeeStatus=692) or (fs.Applied=0 and i.DrawFeeStatus<>692) or (fs.Applied=1 and i.DrawFeeStatus<>692)) then 1 else 0 end  
  ,(CASE WHEN fs.GeneratedBy = 822 THEN  tblGeneratedBy_Name.Login ELSE lGeneratedBy.name END) as GeneratedByText
  ,tblGeneratedBy_Name.GeneratedByUserID
  from [CRE].[DealFunding] fs      
  left join cre.deal d on d.DealID = fs.DealID      
  Left Join Core.Lookup l1 on fs.PurposeID=l1.LookupID  
  Left Join Core.Lookup lGeneratedBy on fs.GeneratedBy=lGeneratedBy.LookupID     
  left join (
		select ObjectID,InvoiceTypeID,ObjectTypeID,DrawFeeStatus,[FileName] from cre.InvoiceDetail	where InvoiceTypeID=558 and ObjectTypeID=698 and ObjectID in (Select dealfundingid from cre.dealfunding where dealid = '''+convert(varchar(MAX),@DealID)+''')
    ) i on i.ObjectID=fs.DealFundingID and i.InvoiceTypeID=558 and i.ObjectTypeID=698  
  and exists(select 1 from cre.wfchecklistdetail where taskid = i.ObjectID and wfchecklistmasterID=9 and CheckListStatus=499)  
  left JOIN [CORE].[Lookup] LDrawFeeStatusID ON LDrawFeeStatusID.LookupID = i.DrawFeeStatus  
  Left Join(
	Select df.DealFundingID, u.[Login],NULLIF(df.GeneratedByUserID,'''') as GeneratedByUserID
	from [CRE].[DealFunding] df
	left join app.[user] u on u.userid = NULLIF(df.GeneratedByUserID,'''')
	Where df.DealID = '''+convert(varchar(MAX),@DealID)+'''
	and df.GeneratedBy = 822
  )tblGeneratedBy_Name on tblGeneratedBy_Name.DealFundingID = fs.DealFundingID  
  'SET @query3 = N'
  LEFT JOIN(
	select DealID from cre.deal where [status]=325 and isnull(linkeddealid,'''') ='''' and DealID = '''+convert(varchar(MAX),@DealID)+'''
  )tblPhtm on tblPhtm.dealid = d.dealid
  Left Join(
		Select TaskId,StatusName as WF_CurrentStatus,WF_CurrentStatusDisplayName,WF_isParticipate,OrderIndex
		From(
			SELECT td.TaskId
			,sm.StatusName
			,td.WFTaskDetailID	
			,(Case WHEN tblNoti.taskid is not null and sm.StatusName=''Completed'' then ''Completed''
                when tblChkd.CheckListStatus=881 and td.TaskTypeID=502 and sm.StatusName=''Completed'' then ''Completed''
				when (lPurposeType.Value1=''WF_UNDERREVIEW'' or df.[Amount] = 0) then sm.WFUnderReviewDisplayName 
				else sm.DealFundingDisplayName end) as WF_CurrentStatusDisplayName
			,ROW_NUMBER() OVER(Partition by td.TaskId order by td.TaskId,td.WFTaskDetailID desc) rno
			,COUNT( td.WFTaskDetailID ) OVER(Partition by td.TaskId) WF_isParticipate
			,spm.OrderIndex

			FROM [CRE].[WFTaskDetail] td       
			INNER JOIN [CRE].[WFStatusPurposeMapping] spm ON spm.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID      
			INNER JOIN [CRE].[WFStatusMaster] sm ON sm.WFStatusMasterID = spm.WFStatusMasterID    
			left JOin(
				select TaskID from cre.WFNotification where WFNotificationMasterID=2 and ActionType=577
			)tblNoti on tblNoti.taskid = td.taskid	
			LEFT JOIN cre.dealfunding df on df.dealfundingid = td.taskid
			LEFT JOIN core.Lookup lPurposeType on lPurposeType.LookupID = df.PurposeID and lPurposeType.ParentID = 50
            LEFT JOIN (
                select CheckListStatus,TaskId from cre.WFCheckListDetail
                where WFCheckListMasterID=21
            ) tblChkd on tblChkd.taskid = td.taskid	
			WHERE td.TaskId in (Select dealfundingid from cre.dealfunding where dealid = '''+convert(varchar(MAX),@DealID)+''')	
		)a
		where rno = 1
   )tblWF on tblWF.TaskId = fs.dealfundingid

	where fs.DealID = '''+convert(varchar(MAX),@DealID)+''' and d.IsDeleted = 0  and fs.PurposeID <> 840
  --order by fs.[Date]      
  ) a      
  '        
        
  set @query = 'left join( SELECT DealID, Date,PurposeID as PurposeID,DealFundingRowno as DealFundingRowno,' + @ColPivot + '       
  from (            
  Select  ROW_NUMBER() OVER (PARTITION BY  fs.[Date],fs.[PurposeID],df.DealFundingRowno,acc.Name  ORDER BY fs.[Date]) AS SNO      
  ,df.DealID DealID      
  ,acc.Name Name      
  ,fs.[Date] Date      
  ,fs.PurposeID      
  ,fs.Value Value      
  ,ISNULL(fs.DealFundingRowno,ISNULL(df.DealFundingRowno,0)) as DealFundingRowno      
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
  df.DealID ='''+convert(varchar(MAX),@DealID)+''' and d.IsDeleted = 0 and fs.PurposeID <> 840     
  ) x       
  pivot       
  (      
   sum(Value)      
   for       
   Name in (' + @ColPivot + ')      
  ) p '      
      
  set @query=@query + ') b on a.DealID=b.DealID and a.Date=b.Date and ISNULL(a.PurposeID,1)=ISNULL(b.PurposeID,1) and a.DealFundingRowno=b.DealFundingRowno '      
      
  SET @OrderBy  = ' order by a.Date,ISNULL(a.DealFundingRowno,0)'       
      
 END      
 ELSE      
 BEGIN      
      
  IF EXISTS(Select * from cre.dealfunding where dealid = @DealID)      
  BEGIN      
      
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
        
   set @query1='select a.DealFundingID      
  ,a.Value      
  ,a.Comment      
  ,a.OldComment      
  ,a.PurposeText      
  ,a.EquityAmount       
  ,a.RequiredEquity      
  ,a.AdditionalEquity      
  --,a.SubPurposeType      
  ,a.UpdatedDate      
  ,a.Applied  
  ,a.AdjustmentType    
  ,a.DrawFundingId      
  ,a.orgDate      
  ,a.orgValue      
  ,a.OrgApplied      
  ,a.orgPurposeID      
  ,a.OrgPurposeText      
  ,a.Issaved      
  ,a.WF_CurrentStatus      
  ,(case when a.WF_CurrentStatus is null then null else a.WF_CurrentStatusDisplayName end) as WF_CurrentStatusDisplayName      
  ,a.WF_IsCompleted      
  ,a.WF_IsAllow      
  ,a.wf_isUserCurrentFlow      
  ,a.WF_isParticipate      
  ,a.WF_IsFlowStart 
  ,a.DealID,a.Date,a.PurposeID,a.DealFundingRowno,a.DrawFeeStatus,a.DrawFeeStatusName,a.DrawFeeFile,a.IsShowDrawStatus,a.GeneratedByText,a.GeneratedByUserID,' + @ColPivot + '      
   from(       
   Select      
    fs.DealFundingID DealFundingID       
   ,fs.[DealID] DealID      
   ,fs.[Date] Date      
   ,fs.[Amount] Value      
   ,fs.[Comment] Comment      
   ,fs.[Comment] OldComment      
   ,fs.[PurposeID] PurposeID      
   ,l1.name PurposeText      
   ,fs.EquityAmount       
   ,fs.RequiredEquity      
   ,fs.AdditionalEquity        
   --,fs.SubPurposeType      
   ,fs.UpdatedDate UpdatedDate         
   ,ISNULL(fs.Applied,0) Applied
   ,fs.AdjustmentType
   ,DrawFundingId      
   ,fs.[Date] as orgDate      
   ,fs.[Amount] as orgValue      
   ,ISNULL(fs.Applied,0) as OrgApplied      
   ,fs.[PurposeID] as orgPurposeID      
   ,l1.name  as OrgPurposeText      
   ,fs.Issaved as Issaved      
   ,ISNULL(fs.DealFundingRowno,0) as DealFundingRowno  
   'SET @query2 = N'
   ,(CASE WHEN tblPhtm.dealid is not null THEN NULL ELSE tblWF.WF_CurrentStatus END) as WF_CurrentStatus
	,tblWF.WF_CurrentStatusDisplayName as WF_CurrentStatusDisplayName
	,(SELECT CASE WHEN (SELECT MAX(OrderIndex) FROm [CRE].[WFStatusPurposeMapping] WHERE PurposetypeId = fs.[PurposeID] ) = tblWF.OrderIndex then 1 ELSE 0 END) as WF_IsCompleted
	,(SELECT ISNULL((SELECT TOP 1 1 FROM [CRE].[WFStatusPurposeMapping] WHERE PurposetypeId = fs.[PurposeID] AND IsEnable = 1),0)) as WF_IsAllow	
	--,ISNULL(([dbo].[Fn_GetGetWorkflowAccessPermissionByTaskAndUserID]('''+convert(varchar(MAX),@TaskTypeID)+''',fs.DealFundingID,'''+convert(varchar(MAX),@UserID)+''',''all'',null,null,null,null,null)),1) as wf_isUserCurrentFlow
	,0 as wf_isUserCurrentFlow 

	,iSNULL(tblWF.WF_isParticipate,0) as WF_isParticipate   
	,(SELECT CASE WHEN (SELECT MIN(OrderIndex) FROm [CRE].[WFStatusPurposeMapping] WHERE PurposetypeId = fs.[PurposeID] ) <> tblWF.OrderIndex then 1 ELSE 0 END) as WF_IsFlowStart
    ,i.DrawFeeStatus      
	,LDrawFeeStatusID.Name as DrawFeeStatusName      
	,i.FileName as DrawFeeFile  
   ,IsShowDrawStatus= case when i.DrawFeeStatus is not null and ((fs.Applied=1 and i.DrawFeeStatus=692) or (fs.Applied=0 and i.DrawFeeStatus<>692) or (fs.Applied=1 and i.DrawFeeStatus<>692)) then 1 else 0 end      
   ,(CASE WHEN fs.GeneratedBy = 822 THEN  tblGeneratedBy_Name.Login ELSE lGeneratedBy.name END) as GeneratedByText
   ,tblGeneratedBy_Name.GeneratedByUserID
   from [CRE].[DealFunding] fs      
   left join cre.deal d on d.DealID = fs.DealID      
   Left Join Core.Lookup l1 on fs.PurposeID=l1.LookupID 
   Left Join Core.Lookup lGeneratedBy on fs.GeneratedBy=lGeneratedBy.LookupID
   left join (
		select ObjectID,InvoiceTypeID,ObjectTypeID,DrawFeeStatus,[FileName] from cre.InvoiceDetail	where InvoiceTypeID=558 and ObjectTypeID=698 and ObjectID in (Select dealfundingid from cre.dealfunding where dealid = '''+convert(varchar(MAX),@DealID)+''')
    ) i on i.ObjectID=fs.DealFundingID and i.InvoiceTypeID=558 and i.ObjectTypeID=698  
   and exists(select 1 from cre.wfchecklistdetail where taskid = i.ObjectID and wfchecklistmasterID=9 and CheckListStatus=499)      
   left JOIN [CORE].[Lookup] LDrawFeeStatusID ON LDrawFeeStatusID.LookupID = i.DrawFeeStatus
   Left Join(
	Select df.DealFundingID, u.[Login],NULLIF(df.GeneratedByUserID,'''') as GeneratedByUserID
	from [CRE].[DealFunding] df
	left join app.[user] u on u.userid = NULLIF(df.GeneratedByUserID,'''')
	Where df.DealID = '''+convert(varchar(MAX),@DealID)+'''
	and df.GeneratedBy = 822
  )tblGeneratedBy_Name on tblGeneratedBy_Name.DealFundingID = fs.DealFundingID      
   
   'SET @query3 = N'LEFT JOIN(
	select DealID from cre.deal where [status]=325 and isnull(linkeddealid,'''') ='''' and DealID = '''+convert(varchar(MAX),@DealID)+'''
  )tblPhtm on tblPhtm.dealid = d.dealid
  Left Join(
		Select TaskId,StatusName as WF_CurrentStatus,WF_CurrentStatusDisplayName,WF_isParticipate,OrderIndex
		From(
			SELECT td.TaskId
			,sm.StatusName
			,td.WFTaskDetailID	
			,(Case WHEN tblNoti.taskid is not null and sm.StatusName=''Completed'' then ''Completed''
                when tblChkd.CheckListStatus=881 and td.TaskTypeID=502 and sm.StatusName=''Completed'' then ''Completed''
				when (lPurposeType.Value1=''WF_UNDERREVIEW'' or df.[Amount] = 0) then sm.WFUnderReviewDisplayName 
				else sm.DealFundingDisplayName end) as WF_CurrentStatusDisplayName
			,ROW_NUMBER() OVER(Partition by td.TaskId order by td.TaskId,td.WFTaskDetailID desc) rno
			,COUNT( td.WFTaskDetailID ) OVER(Partition by td.TaskId) WF_isParticipate
			,spm.OrderIndex

			FROM [CRE].[WFTaskDetail] td       
			INNER JOIN [CRE].[WFStatusPurposeMapping] spm ON spm.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID      
			INNER JOIN [CRE].[WFStatusMaster] sm ON sm.WFStatusMasterID = spm.WFStatusMasterID    
			left JOin(
				select TaskID from cre.WFNotification where WFNotificationMasterID=2 and ActionType=577
			)tblNoti on tblNoti.taskid = td.taskid	
			LEFT JOIN cre.dealfunding df on df.dealfundingid = td.taskid
			LEFT JOIN core.Lookup lPurposeType on lPurposeType.LookupID = df.PurposeID and lPurposeType.ParentID = 50
            LEFT JOIN (
                select CheckListStatus,TaskId from cre.WFCheckListDetail
                where WFCheckListMasterID=21
            ) tblChkd on tblChkd.taskid = td.taskid	
			WHERE td.TaskId in (Select dealfundingid from cre.dealfunding where dealid = '''+convert(varchar(MAX),@DealID)+''')	
		)a
		where rno = 1
   )tblWF on tblWF.TaskId = fs.dealfundingid   

   where fs.DealID = '''+convert(varchar(MAX),@DealID)+''' and d.IsDeleted = 0   and fs.PurposeID <> 840   
   --order by fs.[Date]      
   ) a      
   '      
      
       
   set @query = 'left join( SELECT DealID, Date,PurposeID as PurposeID,DealFundingRowno as DealFundingRowno,' + @ColPivot + '       
    from (      
    Select  ROW_NUMBER() OVER (PARTITION BY  fs.[Date],fs.[PurposeID],df.DealFundingRowno,acc.Name  ORDER BY fs.[Date]) AS SNO      
   ,df.DealID DealID      
   ,acc.Name Name      
   ,fs.[Date] Date      
   ,fs.PurposeID      
   ,fs.Value Value      
   ,ISNULL(fs.DealFundingRowno,ISNULL(df.DealFundingRowno,0)) as DealFundingRowno      
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
   df.DealID ='''+convert(varchar(MAX),@DealID)+''' and d.IsDeleted = 0   and fs.PurposeID <> 840
   ) x       
   pivot       
   (      
    sum(Value)      
    for       
    Name in (' + @ColPivot + ')      
   ) p '      
      
   set @query=@query + ') b on a.DealID=b.DealID and a.Date=b.Date and ISNULL(a.PurposeID,1)=ISNULL(b.PurposeID,1) and a.DealFundingRowno=b.DealFundingRowno '      
         
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
      
   set @query1=' Select        
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
   null as AdjustmentType,     
   null as DrawFundingId ,        
   null as orgDate ,        
   null as orgValue ,        
   null as OrgApplied ,        
   null as orgPurposeID ,        
   null as OrgPurposeText ,        
   null as Issaved ,      
   null as WF_CurrentStatus ,        
   null as WF_CurrentStatusDisplayName,        
   null as WF_IsCompleted ,        
   null as WF_IsAllow ,        
   null as wf_isUserCurrentFlow ,        
   null as WF_isParticipate ,        
   null as WF_IsFlowStart ,        
   null as DealID ,    
  null as DealFundingRowno,    
  null as RequiredEquity,    
 null as AdditionalEquity,   
  null as DrawFeeStatus,  
   null as DrawFeeStatusName,  
    null as DrawFeeFile,  
 null as IsShowDrawStatus,
 null as GeneratedByText,
 null as GeneratedByUserID, '      
   + @ColPivot + ' '      
      
   set @query = ' '      
   SET @OrderBy  = ' '       
      
  END      
      
 END      
      
--Declare @OrderBy nvarchar(256) = ' order by a.Date,ISNULL(a.DealFundingRowno,0)'       
      
      
print @query1 
print @query2
print @query3
print @query      
print @OrderBy      
      
      
exec(@query1+@query2+@query3+@query + @OrderBy);      
      
      
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED      
END  
GO