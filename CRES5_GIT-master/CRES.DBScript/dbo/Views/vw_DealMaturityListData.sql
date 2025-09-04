

CREATE VIEW dbo.vw_DealMaturityListData
AS

Select
d.DealName	
,d.CREDealID	
,n.CreNoteID	
,acc.name as NoteName	
,mat.EffectiveStartDate	
,mat.ExpectedMaturityDate	
,mat.MaturityDate	
,mat.ApprovedText as Approved	
,mat.IsAutoApproved	
,mat.MaturityTypeText as MaturityName	
,mat.ExtensionTypeText as ExtensionType	
,mat.ActualPayoffDate	
,mat.OpenPrepaymentDate


from cre.note n
Inner JOin core.account acc on acc.accountid = n.account_accountid
Inner JOin cre.deal d on d.dealid = n.dealid 
Left Join(
	Select 
	[MaturityID] as ScheduleID      
	,nt.NoteID    
	,e.EffectiveStartDate 
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
	,mat.IsAutoApproved
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
		--and n.dealid = @DealId       
		GROUP BY n.Account_AccountID,EventTypeID     
	) sEvent      
	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID and e.StatusID = 1 
	INNER JOIN [CRE].[Note] nt   on nt.Account_AccountID = sEvent.AccountID      
	left JOIN [CORE].[Lookup] LApproved ON LApproved.LookupID = mat.Approved    
	left JOIN [CORE].[Lookup] LMaturityType ON LMaturityType.LookupID = mat.MaturityType  
	left JOIN [CORE].[Lookup] LExtensionType ON LExtensionType.LookupID = mat.ExtensionType    
)mat on mat.Noteid = n.noteid

where acc.isdeleted <> 1
--and d.dealid = @DealId


---Order by  DealName,crenoteid, EffectiveStartDate desc , MaturityDate asc