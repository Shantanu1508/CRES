

CREATE PROCEDURE [dbo].[usp_GetModuleTabMaster]	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
 
SELECT [ModuleTabMasterID]
      ,[ModuleTabName]
      ,[ParentID]
      ,[StatusID]
      ,[SortOrder]
      ,[DisplayName]
      ,[ModuleType]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
  FROM [App].[ModuleTabMaster]
  where [DisplayName]<> 'Libor' and parentid =43 
 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
