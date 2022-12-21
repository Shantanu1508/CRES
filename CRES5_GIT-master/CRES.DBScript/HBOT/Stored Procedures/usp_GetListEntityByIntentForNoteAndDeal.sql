-- Procedure  
-- Procedure  
  
-- [HBOT].[usp_GetListEntityByIntentForNoteAndDeal] 'ID','2230','name','seventy rainey','NoteSpreadValue'  
-- [HBOT].[usp_GetListEntityByIntentForNoteAndDeal] 'name','A-1F Note','name','seventy rainey','UnFundedNote'  
  
CREATE PROCEDURE [HBOT].[usp_GetListEntityByIntentForNoteAndDeal]    
 @NoteNature  nvarchar(256),  
 @NoteValue  nvarchar(256),  
 @DealNature  nvarchar(256),  
 @DealValue  nvarchar(256),  
 @Intent  nvarchar(256)    
  
  
  
AS    
BEGIN    
    SET NOCOUNT ON;    
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
 ---------To set starttime for log------  
 --DECLARE @StartTime datetime;  
 --SET @StartTime = getdate();  
 --------------------------------------  
  
 IF(@Intent = 'NoteSpreadValue')  
 BEGIN  
  Select top 1 n1.CRENoteID as Note,  
     d1.CREDealID as Deal,  
     rs.value as Spread  
  from [CORE].RateSpreadSchedule rs  
  INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId  
  inner join core.account acc1 on acc1.accountid = e.accountid  
  inner join cre.note n1 on n1.account_accountid = acc1.accountid  
  inner join cre.deal d1 on d1.dealid = n1.dealid  
  LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID  
  INNER JOIN  
     (    
      Select  
       (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
       MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
       INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
       INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
       inner join cre.deal d on d.dealid = n.dealid  
       where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'RateSpreadSchedule')  
       and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)       
       and acc.IsDeleted = 0  
       and acc.name = @NoteValue --IIF(@NoteNature = 'name',acc.name,n.crenoteid) =  @NoteValue  
       GROUP BY n.Account_AccountID,EventTypeID  
  
     ) sEvent  
  
  ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
  where e.StatusID = 1 and LValueTypeID.name = 'Spread'  
  and  d1.dealname = @DealValue --IIF(@DealNature = 'name',d1.dealname,d1.credealid) =  @DealValue  
  and rs.Date <= getdate()  
  order by rs.Date desc   
 END  
  
 IF(@Intent = 'UnFundedNote')  
 BEGIN  
  Select  acc.Name as Note,d.CREDealID as Deal ,SUM( fs.value)  as [TotalUnfundedBalance]    
  ,Convert(varchar,MIN(fs.date),101) as [LastPaydownDate]  
  from [CORE].FundingSchedule fs  
  INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId  
  INNER JOIN(        
   Select   
   (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
   MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID  
   from [CORE].[Event] eve  
   INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
   INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
   where EventTypeID = 10       
   and acc.IsDeleted = 0  
   and eve.StatusID = 1  
   and acc.name = @NoteValue --IIF(@NoteNature = 'name',acc.name,n.crenoteid) =  @NoteValue  
   GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID  
  ) sEvent  
  ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
  INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
  INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
  inner join cre.deal d on d.dealid = n.dealid  
  where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0 and fs.applied <> 1  
  and d.dealname  = @DealValue --IIF(@DealNature = 'name',d.dealname,d.credealid) =  @DealValue  
  and fs.Value>0  
  group by acc.Name,d.CREDealID  
    
 END  
   
--INSERT INTO [HBOT].[APIAnalysisLog](StartTime,EndTime,IntentName) VALUES(@StartTime,getdate(),@Intent)  
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END
