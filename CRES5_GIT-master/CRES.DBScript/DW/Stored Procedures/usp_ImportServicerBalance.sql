CREATE PROCEDURE [DW].[usp_ImportServicerBalance]	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
	Truncate table [DW].[ServicerBalance]

	INSERT INTO [DW].[ServicerBalance] (CREDealID
	,DealName
	,WatchlistStatus
	,CRENoteID
	,NoteName
	,ServicerName
	,ServicerID
	,PurposeType
	,LastPaydown
	,LastPaydownAmount
	,M61_Balance
	,Servicer_Balance
	,delta
	,List_crenoteid
	,Createddate
	,ServicingStatusBS
	)
	EXEC [dbo].[usp_GetDiscrepancyBalanceBetweenM61andServicer] 



	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END
