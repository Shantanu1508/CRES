-- [dbo].[usp_GetMaturityByDealID] '','30C7FE10-175B-4A59-9441-01E089FD2354','C7A300A5-33FF-42C9-9806-7D94D58F8010'
  
CREATE PROCEDURE [dbo].[usp_GetMaturityByDealID]    
(      
	@DealID varchar(50),    
	@NoteID varchar(50),
	@UserID varchar(50)    
)      
AS    
BEGIN      
   
   
IF(@NoteID is not null)
BEGIN
	Select mat.ScheduleID      
	,n.NoteID    
	,mat.EffectiveDate     
	
	,n.ExpectedMaturityDate    
	,n.OpenPrepaymentDate    
	,n.ActualPayoffDate  
	
	,mat.MaturityDate    
	,mat.MaturityType    
	,mat.MaturityTypeText    
	,mat.Approved    
	,mat.ApprovedText    
	,0 as isDeleted
	,mat.IsSaved
	,mat.IsValidateMaturityDate
	,n.CRENoteID
	,mat.MaturityMethodID
	,mat.MaturityGroupName
	,mat.ExtensionType
	,mat.ExtensionTypeText
	from cre.note n
	Inner JOin core.account acc on acc.accountid = n.account_accountid
	Inner JOin cre.deal d on d.dealid = n.dealid 
	Left Join(
		Select 
		[MaturityID] as ScheduleID      
		,nt.NoteID    
		,e.EffectiveStartDate as EffectiveDate     
	
		,nt.ExpectedMaturityDate    
		,nt.OpenPrepaymentDate    
		,nt.ActualPayoffDate  
	
		,mat.MaturityDate    
		,mat.MaturityType    
		,LMaturityType.name as MaturityTypeText    
		,mat.Approved    
		,LApproved.name as ApprovedText    
		,0 as isDeleted
		,(CASE WHEN mat.MaturityType=708 OR mat.MaturityType =710 THEN'false'  WHEN mat.MaturityType is null then 'false' ELSE'true' END) as IsSaved
		,'true' as IsValidateMaturityDate
		,nt.CRENoteID
		,ISNULL(nt.MaturityMethodID,723) as MaturityMethodID
		,ISNULL(nt.MaturityGroupName,'Note level')  as MaturityGroupName
		,LMaturityType.SortOrder
		,mat.ExtensionType 
		,LExtensionType.name as ExtensionTypeText
		from [CORE].Maturity mat      
		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
		INNER JOIN     
		(       
			Select       
			(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,         
			MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve      
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID      
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID      
			where EventTypeID = 11
			and acc.IsDeleted = 0
			and n.NoteID = @NoteID
			and eve.StatusID = 1
			--and n.dealid = @DealId       
			GROUP BY n.Account_AccountID,EventTypeID     
		) sEvent      
		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID     and e.StatusID = 1 
		INNER JOIN [CRE].[Note] nt   on nt.Account_AccountID = sEvent.AccountID      
		left JOIN [CORE].[Lookup] LApproved ON LApproved.LookupID = mat.Approved    
		left JOIN [CORE].[Lookup] LMaturityType ON LMaturityType.LookupID = mat.MaturityType    
		left JOIN [CORE].[Lookup] LExtensionType ON LExtensionType.LookupID = mat.ExtensionType    
	

	)mat on mat.Noteid = n.noteid

	where acc.isdeleted <> 1
	and n.NoteID = @NoteID
	ORDER BY mat.EffectiveDate,mat.SortOrder,mat.MaturityDate





	--Select 
	--[MaturityID] as ScheduleID      
	--,nt.NoteID    
	--,e.EffectiveStartDate as EffectiveDate     
	
	--,nt.ExpectedMaturityDate    
	--,nt.OpenPrepaymentDate    
	--,nt.ActualPayoffDate  
	
	--,mat.MaturityDate    
	--,mat.MaturityType    
	--,LMaturityType.name as MaturityTypeText    
	--,mat.Approved    
	--,LApproved.name as ApprovedText    
	--,0 as isDeleted
	--,(CASE WHEN mat.MaturityType=708 OR mat.MaturityType =710 THEN'false' ELSE'true' END) as IsSaved
	--,'true' as IsValidateMaturityDate
	--,nt.CRENoteID
	--,ISNULL(nt.MaturityMethodID,723) as MaturityMethodID
	--,ISNULL(nt.MaturityGroupName,'Note level')  as MaturityGroupName
	--from [CORE].Maturity mat      
	--INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
	--INNER JOIN     
	--(       
	--	Select       
	--	(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,         
	--	MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve      
	--	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID      
	--	INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID      
	--	where EventTypeID = 11
	--	and acc.IsDeleted = 0
	--	and n.NoteID = @NoteID
	--	and eve.StatusID = 1
	--	--and n.dealid = @DealId       
	--	GROUP BY n.Account_AccountID,EventTypeID     
	--) sEvent      
	--ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID     and e.StatusID = 1 
	--INNER JOIN [CRE].[Note] nt   on nt.Account_AccountID = sEvent.AccountID      
	--left JOIN [CORE].[Lookup] LApproved ON LApproved.LookupID = mat.Approved    
	--left JOIN [CORE].[Lookup] LMaturityType ON LMaturityType.LookupID = mat.MaturityType    
	--ORDER BY e.EffectiveStartDate,LMaturityType.SortOrder,mat.MaturityDate
  
END 
ELSE
BEGIN

	Select ScheduleID as ScheduleID      
	,n.NoteID    
	,mat.EffectiveDate 
	,n.ExpectedMaturityDate 
	,n.OpenPrepaymentDate    
	,n.ActualPayoffDate 
	,mat.MaturityDate
	,mat.MaturityType    
	,mat.MaturityTypeText    
	,mat.Approved    
	,mat.ApprovedText    
	,0 as isDeleted
	,(CASE WHEN mat.MaturityType=708 OR mat.MaturityType =710 THEN'false'  WHEN mat.MaturityType is null then 'false' ELSE'true' END) as IsSaved
	,'true' as IsValidateMaturityDate
	,n.CRENoteID
	,n.MaturityMethodID
	,n.MaturityGroupName
	,mat.ExtensionType
	,mat.ExtensionTypeText
	
	from cre.note n
	Inner JOin core.account acc on acc.accountid = n.account_accountid
	Inner JOin cre.deal d on d.dealid = n.dealid 
	Left Join(
		Select 
		[MaturityID] as ScheduleID      
		,nt.NoteID    
		,e.EffectiveStartDate as EffectiveDate 
		,nt.ExpectedMaturityDate 
		,nt.OpenPrepaymentDate    
		,nt.ActualPayoffDate 
		,mat.MaturityDate
		,mat.MaturityType    
		,LMaturityType.name as MaturityTypeText    
		,mat.Approved    
		,LApproved.name as ApprovedText    
		,0 as isDeleted
		,(CASE WHEN mat.MaturityType=708 OR mat.MaturityType =710 THEN'false' ELSE'true' END) as IsSaved
		,'true' as IsValidateMaturityDate
		,nt.CRENoteID
		,nt.MaturityMethodID
		,nt.MaturityGroupName
		,LMaturityType.SortOrder
		,mat.ExtensionType 
		,LExtensionType.name as ExtensionTypeText
		from [CORE].Maturity mat      
		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
		INNER JOIN     
		(       
			Select       
			(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,         
			MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve      
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID      
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID      
			where EventTypeID = 11   and eve.StatusID = 1   
			and acc.IsDeleted = 0		
			and n.dealid = @DealId       
			GROUP BY n.Account_AccountID,EventTypeID     
		) sEvent      
		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID and e.StatusID = 1 
		INNER JOIN [CRE].[Note] nt   on nt.Account_AccountID = sEvent.AccountID      
		left JOIN [CORE].[Lookup] LApproved ON LApproved.LookupID = mat.Approved    
		left JOIN [CORE].[Lookup] LMaturityType ON LMaturityType.LookupID = mat.MaturityType  
		left JOIN [CORE].[Lookup] LExtensionType ON LExtensionType.LookupID = mat.ExtensionType    
	)mat on mat.Noteid = n.noteid

	where acc.isdeleted <> 1
	and d.dealid = @DealId

	ORDER BY mat.EffectiveDate,mat.SortOrder,mat.MaturityDate



	--Select 
	--[MaturityID] as ScheduleID      
	--,nt.NoteID    
	--,e.EffectiveStartDate as EffectiveDate     
	
	--,nt.ExpectedMaturityDate    
	----,tblExpectedMaturityDate.MinDate as ExpectedMaturityDate    
	--,nt.OpenPrepaymentDate    
	--,nt.ActualPayoffDate  

	----,(CASE WHEN mat.MaturityType = 712 THEN tblExpectedMaturityDate.MinDate else mat.MaturityDate end) as  MaturityDate  
	--,mat.MaturityDate
	--,mat.MaturityType    
	--,LMaturityType.name as MaturityTypeText    
	--,mat.Approved    
	--,LApproved.name as ApprovedText    
	--,0 as isDeleted
	--,(CASE WHEN mat.MaturityType=708 OR mat.MaturityType =710 THEN'false' ELSE'true' END) as IsSaved
	--,'true' as IsValidateMaturityDate
	--,nt.CRENoteID
	--,nt.MaturityMethodID
	--,nt.MaturityGroupName
	--from [CORE].Maturity mat      
	--INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
	--INNER JOIN     
	--(       
	--	Select       
	--	(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,         
	--	MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve      
	--	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID      
	--	INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID      
	--	where EventTypeID = 11   and eve.StatusID = 1   
	--	and acc.IsDeleted = 0		
	--	and n.dealid = @DealId       
	--	GROUP BY n.Account_AccountID,EventTypeID     
	--) sEvent      
	--ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID     and e.StatusID = 1 
	--INNER JOIN [CRE].[Note] nt   on nt.Account_AccountID = sEvent.AccountID      
	--left JOIN [CORE].[Lookup] LApproved ON LApproved.LookupID = mat.Approved    
	--left JOIN [CORE].[Lookup] LMaturityType ON LMaturityType.LookupID = mat.MaturityType  
	--ORDER BY e.EffectiveStartDate,LMaturityType.SortOrder,mat.MaturityDate
END


     
END  