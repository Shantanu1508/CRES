
CREATE PROCEDURE [dbo].[usp_GetFundingDrawByBusinessday] --15
   @NextBDNumber INT
AS
BEGIN
      SET NOCOUNT ON;


Declare @tblDateRange as table(Date date) 
  
Delete from @tblDateRange  
  
;WITH CTE AS  
(    
	SELECT DateAdd(day,-15,getdate()) Date  
	UNION ALL
	SELECT DateAdd(day,1,Date)  FROM CTE WHERE DateAdd(day,1,Date) <= DateAdd(day,30,getdate())  
)  
INsert  into @tblDateRange(Date)  
SELECT Distinct dbo.Fn_GetnextWorkingDays(Date,-1,'PMT Date') FROM CTE  


DECLARE @NextBDDate DATE

SET @NextBDDate = (Select Date as enddate from @tblDateRange  where date >= CAST(getdate() as date) order by date OFFSET ((@NextBDNumber-5) - 1) ROWS FETCH NEXT 1 ROWS ONLY)
---=================================

Select * from(
Select 
d.dealid
,d.DealName
,d.CREDealID
,df.Date 
,df.Amount
,lpurpose.name as Purpose
--,LTRIM(RTRIM(uAmLead.lastname))+', '+LTRIM(RTRIM(uAmLead.Firstname)) as AMTeamLeadUser
--,LTRIM(RTRIM(uAmSec.lastname))+', '+LTRIM(RTRIM(uAmSec.Firstname)) as AMSecondUser
,LTRIM(RTRIM(uAm.Firstname))+' '+LTRIM(RTRIM(uAm.lastname)) as AMUser


from cre.dealfunding df
inner join cre.deal d on d.dealid = df.dealid
Left Join core.lookup lpurpose on lpurpose.lookupid = df.purposeid

left join app.[User] uAmLead on uAmLead.UserID = d.AMTeamLeadUserID
left join app.[User] uAmSec on uAmSec.UserID = d.AMSecondUserID
left join app.[User] uAm on uAm.UserID = d.AMUserID

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
		WHERE td.TaskId in (Select dealfundingid from cre.dealfunding where applied = 0 and amount > 0 and comment is null)	
	)a
	where rno = 1
)tblWF on tblWF.TaskId = df.dealfundingid



where d.isdeleted <> 1
and df.applied = 0
and comment is null
and df.amount > 0
and df.[date] <= @NextBDDate
and ISNULL(tblWF.WF_CurrentStatus,'Projected') = 'Projected'

and d.[status] = 323
and lpurpose.name  <> 'Capitalized Interest'
and d.dealid in (
	Select distinct d.dealid from cre.Deal d
	inner join cre.note n on n.dealid = d.dealid
	inner join core.account acc on acc.accountid = n.account_accountID
	where acc.isdeleted <> 1 and n.actualpayoffdate is null
)

)a
order by a.AMUser




END



