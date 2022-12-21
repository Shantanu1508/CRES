


CREATE PROCEDURE [dbo].[usp_GetSearchPIKAccountBykey] --'80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B',1,20,'',''
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
	 SELECT TOP (@PageSize) Account_AccountID AS ValueID
      ,CRENoteID AS Valuekey	
	   FROM CRE.Note d  
	   inner join core.Account acc on acc.AccountID = d.Account_AccountID 
	   WHERE CRENoteID LIKE '%' + @SearchKey + '%' and acc.IsDeleted = 0
       ORDER BY d.UpdatedDate DESC
	 SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
