---[CRE].[usp_UpdateNoteCalculatedWeightedSpread] 'A37B5E9F-A33B-4391-ACF6-00D13A2A464A'  
  
CREATE Procedure [CRE].[usp_UpdateNoteCalculatedWeightedSpread]   
 @NoteID uniqueidentifier ,  
 @WeightedSpread decimal(28,15)  
AS    
BEGIN  
 SET NOCOUNT ON;  
  
  
  
 Update cre.note set WeightedSpread = @WeightedSpread where noteid =@NoteID  
  
  
  
--Declare @DealID uniqueidentifier;  
--SET @DealID = (Select dealid from cre.note where NoteID = @NoteID)  
  
  
  
--Update cre.note set WeightedSpread = y.CalcWeightedSpread  
--From(  
-- Select NoteID, CalcWeightedSpread  
-- From(  
-- Select nt.NoteID,tblSpread.CurrentSpread as WeightedSpread,  
-- Round((Round(ISNULL(tblSpread.CurrentSpread,0) + ISNULL(tblPIKSchedule.PIKSpread,0),8) * Round(ISNULL(nt.TotalCommitment,0),8)/ Round(SUM(ISNULL(nt.TotalCommitment,0)) Over (Partition By nt.DealID),8)),6) as CalcWeightedSpread  
-- From [CRE].[Note] nt   
-- LEFT JOIN (  
--  Select NoteID,CurrentSpread   
--  From(  
--   Select n.noteid as NoteID,rs.Date, LValueTypeID.name as ValueType,rs.value as CurrentSpread,  
--   ROW_number() Over (Partition by n.noteid order by n.noteid,rs.Date desc) rno    
--   from [CORE].RateSpreadSchedule rs   
--   INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId      
--   LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID         
--   INNER JOIN (       
--    Select   
--    (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
--    MAX(EffectiveStartDate) EffectiveStartDate,  
--    EventTypeID   
--    from [CORE].[Event] eve        
--    INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID        
--    INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID        
--    where EventTypeID = 14  
--    and eve.StatusID = 1  
--    and acc.IsDeleted = 0   
--    and n.DealID = @DealID      
--    GROUP BY n.Account_AccountID,EventTypeID         
--   ) sEvent ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID      
--   INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID    
--   INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID    
--   where e.StatusID = 1  and acc.IsDeleted = 0  and LValueTypeID.name = 'Spread'    
--   and rs.Date <= CAST(getdate() as date)   
--   and n.DealID = @DealID  
--  )tblrs Where rno=1  
-- ) tblSpread ON tblSpread.NoteID=nt.NoteID   
  
-- LEFT JOIN (  
--  Select     
--  n.NoteID,  
--  pik.[AdditionalSpread] as PIKSpread  
--  from [CORE].PikSchedule pik    
--  left JOIN [CORE].[Account] accsource ON accsource.AccountID = pik.SourceAccountID    
--  left JOIN [CORE].[Account] accDest ON accDest.AccountID = pik.TargetAccountID    
--  INNER JOIN [CORE].[Event] e on e.EventID = pik.EventId    
--  LEFT JOIN [CORE].[Lookup] LPIKReasonCode ON LPIKReasonCode.LookupID = pik.PIKReasonCodeID    
--  LEFT JOIN [CORE].[Lookup] LPIKIntCalcMethodID ON LPIKIntCalcMethodID.LookupID = pik.PIKIntCalcMethodID    
--  LEFT JOIN [CORE].[Lookup] LPIKSetUp ON LPIKSetUp.LookupID = pik.PIKSetUp    
--  LEFT JOIN [CORE].[Lookup] lPIKSeparateCompounding ON pik.PIKSeparateCompounding=lPIKSeparateCompounding.LookupID   
--  INNER JOIN     
--     (    
--   Select     
--    (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,    
--    MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve    
--    INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID    
--    INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID    
--    where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'PikSchedule')    
--    and n.dealid = @DealID  and acc.IsDeleted = 0    
--    GROUP BY n.Account_AccountID,EventTypeID    
    
--     ) sEvent    
    
--  ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID    
--  INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID    
--    INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID    
--    where acc.IsDeleted = 0 and n.dealid = @DealID  
--  AND PIK.PIKSetUp=871  
-- )tblPIKSchedule ON tblPIKSchedule.NoteID=nt.NoteID  
  
-- Where nt.DealID=@DealID  
  
-- )z  
-- where z.NoteID = @NoteID  
  
  
--)y  
--Where cre.note.NoteID = y.NoteID  
  
  
END