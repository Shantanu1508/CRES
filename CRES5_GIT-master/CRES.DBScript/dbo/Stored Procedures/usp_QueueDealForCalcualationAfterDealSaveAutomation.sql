CREATE PROCEDURE [dbo].[usp_QueueDealForCalcualationAfterDealSaveAutomation]    
AS  
BEGIN  
  
 SET NOCOUNT ON;  
 
 Declare @runningcount int;
 SET @runningcount = (select count(*) from  Core.AutomationRequests where StatusID in (292,267) and BatchType<>'LiabilityCalculation') 

 If (@runningcount=0 )
 begin
		   select distinct(d.CREDealID) as DealID from  Core.AutomationRequests cr
		   left join CRE.Deal d on cr.DealID= d.DealID
			where isDealSentForCalc=4 and  StatusID =266
 end

 
END