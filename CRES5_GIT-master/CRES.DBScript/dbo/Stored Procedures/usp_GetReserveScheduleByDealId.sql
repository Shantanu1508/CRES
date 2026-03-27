 --[dbo].[usp_GetReserveScheduleByDealId]  'C7A300A5-33FF-42C9-9806-7D94D58F8010','7042C856-8C8A-4299-91C9-40CF1049D3F0'

 CREATE PROCEDURE [dbo].[usp_GetReserveScheduleByDealId] 
(  
	@UserID varchar(100), 
	@DealID varchar(100)
)  
AS
 BEGIN

 Declare  @ColPivot nvarchar(max),
    @query  AS NVARCHAR(MAX),
	 @OrderBy nvarchar(256);   

 SET @ColPivot = STUFF((SELECT  ',' +  QUOTENAME(x.ReserveAccountName)               
								from (SELECT rm.ReserveAccountName from [CRE].[ReserveAccount] r left join cre.ReserveAccountMaster rm on r.ReserveAccountMasterID=rm.ReserveAccountMasterID where DealID=@DealID) x
								FOR XML PATH(''), TYPE
								).value('.', 'NVARCHAR(MAX)') 
								,1,1,'')
								

	set @query='
	select * from

	(SELECT 
		rs.[DealReserveScheduleGUID],
		rs.[DealReserveScheduleID] ,
		rs.[DealID],
		rs.[Date],
		ras.[Amount],
		rs.Amount as ReserveAmount,
		rs.[PurposeID],
		lpurpose.Name as PurposeTypeText ,
		rs.[Comment],
		isnull(rs.[Applied],0) Applied,
		rm.ReserveAccountName as Name,
		0 as isDeleted
		--(Select Top 1 Count(wl.WFTaskDetailID)  from [CRE].WFTaskDetail wl where wl.TaskID=rs.DealReservescheduleGUID) as WF_isParticipate ,
		,iSNULL(tblWF.WF_isParticipate,0) as WF_isParticipate,
		1 as IsValidateHoliday
		,tblWF.WF_CurrentStatus
		,tblWF.WF_CurrentStatusDisplayName as WF_CurrentStatusDisplayName
		,ISNULL((SELECT CASE WHEN (SELECT MAX(OrderIndex) FROm [CRE].[WFStatusPurposeMapping] WHERE PurposetypeId =rs.PurposeID ) = tblWF.OrderIndex then 1 ELSE 0 END),0) as WF_IsCompleted
		,(SELECT CASE WHEN (SELECT MIN(OrderIndex) FROm [CRE].[WFStatusPurposeMapping] WHERE PurposetypeId = rs.[PurposeID] ) <> tblWF.OrderIndex then 1 ELSE 0 END) as WF_IsFlowStart

		from [CRE].[DealReserveSchedule] rs
		left join [CRE].[ReserveAccountSchedule] ras on rs.DealReserveScheduleID=ras.DealReserveScheduleID and rs.PurposeID=ras.PurposeID
		left join [CRE].[ReserveAccount]  ra on ra.ReserveAccountID=ras.ReserveAccountID
		left join [CRE].[ReserveAccountMaster]  rm on rm.ReserveAccountMasterID=ra.ReserveAccountMasterID
		left join core.lookup lpurpose on rs.PurposeID=lpurpose.lookupid

	Left Join(
	Select TaskId,StatusName as WF_CurrentStatus,WF_CurrentStatusDisplayName,WF_isParticipate,OrderIndex
	From(
		SELECT td.TaskId
		,sm.StatusName
		,td.WFTaskDetailID	
		,(Case WHEN tblNoti.taskid is not null and sm.StatusName=''Completed'' then ''Completed''
			when td.TaskTypeID=719 and sm.StatusName=''Completed'' then ''Completed''
			when (lPurposeType.Value1=''WF_UNDERREVIEW'' or df.[Amount] = 0) then sm.WFUnderReviewDisplayName 
			else sm.DealFundingDisplayName end) as WF_CurrentStatusDisplayName
		,ROW_NUMBER() OVER(Partition by td.TaskId order by td.TaskId,td.WFTaskDetailID desc) rno
		,COUNT( td.WFTaskDetailID ) OVER(Partition by td.TaskId) WF_isParticipate
		,spm.OrderIndex

		FROM [CRE].[WFTaskDetail] td       
		INNER JOIN [CRE].[WFStatusPurposeMapping] spm ON spm.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID      
		INNER JOIN [CRE].[WFStatusMaster] sm ON sm.WFStatusMasterID = spm.WFStatusMasterID    
		left JOin(
			select TaskID from cre.WFNotification where WFNotificationMasterID=5 and ActionType=577
		)tblNoti on tblNoti.taskid = td.taskid	
		LEFT JOIN cre.dealfunding df on df.dealfundingid = td.taskid
		LEFT JOIN core.Lookup lPurposeType on lPurposeType.LookupID = df.PurposeID and lPurposeType.ParentID = 119
		WHERE td.TaskId in (select DealReserveScheduleGUID from cre.[DealReserveSchedule] where dealid='''+convert(varchar(MAX),@DealID)+''')	
	)a
where rno = 1
) tblWF on tblWF.TaskId = rs.DealReserveScheduleGUID
where   rs.DealID ='''+convert(varchar(MAX),@DealID)+'''
	)a
	  pivot       
   (      
    sum(Amount)      
    for       
    Name in (' + @ColPivot + ')      
   ) p  order by p.Date,p.DealReserveScheduleID asc'
	
	

		PRINT @query
		EXEC (@query)


	END
	 
