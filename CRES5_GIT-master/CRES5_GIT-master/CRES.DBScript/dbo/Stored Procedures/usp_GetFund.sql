CREATE Procedure [dbo].[usp_GetFund]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT [FundID],[FundName] FROM [CRE].[Fund] order by [FundName]
End
