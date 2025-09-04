CREATE PROCEDURE [dbo].[usp_GetAllFeeTypesFromFeeSchedulesConfigLiability] 

AS
BEGIN
SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	Select [FeeTypeNameID],[FeeTypeNameText] from cre.FeeSchedulesConfigLiability order by FeeTypeNameText


END



