CREATE PROCEDURE [dbo].[usp_UpdateXIRRDeleteBlobFiles] 
	@XIRRDeleteBlobFilesID  int
AS  
BEGIN  
  
SET NOCOUNT ON;  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  



Update [CRE].[XIRRDeleteBlobFiles] set IsDelete = 1,[UpdatedDate] = getdate() Where XIRRDeleteBlobFilesID = @XIRRDeleteBlobFilesID


END  


