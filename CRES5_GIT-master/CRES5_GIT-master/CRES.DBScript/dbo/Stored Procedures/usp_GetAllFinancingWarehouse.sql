


CREATE PROCEDURE [dbo].[usp_GetAllFinancingWarehouse] --'80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B',1,20,''
(
	@UserID UNIQUEIDENTIFIER,
	@PageIndex INT,
    @PageSize INT,
	@TotalCount INT OUTPUT 
)
	
AS
BEGIN


	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    
	SELECT @TotalCount = COUNT(FinancingWarehouseID) FROM CRE.FinancingWarehouse;

		SELECT 
	fw.FinancingWarehouseID,
	fw.Account_AccountID,
	acc.Name,
	acc.StatusID,
	lkstatus.Name AS StatusIDText,
	fw.IsRevolving,
	lkIsRevolving.Name AS IsRevolvingText,
	acc.BaseCurrencyID,
	lkBaseCurrencyID.Name AS BaseCurrencyIDText,
	OriginationFee ,
	TotalConstraint ,

	fw.CreatedBy ,
	fw.CreatedDate ,
	fw.UpdatedBy ,
	fw.UpdatedDate 
	FROM CRE.FinancingWarehouse fw
	INNER JOIN Core.Account acc ON acc.AccountID = fw.Account_AccountID
	INNER JOIN Core.Lookup lkstatus ON lkstatus.LookupID = acc.StatusID
	left JOIN Core.Lookup lkIsRevolving ON lkIsRevolving.LookupID = fw.IsRevolving
	left JOIN Core.Lookup lkBaseCurrencyID ON lkBaseCurrencyID.LookupID = acc.BaseCurrencyID

	where acc.IsDeleted = 0
	ORDER BY fw.UpdatedDate DESC
	OFFSET (@PageIndex - 1)*@PageSize ROWS
	FETCH NEXT @PageSize ROWS ONLY;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END




