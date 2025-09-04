-- Procedure  
  
  
-- [HBOT].[usp_GetSingleEntityByIntentForNoteAndDeal]  'name','Note A-2','name','First Street Napa','BalloonPayment'  
-- [HBOT].[usp_GetSingleEntityByIntentForNoteAndDeal]  'ID','2230','name','Seventy Rainey','NoteFullyFundedDate'  
  
CREATE PROCEDURE [HBOT].[usp_GetSingleEntityByIntentForNoteAndDeal]    
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
-- DECLARE @StartTime datetime;  
-- SET @StartTime = getdate();  
 --------------------------------------  
Declare @Analysisid uniqueidentifier = (SELECT AnalysisID from CORE.Analysis WHERE Name='Default');  
  
IF(@Intent = 'NoteFullyFundedDate')  
BEGIN  
 SELECT CONVERT(nvarchar,ISNULL(b.Date,n.ClosingDate),101) as SingleResult  
 FROM CRE.Note n  
 left join cre.deal d on d.dealid = n.dealid  
 inner join core.account acc on acc.AccountID = n.Account_AccountID  
 left join (  
  SELECT NoteId,Date,crenoteid  
  FROM  
  (  
  Select n.NoteID,  
  IIF(fs.Value<0,n.ClosingDate,fs.Date) as Date,  
  n.crenoteid,  
  ROW_NUMBER() OVER(PARTITION BY n.NoteID ORDER BY n.NoteID,fs.Date desc) as rownum  
  from [CORE].FundingSchedule fs  
  left JOIN [CORE].[Event] e on e.EventID = fs.EventId  
  left JOIN(  
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
  ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate and e.EventTypeID = sEvent.EventTypeID  
  left JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
  left JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
  left join cre.deal d on d.dealid = n.dealid  
  where sEvent.StatusID = e.StatusID  
  and acc.IsDeleted = 0  
  and d.dealname = @DealValue --IIF(@DealNature = 'name',d.dealname,d.credealid) =  @DealValue  
  and acc.name = @NoteValue --IIF(@NoteNature = 'name',acc.name,n.crenoteid) =  @NoteValue  
  and fs.value > 0  
 ) a  
 WHERE rownum =1  
 )b on b.NoteId = n.NoteID  
 WHERE  d.dealname = @DealValue --IIF(@DealNature = 'name',d.dealname,d.credealid) =  @DealValue  
  and acc.name = @NoteValue  --IIF(@NoteNature = 'name',acc.name,n.crenoteid) =  @NoteValue  
  and n.InitialFundingAmount > 0  
          
END  
  
IF(@Intent = 'BalloonPayment')  
 BEGIN  
  SELECT tr.balloon as SingleResult   
  FROM CRE.Note n   
  inner join Core.Account a on n.Account_AccountID=a.AccountID    
  inner join cre.Deal d on d.dealid = n.dealid  
  left join  
  (  
    Select n.noteid, Abs(Amount) as balloon 
    from CRE.TransactionEntry   tr
    Inner Join core.account acc on acc.accountid = tr.accountid
    inner join cre.note n on n.account_accountid = acc.AccountID
    where AnalysisID = @Analysisid  
    and [Type] = 'Balloon'  
  )Tr on Tr.noteid = n.noteid  
  where a.name = @NoteValue --IIF(@NoteNature = 'name',a.name,n.crenoteid) =  @NoteValue  
  and d.DealName =  @DealValue --IIF(@DealNature = 'name',d.dealname,d.credealid) =  @DealValue  
    
END  
  
--IF(@Intent = 'RemainingFundingNote')  
--BEGIN  
-- Select (n.Totalcommitment - (n.initialfundingamount + SUM( fs.value) ))  as SingleResult  
-- from [CORE].FundingSchedule fs  
-- INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId  
-- INNER JOIN(        
--  Select   
--  (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
--  MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID  
--  from [CORE].[Event] eve  
--  INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
--  INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
--  where EventTypeID = 10       
--  and acc.IsDeleted = 0  
--  and eve.StatusID = 1  
--  and IIF(@NoteNature = 'name',acc.name,n.crenoteid) =  @NoteValue  
--  GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID  
-- ) sEvent  
-- ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
-- INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
-- INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
-- inner join cre.deal d on d.dealid = n.dealid  
-- where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0 and fs.applied = 1  
-- and d.dealname = @DealValue --IIF(@DealNature = 'name',d.dealname,d.credealid) =  @DealValue  
-- group by n.Totalcommitment,n.initialfundingamount  
   
--END  
-- INSERT INTO [HBOT].[APIAnalysisLog](StartTime,EndTime,IntentName) VALUES(@StartTime,getdate(),@Intent)  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
  
END
