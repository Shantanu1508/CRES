
CREATE Procedure [dbo].[usp_GetFinancingWarehouseById]
(
	@FinancingWarehouseID Varchar(256)
)
as 
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT 
	fw.FinancingWarehouseID,
	fw.Account_AccountID,
	acc.Name,
	acc.StatusID,
	lkstatus.Name AS StatusIDText,
	acc.payfrequency,
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
	LEFT JOIN Core.Lookup lkstatus ON lkstatus.LookupID = acc.StatusID
	LEFT JOIN Core.Lookup lkIsRevolving ON lkIsRevolving.LookupID = fw.IsRevolving
	LEFT JOIN Core.Lookup lkBaseCurrencyID ON lkBaseCurrencyID.LookupID = acc.BaseCurrencyID
where fw.FinancingWarehouseID=@FinancingWarehouseID and  acc.IsDeleted = 0
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
