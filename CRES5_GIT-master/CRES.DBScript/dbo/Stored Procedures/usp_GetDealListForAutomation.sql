CREATE PROCEDURE [dbo].[usp_GetDealListForAutomation] --'FundingMoveToNextMonth'    
 @type nvarchar(256)     
AS    
BEGIN          
        
 SET NOCOUNT ON;          
    
Declare @tblDeals as table(DealID nvarchar(256))      
  
Delete from @tblDeals    
    
IF((Select [value] from [App].[AppConfig] where [Key] = 'AllowDealAutomation') = 1)  
BEGIN  
  
 if(@type = 'AutoSpread_UnderwritingDataChanged')    
 BEGIN    
  Select null as dealid where 1 = 2  
  --exec [dbo].[usp_GetDiscrepancyForAutoSpreadUnderwritingData]    
  return;    
 END    
  
 IF(@type = 'All_AutoSpread_Deals')    
 BEGIN    
  INSERT INTO @tblDeals(DealID)    
  Select Distinct d.DealID    
  from cre.Note n    
  inner join core.account acc on acc.accountid = n.account_accountid    
  inner join cre.Deal d on n.DealID = d.DealID    
  where n.ActualPayoffdate is null     
  and acc.IsDeleted <> 1 and d.isdeleted <> 1    
  and d.Status = 323    
  and d.dealid not in (Select distinct dealid from [CRE].[DealFunding] where PurposeID = 630) --FullPayOff    
  and d.EnableAutoSpreadRepayments = 1    
 END    
  
 IF(@type = 'FundingMoveToNextMonth')    
 BEGIN    
  INSERT INTO @tblDeals(DealID)    
  Select distinct df.dealid    
  from cre.dealfunding df    
  Inner join cre.deal d on d.dealid = df.dealid    
  where d.isdeleted <> 1 and df.applied <> 1 and df.comment is null    
  and df.date >= CAST(DATEADD(DD,-(DAY(GETDATE() -1)), GETDATE()) as date) and df.date <= EOMONTH(getdate())    
  and df.Amount > 0    
  and df.purposeid in (318,320,519,520,581)   ---Capital Expenditure,TI/LC,OpEx,Force Funding,Capitalized Interest    
 END    
    
 IF(@type = 'AmortizationAutoWire')    
 BEGIN    
  INSERT INTO @tblDeals(DealID)    
  Select distinct df.dealid    
  from cre.dealfunding df    
  Inner join cre.deal d on d.dealid = df.dealid    
  where d.isdeleted <> 1    
  and df.applied <> 1     
  and df.purposeid  = 351  ---'Amortization'    
  and df.date = Cast(getdate() as date)    
 END    
 


END  
    
    
    
IF EXISTS(Select top 1 DealID from @tblDeals)     
BEGIN      
 select DealID from @tblDeals    
 --Select null as dealid where 1 = 2   
END    
    
    
END
GO

