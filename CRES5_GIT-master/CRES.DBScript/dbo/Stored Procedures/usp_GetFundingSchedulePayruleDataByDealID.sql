  
  
  
--[dbo].[usp_GetFundingSchedulePayruleDataByDealID] 'c7a300a5-33ff-42c9-9806-7d94d58f8010'  
CREATE PROCEDURE [dbo].[usp_GetFundingSchedulePayruleDataByDealID]   
(  
    @DealID UNIQUEIDENTIFIER  
   
)  
   
AS  
BEGIN  
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
Declare  @FundingSchedule  int  =10;  
DECLARE @Active int = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)  
Declare @InActive as nvarchar(256)=(select LookupID from core.lookup where name ='InActive' and ParentID=1);  
  
  
CREATE TABLE #tmpFunding  
(  
  Noteid uniqueidentifier,  
  Name VARCHAR(5000),  
  [Date] date,  
  Value [decimal](28, 15) NULL,  
  PurposeID [int] NULL,  
  PurposeText VARCHAR(5000),  
  Applied [bit] NULL,  
  NonCommitmentAdj [bit] NULL,  
  Comments [nvarchar](max) NULL,  
  Drawfundingid [nvarchar](256) NULL,  
  EventID uniqueidentifier,  
  DealFundingRowno INT,  
  DealFundingID uniqueidentifier  ,

  GeneratedBy int null,
  GeneratedByText [nvarchar](256) NULL,  
  WF_CurrentStatus [nvarchar](256) NULL,
  AdjustmentType int NULL
  
)  


  
INSERT INTO #tmpFunding(Noteid, Name, [Date],Value ,PurposeID ,PurposeText, Applied,NonCommitmentAdj, Comments, Drawfundingid, EventID, DealFundingRowno, DealFundingID,GeneratedBy,GeneratedByText,WF_CurrentStatus,AdjustmentType)  
Select   
a.Noteid as Noteid,  
a.notename as Name,  
a.[date],  
--ISNULL(b.value, 0) as Value,  
b.value as Value,  
a.orgPurposeID,  
a.OrgPurposeText,  
a.Applied,  
a.NonCommitmentAdj,  
a.Comment,  
a.Drawfundingid,  
ISNULL(b.EventID,'00000000-0000-0000-0000-000000000000') as EventID,  
b.DealFundingRowno,  
a.DealFundingID , 

