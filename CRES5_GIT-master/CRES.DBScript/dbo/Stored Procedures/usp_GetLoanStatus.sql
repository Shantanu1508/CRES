-- [dbo].[usp_GetLoanStatus] 'd4cb7189-0b71-48c0-93e1-b81fde38da59'
CREATE Procedure [dbo].[usp_GetLoanStatus]  
@UserID NVarchar(255)  
  
AS  
  
BEGIN  
  
 SET NOCOUNT ON;  
  
 Select   
LoanStatusID,
LoanStatusDesc	
 from cre.[LoanStatus]
 order by OrderKey  
END
GO

