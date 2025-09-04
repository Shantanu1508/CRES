CREATE PROCEDURE [dbo].[usp_GetTransactionTypeIsClub_V1]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT TT.TransactionName, L.[Name] as 'IsClubTransactionOnSameDate' from CRE.TransactionTypes TT 
	INNER JOIN [CORE].[Lookup] L ON L.LookupID = TT.IsClubTransactionOnSameDate Where L.LookupID = 3
	ORDER BY TT.TransactionName;

END