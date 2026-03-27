
Create PROCEDURE [App].[usp_GetAllBlobFileForDelete]  
  
AS  
BEGIN  
  
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  


 Select FolderName ,
DeletedDays ,
Module,
[CreatedBy],
[CreatedDate],
[UpdatedBy],
[UpdatedDate] from [App].[BlobDeleteConfig]
where IsActive=1

 END