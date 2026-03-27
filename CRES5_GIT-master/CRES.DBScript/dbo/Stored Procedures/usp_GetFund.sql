CREATE Procedure [dbo].[usp_GetFund]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT [FundID],[FundName],ParentFund FROM [CRE].[Fund] order by [FundName]
End
