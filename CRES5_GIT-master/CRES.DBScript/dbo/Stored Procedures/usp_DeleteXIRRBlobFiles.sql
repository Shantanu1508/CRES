CREATE PROCEDURE [dbo].[usp_DeleteXIRRBlobFiles] 
AS  
BEGIN  
  
SET NOCOUNT ON;  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  



Delete From [CRE].[XIRRDeleteBlobFiles]  Where IsDelete = 1


END  


