CREATE PROCEDURE [dbo].[usp_GetXIRRReferencingDealLevelReturnLookup]	
	
AS
BEGIN
	SET NOCOUNT ON;

  Select XIRRConfigID, ReturnName from (

	SELECT 0 AS XIRRConfigID, 'N/A' AS ReturnName

	UNION ALL

	Select XIRRConfigID, ReturnName from CRE.XIRRConfig where Type = 'Deal'
	) result
	ORDER BY 
	    CASE WHEN ReturnName = 'N/A' THEN 0 ELSE 1 END,
	    ReturnName 
END