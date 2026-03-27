
CREATE PROCEDURE [dbo].[usp_GetFileNameforLiabilityCalcExcelBlob]
(
@AccountID UNIQUEIDENTIFIER
)

AS
BEGIN
     SET NOCOUNT ON; 

SELECT 
      [FileName]
  FROM [Core].[AutomationRequests] 
  where AutomationRequestsID =  (SELECT MAX(AutomationRequestsID) 
                                FROM [Core].[AutomationRequests]
                                WHERE StatusID = 266 and DealID = @AccountID)

END




