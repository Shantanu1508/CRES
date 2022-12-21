-- Procedure  
  
  
CREATE PROCEDURE [dbo].[usp_GetEntityList]   
(  
 @UserID UNIQUEIDENTIFIER  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
  
Select  distinct  entity_names,entity_type,synonyms  
From(  
 Select 'DealName' as entity_type,DealName as entity_names,DealName as synonyms from cre.deal where IsDeleted<>1  
  
 UNION ALL  
 Select 'DealID' as entity_type,CREDealID as entity_names,CREDealID as synonyms from cre.deal where IsDeleted<>1  
  
 UNION All  
  
 Select 'NoteName' as entity_type,LTRIM(RTRIM(acc.name)) as entity_names,LTRIM(RTRIM(acc.name)) as synonyms   
 from cre.Note n inner join core.account acc on acc.accountid = n.account_accountid  where acc.IsDeleted<>1  
  
 UNION All  
  
 Select 'NoteID' as entity_type,n.CRENoteID as entity_names,n.CRENoteID as synonyms from cre.Note n   
   inner join core.account acc on acc.accountid = n.account_accountid where acc.IsDeleted<>1  
  
 UNION ALL  
 Select 'ClientName' as entity_type, ClientName as entity_names, ClientName as synonyms from CRE.Client where ClientName not in ('All','None')  
)a  
  
END

