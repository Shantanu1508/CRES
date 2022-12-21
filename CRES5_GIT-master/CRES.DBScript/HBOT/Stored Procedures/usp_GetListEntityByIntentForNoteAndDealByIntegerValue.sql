  
-- [HBOT].[usp_GetListEntityByIntentForNoteAndDealByIntegerValue]  null,null,null,null,2.4,'DealLiborFloorBelowPercentage'  
  
CREATE PROCEDURE [HBOT].[usp_GetListEntityByIntentForNoteAndDealByIntegerValue]    
@NoteNature  nvarchar(256),  
@NoteValue  nvarchar(256),  
@DealNature  nvarchar(256),  
@DealValue  nvarchar(256),  
@IntValue decimal(28,15),  
@Intent  nvarchar(256)    
  
AS    
BEGIN    
    SET NOCOUNT ON;    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
Declare @Analysisid uniqueidentifier = (SELECT AnalysisID from CORE.Analysis WHERE Name='Default');  
  
  
--IF(@Intent = 'TotalYearlyInterestPaid')  
--BEGIN  
-- Select DealName, @IntValue as [Year],SumInterestAmount as Amount  
-- FROM(  
--  Select d.DealName,SUM(tr.Amount) as SumInterestAmount  
--  from cre.transactionEntry Tr  
--  inner join cre.note n on n.noteid=tr.noteid   
--  inner join cre.deal d on d.DealID = n.DealID  
--  where tr.analysisID =  'C10F3372-0FC2-4861-A9F5-148F1F80804F' and tr.[Type] in ('InterestPaid')  
--  --and tr.date <= CAST(getdate() as date)  
--  and IIF(@DealNature = 'name',d.DealName,d.credealid) =  @DealValue  
--  and Year(Date) = @IntValue  
--  group by d.DealName  
--  )a  
--END  
IF(@Intent = 'DealLiborFloorBelowPercentage')  
BEGIN  
 Select distinct d.CREDealID,d.DealName,rs.Value from [CORE].RateSpreadSchedule rs  
  INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId  
  left join core.Account acc on acc.AccountID = e.AccountID  
  left join cre.note n on n.Account_AccountID = acc.AccountID  
  left join cre.deal d on d.DealID=n.DealID  
  LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID  
  INNER JOIN (        
   Select   
   (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
   MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
   INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
   inner join cre.deal d on d.dealid = n.dealid  
   INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
   where EventTypeID = 14  
   and eve.StatusID = 1  
   and acc.IsDeleted <>1  
   GROUP BY n.Account_AccountID,EventTypeID  
  ) sEvent  
  ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
  where e.StatusID = 1  
  and LValueTypeID.name ='Index Floor'  
  and d.IsDeleted <> 1  
  and rs.Value>0  
  and rs.Value < convert(decimal(28,15),(convert(float,@IntValue)/convert(float,100)))  
END  
  
IF(@Intent = 'DealLiborFloorAbovePercentage')  
BEGIN  
 Select distinct d.CREDealID,d.DealName,rs.Value from [CORE].RateSpreadSchedule rs  
  INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId  
  left join core.Account acc on acc.AccountID = e.AccountID  
  left join cre.note n on n.Account_AccountID = acc.AccountID  
  left join cre.deal d on d.DealID=n.DealID  
  LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID  
  INNER JOIN (        
   Select   
   (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
   MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
   INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
   inner join cre.deal d on d.dealid = n.dealid  
   INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
   where EventTypeID = 14  
   and eve.StatusID = 1  
   and acc.IsDeleted <>1  
   GROUP BY n.Account_AccountID,EventTypeID  
  ) sEvent  
  ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
  where e.StatusID = 1  
  and LValueTypeID.name ='Index Floor'  
  and d.IsDeleted <> 1  
  and rs.Value>0  
  and rs.Value > convert(decimal(28,15),(convert(float,@IntValue)/convert(float,100)))  
END  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END
