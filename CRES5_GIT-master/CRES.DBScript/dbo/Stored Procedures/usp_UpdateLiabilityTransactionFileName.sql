CREATE PROCEDURE [dbo].[usp_UpdateLiabilityTransactionFileName] 
@AutomationRequestsID int,
@FileName nvarchar(MAX)
AS
BEGIN
 
SET NOCOUNT ON;		
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	Update Core.AutomationRequests set 
	FileName=@FileName
	where AutomationRequestsID=@AutomationRequestsID 

 SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
END
GO

