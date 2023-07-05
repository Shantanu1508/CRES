
CREATE PROCEDURE [dbo].[usp_RefreshLookupList]

AS
BEGIN
	SET NOCOUNT ON;

	Select   LookupID,
			Name,
			CONCAT(LookupID,' - ' ,Name) AS DisplayValues,
	       ParentId
	FROM [Core].[Lookup] 
	WHERE IsInternal=1 

	UNION ALL

	SELECT 
	        FeeTypeNameID as  LookupID,
			FeeTypeNameText as Name,
			CONCAT(FeeTypeNameID,' - ' ,FeeTypeNameText) AS DisplayValues,
	        '10000' as ParentId
   FROM  cre.feeschedulesconfig
  -- order by ParentId ASC

   UNION ALL

	SELECT 
	        TransactionTypesID as  LookupID,
			TransactionName as Name,
			CONCAT(TransactionTypesID,' - ' ,TransactionName) AS DisplayValues,
	        '10001' as ParentId
   FROM  cre.TransactionTypes WHERE (Calculated = 4 ) --OR AllowCalculationOverride = 3

   UNION ALL

	SELECT 
	        TransactionTypesID as  LookupID,
			TransactionName as Name,
			CONCAT(TransactionTypesID,' - ' ,TransactionName) AS DisplayValues,
	        '10002' as ParentId
   FROM  cre.TransactionTypes -- WHERE Calculated = 3
   
   UNION ALL

	SELECT 
	        StatesID as  LookupID,
			StatesAbbreviation as Name,
			CONCAT(StatesID,' - ' ,StatesAbbreviation) AS DisplayValues,
	        '10003' as ParentId
   FROM  App.[StatesMaster]

   UNION ALL

   Select   LookupID,
			Name,
			CONCAT(LookupID,' - ' ,Name) AS DisplayValues,
	       '10004' as ParentId
	FROM [Core].[Lookup] 
	WHERE ParentId=94 and [name] <> 'Draw Fee'

	UNION ALL

	Select   LookupID,
			Name,
			CONCAT(LookupID,' - ' ,Name) AS DisplayValues,
	       '10005' as ParentId
	FROM [Core].[Lookup] 
	WHERE ParentId=112


   order by ParentId ASC
END

