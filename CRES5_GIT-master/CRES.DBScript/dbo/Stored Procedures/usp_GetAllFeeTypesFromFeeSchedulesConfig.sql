CREATE PROCEDURE [dbo].[usp_GetAllFeeTypesFromFeeSchedulesConfig] 

AS
BEGIN
SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	Select [FeeTypeNameID],[FeeTypeNameText] from cre.FeeSchedulesConfig order by FeeTypeNameText


END


