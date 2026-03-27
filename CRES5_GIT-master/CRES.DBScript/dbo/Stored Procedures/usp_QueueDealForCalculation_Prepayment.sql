-- Procedure  
  
CREATE PROCEDURE [dbo].[usp_QueueDealForCalculation_Prepayment]   
 @DealID UNIQUEIDENTIFIER,  
 @UpdatedBy nvarchar(256),  
 @AnalysisID UNIQUEIDENTIFIER,  
 @CalcType int  ,
 @RequestFrom  Nvarchar(256),
 @IsEmailSent int
AS  
BEGIN  
 
 

Declare @DealAccountID UNIQUEIDENTIFIER = (Select AccountID from cre.deal where dealid = @DealID)

Delete from Core.CalculationRequests where DealID = @DealID and  AnalysisID = @AnalysisID   and CalcType = 776
   
INSERT INTO Core.CalculationRequests(  
AccountId,  
RequestTime,  
StatusID,  
UserName,  
PriorityID,  
AnalysisID,  
NumberOfRetries, 
DealID,
CalcType,
CalcEngineType,
RequestFrom,
IsEmailSent
)   
  
select   
@DealAccountID as AccountId  
,getdate()  
,292 as StatusID  
,@UpdatedBy as UserName  
,272 as PriorityID    
,@AnalysisID as AnalysisID  
,1 as NumberOfRetries 
,@DealID as DealID
,776 as CalcType  
,797 as CalcEngineType
,@RequestFrom
,@IsEmailSent
  
  
END
