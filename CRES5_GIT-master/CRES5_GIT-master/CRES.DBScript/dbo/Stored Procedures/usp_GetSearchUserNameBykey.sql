


CREATE PROCEDURE [dbo].[usp_GetSearchUserNameBykey]  --'80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B',1,20,'K',''
    @UserID UNIQUEIDENTIFIER,
    @PageIndex INT,
    @PageSize INT,
	@SearchKey VARCHAR(500),
	@TotalCount INT OUTPUT 
AS
BEGIN
  
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	 SELECT TOP (@PageSize) UserID AS ValueID
      ,d.FirstName + ' ' + d.LastName AS Valuekey	
	   FROM App.[User] d   
	   WHERE FirstName LIKE '%' + @SearchKey + '%'
       ORDER BY d.FirstName  

	   	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END


 
