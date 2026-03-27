
CREATE VIEW dbo.vw_Maturity
AS
Select  n.crenoteid,n.NoteID, lmattype.name as MaturityType,mat.MaturityDate, mat.Approved
from [CORE].Maturity mat  
INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
left join core.lookup lmattype on lmattype.lookupid = mat.maturityType
INNER JOIN  
(          
Select  
(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
where EventTypeID = 11  and eve.StatusID = 1 and acc.IsDeleted = 0  
GROUP BY n.Account_AccountID,EventTypeID    
) sEvent    
ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.StatusID = 1
INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
where mat.maturityType = 710
and mat.Approved = 3
