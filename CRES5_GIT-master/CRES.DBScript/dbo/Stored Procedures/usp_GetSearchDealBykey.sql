


CREATE PROCEDURE [dbo].[usp_GetSearchDealBykey] --'80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B',1,20,'',''
    @UserID UNIQUEIDENTIFIER,
    @PageIndex INT,
    @PageSize INT,
	@SearchKey VARCHAR(500),
	@TotalCount INT OUTPUT 
AS
BEGIN
--select * from CRE.Note  
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	 
	 SELECT TOP (@PageSize) DealID AS ValueID
      ,DealName AS Valuekey	
	   FROM CRE.Deal d   
	   WHERE DealName LIKE '%' + @SearchKey + '%'
	   and IsDeleted=0
       ORDER BY d.UpdatedDate DESC
	 
	 SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END

