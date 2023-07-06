-- Procedure  
  
CREATE PROCEDURE [dbo].[usp_QueueDealForCalculation_Prepayment]   
 @DealID UNIQUEIDENTIFIER,  
 @UpdatedBy nvarchar(256),  
 @AnalysisID UNIQUEIDENTIFIER,  
 @CalcType int  
AS  
BEGIN  
  
   
Delete from Core.CalculationRequests where DealID = @DealID and  AnalysisID = @AnalysisID   
   
INSERT INTO Core.CalculationRequests(  
NoteId,  
RequestTime,  
StatusID,  
UserName,  
PriorityID,  
AnalysisID,  
NumberOfRetries, 
DealID,
CalcType)   
  
select   
'00000000-0000-0000-0000-000000000000' as NoteId  
,getdate()  
,292 as StatusID  
,@UpdatedBy as UserName  
,272 as PriorityID    
,@AnalysisID as AnalysisID  
,1 as NumberOfRetries 
,@DealID as DealID
,776 as CalcType  
  
  
  
END