a.GeneratedBy,
a.GeneratedByText,
a.WF_CurrentStatus,  
a.AdjustmentType
from(  
 Select  
 n.noteid  
 ,acc.name as notename  
 ,fs.DealFundingID DealFundingID   
 ,fs.[DealID] DealID  
 ,fs.[Date] Date  
 ,fs.[Amount] Value  
 ,fs.[Comment] Comment  
 ,fs.[PurposeID] PurposeID  
 ,fs.UpdatedDate UpdatedDate  
 ,l1.name PurposeText  
 ,ISNULL(fs.Applied,0) Applied  
 ,ISNULL(fs.NonCommitmentAdj,0) NonCommitmentAdj  
 ,DrawFundingId  
 ,fs.[Date] as orgDate  
 ,fs.[Amount] as orgValue  
 ,ISNULL(fs.Applied,0) as OrgApplied  
 ,fs.[PurposeID] as orgPurposeID  
 ,l1.name  as OrgPurposeText  
 ,fs.Issaved as Issaved  
 ,ISNULL(fs.DealFundingRowno,0) as DealFundingRowno  
 ,fs.GeneratedBy as GeneratedBy
 ,lGeneratedBy.Name as GeneratedByText
 ,(CASE WHEN tblPhtm.dealid is not null THEN NULL ELSE tblWF.WF_CurrentStatus END) as WF_CurrentStatus
  ,fs.AdjustmentType
	from [CRE].[DealFunding] fs  
	inner join cre.deal d on d.DealID = fs.DealID  
	inner join cre.note n on n.dealid = d.dealid  
	inner join core.account acc on acc.accountid = n.account_accountid  
	Left Join Core.Lookup l1 on fs.PurposeID=l1.LookupID  
	Left Join Core.Lookup lGeneratedBy on fs.GeneratedBy=lGeneratedBy.LookupID  
	LEFT JOIN(  
		select DealID from cre.deal where [status]=325 and isnull(linkeddealid,'') ='' and DealID = @DealID  
	)tblPhtm on tblPhtm.dealid = d.dealid  
	Left Join(  
		Select TaskId,StatusName as WF_CurrentStatus,WF_CurrentStatusDisplayName,WF_isParticipate,OrderIndex  
		From(  
			SELECT td.TaskId  
			,sm.StatusName  
			,td.WFTaskDetailID   
			,(Case WHEN tblNoti.taskid is not null and sm.StatusName='Completed' then 'Completed'   
			when (lPurposeType.Value1='WF_UNDERREVIEW' or df.[Amount] = 0) then sm.WFUnderReviewDisplayName   
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
			WHERE td.TaskId in (Select dealfundingid from cre.dealfunding where dealid = @DealID)   
		)a  
		where rno = 1  
	)tblWF on tblWF.TaskId = fs.dealfundingid  
	 where fs.DealID = @DealID and d.IsDeleted = 0  
	 and acc.IsDeleted = 0  
	--order by fs.[Date]  
) a  
Left JOin(       
 Select  ROW_NUMBER() OVER (PARTITION BY  fs.[Date],fs.[PurposeID],df.DealFundingRowno,acc.Name  ORDER BY fs.[Date]) AS SNO  
 ,df.DealID DealID  
 ,n.NoteId  
 ,acc.Name Name  
 ,df.[Date] Date  
 ,fs.PurposeID  
 ,fs.Value Value  
 ,fs.Applied  
-- ,fs.NonCommitmentAdj 
 ,df.AdjustmentType 
 ,fs.EventID  
 ,ISNULL(fs.DealFundingRowno,ISNULL(df.DealFundingRowno,0)) as DealFundingRowno  
 ,df.PurposeID as b_PurposeID  
 from   
 [CRE].[DealFunding] df  
 left join cre.deal d on d.DealID = df.DealID and d.DEalID= @DealID  
 left join [CORE].FundingSchedule fs on df.[Date]=fs.[Date]  and df.purposeid=fs.purposeid and ISNULL(df.DealFundingRowno,0)=ISNULL(fs.DealFundingRowno,ISNULL(df.DealFundingRowno,0))  
 INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId  
 INNER JOIN   
    (  
        
     Select   
      (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
      MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID  
      from [CORE].[Event] eve  
      INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
      INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
      where EventTypeID = '10'   
      and n.DealID = @DealID  
      and eve.StatusID ='1'    
      and acc.IsDeleted = 0  
      GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID  
  
    ) sEvent  
  
 ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
 INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
 left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID  
 INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
 where sEvent.StatusID = e.StatusID --and n.UseRuletoDetermineNoteFunding=(Select LookupID from Core.Lookup where name = 'Y' and parentId=2)  
 --and isnull(acc.StatusID, '1')!= '2'   
 and acc.IsDeleted = 0 and   
 df.DealID = @DealID and d.IsDeleted = 0  
   
  
)b on a.noteid=b.noteid and a.DealID=b.DealID and a.Date=b.Date and a.PurposeID=b.b_PurposeID and a.DealFundingRowno=b.DealFundingRowno   
order by a.[Date], ISNULL(a.DealFundingRowno,0) --ISNULL(n.lienposition,99999), n.Priority,n.InitialFundingAmount desc, acc.Name ,fs.[Date]  
     
    
  
SELECT Noteid, Name, [Date],Value ,PurposeID ,PurposeText, Applied,NonCommitmentAdj, Comments, EventID, Drawfundingid, DealFundingRowno, DealFundingID ,GeneratedBy,GeneratedByText,WF_CurrentStatus,AdjustmentType
FROm #tmpFunding  
order by Noteid, [Date], ISNULL(DealFundingRowno,0);   
  
DROP TABLE #tmpFunding  
  
  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  