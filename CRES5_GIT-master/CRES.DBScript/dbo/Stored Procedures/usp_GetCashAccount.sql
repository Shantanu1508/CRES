CREATE PROCEDURE [dbo].[usp_GetCashAccount]       
AS      
BEGIN      
	
	Select acc.AccountID as CashAccountID,acc.[Name] as CashAccountName 
	From [Core].[Account] acc 
	INNER JOIN [CRE].[CASH] C ON C.AccountID = acc.AccountID 
	Order by acc.[Name]
      
END