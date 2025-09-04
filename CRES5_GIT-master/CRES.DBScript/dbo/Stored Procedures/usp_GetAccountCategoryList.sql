CREATE PROCEDURE [dbo].[usp_GetAccountCategoryList]  
AS
BEGIN

	select AccountCategoryID as LookupID
	,Name as [Name],[type]
	,(CASE WHEN [type] like '%Long Term Liabilities%' OR [type] like '%Short Term Liabilities%' THEN 'Debt' 
	WHEN [type] = 'Equity' THEN 'Equity' ELSE 'Other' END) as [LiabilitiesType]

	from core.AccountCategory

END