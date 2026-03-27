CREATE PROCEDURE [VAL].[usp_GetDealsFromValuationRequests]      
 @VMName NVARCHAR (256) = null  
AS          
BEGIN          
 SET NOCOUNT ON;          
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED          
          
Declare @lookupidRunning int = 267;  
Declare @lookupidProcessing int = 292;  
Declare @lookupidFailed int = 265;  
  
  
-----------Calculation retry mechanism------   
--created a script val.usp_SendValuationDealsForReCalc for retry 
---------------------------------------------------   
  
------Update to Failed if running more than 20 minute----  
update val.valuationrequests set StatusID = @lookupidFailed,EndTime = getdate() ,ErrorMessage='Forcefully failed - calculation got stucked' where ValuationRequestsID in (  
 Select ValuationRequestsID  
 from val.valuationrequests Where StatusID = 267  
 and DateDiff(minute,StartTime,getdate()) > 20
)  
---------------------------------------------------------  
  
------Update to Processing again if Processing more than 30 min----  
update val.valuationrequests set StatusID = @lookupidProcessing,RequestTime = getdate() ,VMMasterID = null where ValuationRequestsID in (  
 Select ValuationRequestsID  
 from val.valuationrequests Where VMMasterID is not NULL and StartTime is null and StatusID = 292  
 and DateDiff(MINUTE,RequestTime,getdate()) > 20   
)  
---------------------------------------------------------  
  
Declare @VMMasterID int = (Select VMMasterID From [App].[VMMaster] Where VMName = @VMName)  
     
IF EXISTS(Select top 1 valuationrequestsID from val.valuationrequests where  StatusID =292)  
BEGIN  
 Declare @countMax int = 3;  
 Declare @Running int = (select COUNT(*) from val.valuationrequests where StatusID=267 and VMMasterID = @VMMasterID);        
 Declare @count int = 0;  
 set @count = @countMax-@Running;  
        
 Declare @tblQueue TABLE  (           
  ValuationRequestsID [int]     
 )        
    
 INSERT INTO @tblQueue(ValuationRequestsID)  
 Select Top (ISNULL(@count,0)) ValuationRequestsID   
 from  val.valuationrequests v  
 Inner Join cre.deal d on d.dealid = v.dealid   
 Inner Join [VAL].[MarkedDateMaster] md on md.MarkedDateMasterID = v.MarkedDateMasterID  
 where  StatusID =292   
 and v.VMMasterID IS NULL  
 Order by v.RequestTime  
  
  
 Update val.valuationrequests set VMMasterID = @VMMasterID,CNT = ISNULL(CNT,0) + 1 where ValuationRequestsID in (Select ValuationRequestsID from @tblQueue)   -----StatusID=267, StartTime=getdate() ,  
  
 select Top (ISNULL(@count,0))  
 v.ValuationRequestsID   
 ,v.DealID   
 ,d.CREDealID  
 ,v.RequestTime   
 ,v.StartTime   
 ,v.EndTime   
 ,v.StatusID   
 ,v.AnalysisID   
 ,v.ErrorMessage   
 ,v.CreatedBy   
 ,v.CreatedDate   
 ,v.UpdatedBy   
 ,v.UpdatedDate  
 ,md.MarkedDate  
 from  val.valuationrequests v  
 Inner Join cre.deal d on d.dealid = v.dealid   
 Inner Join [VAL].[MarkedDateMaster] md on md.MarkedDateMasterID = v.MarkedDateMasterID  
 where v.ValuationRequestsID in (Select ValuationRequestsID from @tblQueue)  
 Order by v.RequestTime   
   
          
END   
         
      
      
       
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
END
GO

