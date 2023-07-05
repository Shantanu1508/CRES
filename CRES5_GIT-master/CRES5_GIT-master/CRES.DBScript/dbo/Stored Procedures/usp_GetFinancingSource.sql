



CREATE PROCEDURE [dbo].[usp_GetFinancingSource]
@UserID UNIQUEIDENTIFIER

AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

    SELECT [FinancingSourceMasterID]
           ,[FinancingSourceName]
           ,[FinancingSourceCode]
           ,[ParentClient]
           ,[SortOrder]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate]
    FROM [CRE].[FinancingSourceMaster] 
	ORDER BY FinancingSourceName


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  
  
  







