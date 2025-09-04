CREATE VIEW [dbo].[vw_DealNotes]    
AS  
SELECT n.NoteID  as NoteKey
   ,CRENoteID as NoteID 
   ,d.DealID  DealKey
   ,d.CREDealID as DealID
   ,(select [Value]+'#/dealdetail/'+d.CREDealID from app.appconfig where [key]='M61BaseUrl')  as DealUrl  
     ,(select [Value]+'#/notedetail/'+cast(n.NoteID as nvarchar(256)) from app.appconfig where [key]='M61BaseUrl')  as NoteUrl    
 FROM CRE.Note n inner join Core.Account a on Account_AccountID=a.AccountID  
  
 inner join cre.Deal d on n.DealId = d.DealId  
 where isnull(d.IsDeleted,0)=0  
 and isnull(d.IsDeleted,0)=0
 