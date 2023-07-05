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
								from (SELECT ReserveAccountName from [CRE].[ReserveAccount] where DealID=@DealID) x
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
		ra.ReserveAccountName as Name,
		0 as isDeleted,
		(Select Top 1 Count(wl.WFTaskDetailID)  from [CRE].WFTaskDetail wl where wl.TaskID=rs.DealReservescheduleGUID) as WF_isParticipate ,
		''true'' as IsValidateHoliday,
		(SELECT TOP 1 sm.StatusName FROM [CRE].[WFTaskDetail] td       
		 INNER JOIN [CRE].[WFStatusPurposeMapping] spm ON spm.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID      
		 INNER JOIN [CRE].[WFStatusMaster] sm ON sm.WFStatusMasterID = spm.WFStatusMasterID      
		 WHERE TaskId = rs.DealReserveScheduleGUID       
		 ORDER BY WFTaskDetailID DESC ) as WF_CurrentStatus ,
		  (SELECT TOP 1 DealFundingDisplayName = (Case WHEN (select count(1) from cre.WFNotification where TaskID=rs.DealReserveScheduleGUID and WFNotificationMasterID=5 and ActionType=577)>0 and sm.StatusName=''Completed''  then ''Completed'' when (lPurposeType.Value1=''WF_UNDERREVIEW'' or rs.[Amount] = 0) then sm.WFUnderReviewDisplayName  else sm.DealFundingDisplayName end) FROM [CRE].[WFTaskDetail] td       
		  INNER JOIN [CRE].[WFStatusPurposeMapping] spm ON spm.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID      
		  INNER JOIN [CRE].[WFStatusMaster] sm ON sm.WFStatusMasterID = spm.WFStatusMasterID      
		  LEFT JOIN core.Lookup lPurposeType on lPurposeType.LookupID = rs.PurposeID and lPurposeType.ParentID = 119      
		  WHERE TaskId = rs.DealReserveScheduleGUID         
		  ORDER BY WFTaskDetailID DESC ) as WF_CurrentStatusDisplayName
		  ,ISNULL      
			  ( (      
			  SELECT TOP 1 1 FROM [CRE].[WFTaskDetail] td       
			  INNER JOIN [CRE].[WFStatusPurposeMapping] spm ON spm.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID      
			  INNER JOIN [CRE].[WFStatusMaster] sm ON sm.WFStatusMasterID = spm.WFStatusMasterID      
			  WHERE TaskId = rs.DealReserveScheduleGUID   and spm.OrderIndex = (      
			   SELECT MAX(OrderIndex) FROm [CRE].[WFStatusPurposeMapping] WHERE PurposetypeId = spm.PurposeTypeId       
			  ) ORDER BY WFTaskDetailID DESC )      
			  ,0 ) AS WF_IsCompleted
		  ,(SELECT CASE WHEN (SELECT MIN(OrderIndex) FROm [CRE].[WFStatusPurposeMapping] WHERE PurposetypeId = rs.[PurposeID] ) !=      
		   (SELECT TOP 1 spm.OrderIndex  FROM [CRE].[WFTaskDetail] td       
		  INNER JOIN [CRE].[WFStatusPurposeMapping] spm ON spm.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID      
		  INNER JOIN [CRE].[WFStatusMaster] sm ON sm.WFStatusMasterID = spm.WFStatusMasterID      
		 WHERE TaskId = rs.DealReserveScheduleGUID      
		  ORDER BY WFTaskDetailID DESC      
		  )      
		  THEN 1 ELSE 0 END      
		  ) AS WF_IsFlowStart
	from [CRE].[DealReserveSchedule] rs
	left join [CRE].[ReserveAccountSchedule] ras on rs.DealReserveScheduleID=ras.DealReserveScheduleID and rs.PurposeID=ras.PurposeID
	left join [CRE].[ReserveAccount]  ra on ra.ReserveAccountID=ras.ReserveAccountID
	left join core.lookup lpurpose on rs.PurposeID=lpurpose.lookupid
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
	 
