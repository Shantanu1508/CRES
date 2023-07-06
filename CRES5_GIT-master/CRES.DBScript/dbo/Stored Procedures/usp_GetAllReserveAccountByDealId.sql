-- [dbo].[usp_GetAllReserveAccountByDealId] 'B0E6697B-3534-4C09-BE0A-04473401AB93','C7A300A5-33FF-42C9-9806-7D94D58F8010'

 CREATE PROCEDURE [dbo].[usp_GetAllReserveAccountByDealId] 
(  
	@UserID varchar(100), 
	@DealID varchar(100)
	
)  
AS
 BEGIN
	SELECT 
	[DealID],
	ReserveAccountGUID,
	ReserveAccountID,
	CREReserveAccountID,
	[ReserveAccountName] ,
	[InitialBalanceDate] ,
	[InitialFundingAmount] ,
	[EstimatedReserveBalance],
	FloatInterestRate,
	'true' as IsValidateHoliday
	from
	[CRE].[ReserveAccount]
	where DealID=@DealID
 END
