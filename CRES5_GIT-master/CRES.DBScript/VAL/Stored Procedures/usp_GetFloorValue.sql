
CREATE PROCEDURE [VAL].[usp_GetFloorValue] ---'LIBOR 1M'
(
	@MarkedDate date,
	@IndexTypeName nvarchar(256) = null
)
AS  
BEGIN  
  
	SET NOCOUNT ON;  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
   
	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = @MarkedDate)


	 IF(@IndexTypeName is not null)
	 BEGIN
 		Select IndexTypeName,
		CurrentMarketLoanFloor,
		Term,
		LoanFloor
		from [val].FloorValue fv
		Where fv.IndexTypeName = @IndexTypeName
		and fv.MarkedDateMasterID = @MarkedDateMasterID
 

	 END
	 ELSE
	 BEGIN
		Select IndexTypeName,
		CurrentMarketLoanFloor,
		Term,
		LoanFloor
		from [val].FloorValue fv
		where fv.MarkedDateMasterID = @MarkedDateMasterID
	 END




	SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  
