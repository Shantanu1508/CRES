  
CREATE VIEW [dbo].[NoteFundingSchedule] AS    
Select    
N.[CRENoteID]    
,[Date]    
,[Amount]    
,[PurposeBI] as [Purpose]    
,[WireConfirm]    
,ISNULL(N.[Comments],'None')Comments    
,CASE WHEN  N.COmments IS NULL OR N.COmments = '' THEN 'None' Else N.COmments END as CommentsBI    
,[DrawFundingID]    
,N.[CreatedBy]    
,N.[CreatedDate]    
,N.[UpdatedBy]    
,N.[UpdatedDate]    
, UpdatedByBI =  FirstName +' ' + LastName    
, D.DealID    
,DealName    
,[Projected]    
,GeneratedByBI as GeneratedBy 

,AdjustmentTypeBI as AdjustmentType 
,WF_CurrentStatusDisplayName as WorkFlowStatus
,(select [Value]+'#/dealdetail/'+d.DealID from app.appconfig where [key]='M61BaseUrl')  as DealUrl
from [DW].[NoteFundingscheduleBI] N    
Left Join [App].[User] U  On U.UserID = N.[UpdatedBy]    
Left Join Dw.NoteBI nn on N.CRENoteID = nn.CRENoteID    
inner join dbo.deal d on nn.DealID = d.dealkey    
    
    
    
    