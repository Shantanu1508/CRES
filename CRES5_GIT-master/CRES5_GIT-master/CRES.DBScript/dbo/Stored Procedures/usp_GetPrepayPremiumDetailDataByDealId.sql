-- [dbo].[usp_GetPrepayPremiumDetailDataByDealId] '7E1AF9CE-4354-4E06-BFCC-4BD1B8DD78D2','5848ca08-b9b0-4b93-9e0b-311c560f58f4'      
      
      
CREATE PROCEDURE [dbo].[usp_GetPrepayPremiumDetailDataByDealId]   --'90fa31ec-a1e5-4714-a157-b4f8def20b1f','B0E6697B-3534-4C09-BE0A-04473401AB93'      
(      
 @Dealid varchar(50),      
 @UserID UNIQUEIDENTIFIER      
)      
AS      
      
BEGIN      
 SET NOCOUNT ON;      
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
      
Declare @prepayScheduleiD int;      
      
       
 Select @prepayScheduleiD = prepayScheduleiD       
 from [CORE].prepaySchedule ps      
 INNER JOIN [CORE].[EventDeal] e on e.EventDealID = ps.EventDealID      
 INNER JOIN       
 (      
  Select d.dealid,ed.eventtypeid,ed.StatusID,MAX(EffectiveDate) as EffectiveDate from core.EventDeal ed      
  inner join cre.deal d on d.dealid = ed.dealid      
  where d.IsDeleted <> 1 and ed.StatusID = 1      
  and ed.eventtypeid = 737      
  and d.dealid = @Dealid      
  group by d.dealid,ed.StatusID,ed.eventtypeid      
 ) sEvent ON sEvent.Dealid = e.Dealid and e.EffectiveDate = sEvent.EffectiveDate  and e.EventTypeID = sEvent.EventTypeID and e.StatusID = sEvent.StatusID      
 left JOin core.Lookup lPrepaymentMethod on lPrepaymentMethod.lookupid = ps.PrepaymentMethod      
 left JOin core.Lookup lSpreadCalcMethod on lSpreadCalcMethod.lookupid = ps.SpreadCalcMethod      
 left JOin core.Lookup lBaseAmount on lBaseAmount.lookupid = ps.BaseAmountType     
 where e.StatusID = 1  and e.dealid = @Dealid      
         
         
      
       
 select       
 PrepayAdjustmentID       
 ,PrepayScheduleID       
 ,Date       
 ,PrepayAdjAmt as Amount       
 ,Comment       
 ,CreatedBy       
 ,CreatedDate       
 ,UpdatedBy       
 ,UpdatedDate       
 ,null as SpreadMaintenanceScheduleID       
 ,null as NoteID        
 ,null as Spread       
 ,null as CalcAfterPayoff      
 ,null as MinMultScheduleID       
 ,null as FeeCreditsID       
 ,null as FeeType       
 ,null as UseActualFees      
 ,null as CRENoteID      
 ,'PrepayAdjustment' as tablename      
 from [Core].[PrepayAdjustment]  Where PrepayScheduleID = @prepayScheduleiD      
      
 UNION ALL       
      
 Select       
 null as PrepayAdjustmentID       
 ,PrepayScheduleID       
 ,Date as Date       
 ,null as Amount       
 ,null as Comment       
 ,sp.CreatedBy       
 ,sp.CreatedDate       
 ,sp.UpdatedBy       
 ,sp.UpdatedDate       
 ,SpreadMaintenanceScheduleID        
 ,sp.NoteID        
 ,Spread       
 ,CalcAfterPayoff      
 ,null as MinMultScheduleID      
 ,null as FeeCreditsID       
 ,null as FeeType       
 ,null as UseActualFees      
 ,n.CRENoteID      
 ,'SpreadMaintenanceSchedule' as tablename      
 from [Core].[SpreadMaintenanceSchedule] sp      
 left join cre.note n on n.noteid = sp.noteid      
 Where PrepayScheduleID = @prepayScheduleiD and Isdeleted <> 1      
      
 UNION ALL       
      
 Select       
 null as PrepayAdjustmentID       
 ,PrepayScheduleID       
 ,Date as Date       
 ,ISNULL(MinMultAmount,0) as Amount    
 ,null as Comment       
 ,CreatedBy       
 ,CreatedDate       
 ,UpdatedBy       
 ,UpdatedDate       
 ,null as SpreadMaintenanceScheduleID        
 ,null as NoteID        
 ,null as Spread       
 ,null as CalcAfterPayoff      
 ,MinMultScheduleID      
 ,null as FeeCreditsID       
 ,null as FeeType       
 ,null as UseActualFees      
 ,null as CRENoteID      
 ,'MinMultSchedule' as tablename      
 from [Core].[MinMultSchedule] Where PrepayScheduleID = @prepayScheduleiD and Isdeleted <> 1      
      
 UNION ALL      
      
 Select       
 null as PrepayAdjustmentID       
 ,PrepayScheduleID       
 ,null as Date       
 ,FeeCreditOverride as Amount     
 ,null as Comment       
 ,CreatedBy       
 ,CreatedDate       
 ,UpdatedBy       
 ,UpdatedDate       
 ,null as SpreadMaintenanceScheduleID        
 ,null as NoteID       
 ,null as Spread       
 ,null as CalcAfterPayoff      
 ,null as MinMultScheduleID      
 ,FeeCreditsID       
 ,FeeType       
 ,ISNULL(UseActualFees,0) as UseActualFees     
 ,null as CRENoteID      
 ,'FeeCredits' as tablename      
 from [Core].[FeeCredits] Where PrepayScheduleID = @prepayScheduleiD and Isdeleted <> 1      
      
 UNION ALL      
      
 Select Distinct      
 null as PrepayAdjustmentID       
 ,PrepayScheduleID       
 ,Date as Date       
 ,null as Amount       
 ,null as Comment       
 ,null CreatedBy       
 ,null CreatedDate       
 ,null UpdatedBy       
 ,null UpdatedDate       
 ,null as SpreadMaintenanceScheduleID        
 ,null as NoteID        
 ,Spread       
 ,CalcAfterPayoff      
 ,null as MinMultScheduleID      
 ,null as FeeCreditsID       
 ,null as FeeType       
 ,null as UseActualFees      
 ,null as CRENoteID      
 ,'SpreadMaintenanceSchedule_DealLevel' as tablename      
 from [Core].[SpreadMaintenanceSchedule] sp      
 left join cre.note n on n.noteid = sp.noteid      
 Where PrepayScheduleID = @prepayScheduleiD and Isdeleted <> 1      
      
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED      
      
END  