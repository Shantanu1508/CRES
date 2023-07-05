CREATE PROCEDURE [Core].[usp_GetAllPortfolio] --'B0E6697B-3534-4C09-BE0A-04473401AB93',1,10,0
(
    @UserID UNIQUEIDENTIFIER,
    @PgeIndex INT,
    @PageSize INT,
	@TotalCount INT OUTPUT 
)
AS
BEGIN
SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	 
   SELECT @TotalCount = COUNT(PortfolioMasterID) FROM  [Core].[PortfolioMaster]
     
	SELECT [PortfolioMasterID]
      ,[PortfolioMasterGuid]
      ,[PortfoliName]
      ,[Description]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
	  ,[AllowWholeDeal]
	  ,CASE
			WHEN [AllowWholeDeal] = 1 THEN 'Yes'
			ELSE 'No'
			END AS AllowWholeDealText

	FROM [Core].[PortfolioMaster]
    ORDER BY UpdatedDate DESC
	OFFSET (@PgeIndex - 1)*@PageSize ROWS
	FETCH NEXT @PageSize ROWS ONLY
    
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED


END

