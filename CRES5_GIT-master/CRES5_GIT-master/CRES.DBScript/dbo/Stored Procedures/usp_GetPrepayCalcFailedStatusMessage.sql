--[dbo].[usp_GetPrepayCalcFailedStatusMessage]  '332a5e28-5ce1-4eb4-ae5c-77cccee140c9'
CREATE PROCEDURE [dbo].[usp_GetPrepayCalcFailedStatusMessage]       
(    
 @Dealid varchar(50)
)     
AS          
BEGIN          
 -- SET NOCOUNT ON added to prevent extra result sets from          
 -- interfering with SELECT statements.          
 SET NOCOUNT ON;    
    
   
IF EXISTS (Select top 1 RequestID  from [core].[CalculationRequests] where DealID =@DealID and noteid='00000000-0000-0000-0000-000000000000' and calctype =776)
BEGIN
	select a.Message,a.Message_StackTrace,a.ObjectID as RequestID
	from [app].[logger] a
	where a.ObjectID=(Select top 1 RequestID  from [core].[CalculationRequests] where DealID =@DealID and noteid='00000000-0000-0000-0000-000000000000' and calctype =776 )
END 
ELSE
  Select top 1 RequestID  from [core].[CalculationRequests] where DealID =@DealID and noteid='00000000-0000-0000-0000-000000000000' and calctype =776 
END
GO

