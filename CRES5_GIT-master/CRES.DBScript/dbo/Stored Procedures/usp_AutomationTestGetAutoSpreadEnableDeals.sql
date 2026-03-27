CREATE PROCEDURE [dbo].[usp_AutomationTestGetAutoSpreadEnableDeals]       
  @DealType nvarchar(256)    
       
AS      
BEGIN      
      SET NOCOUNT ON;      
    
    
IF(@DealType = 'All')    
BEGIN    
 SELECT  CREDealID  as DealID     
 ,DealName        
 FROM CRE.Deal d      
 Where IsDeleted <> 1     
 and status = 323        
 ORDER BY d.dealname     
END     
    
    
IF(@DealType = 'AllFunded')    
BEGIN    
 SELECT Distinct    CREDealID  as DealID     
 ,DealName        
 FROM CRE.Deal d      
 Inner join cre.note n on n.dealid = d.dealid    
 Where IsDeleted <> 1     
 and status = 323    and n.ActualPayoffDate IS null    
 ORDER BY d.dealname     
END     
    
    
IF(@DealType = 'Autospread')    
BEGIN    
 SELECT   CREDealID  as DealID     
 ,DealName        
 FROM CRE.Deal d      
 Where IsDeleted <> 1 and (EnableAutoSpreadRepayments = 1 OR EnableAutoSpread = 1)     
 and status = 323        
 ORDER BY d.dealname     
END     
    
IF(@DealType = 'Phantom')    
BEGIN    
 SELECT   CREDealID  as DealID     
 ,DealName        
 FROM CRE.Deal d      
 Where IsDeleted <> 1     
 and status = 325    
 ORDER BY d.dealname     
END     
    
    
    
    
END    