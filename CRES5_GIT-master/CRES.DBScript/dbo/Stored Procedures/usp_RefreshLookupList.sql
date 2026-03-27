
CREATE PROCEDURE [dbo].[usp_RefreshLookupList]

AS
BEGIN
	SET NOCOUNT ON;

	Select   CAST(LookupID as nvarchar(256)) as LookupID,
			Name,
			CONCAT(LookupID,' | ' ,Name) AS DisplayValues,
	       ParentId
	FROM [Core].[Lookup] 
	WHERE IsInternal=1 

	UNION ALL

	SELECT 
	        CAST(FeeTypeNameID as nvarchar(256)) as  LookupID,
			FeeTypeNameText as Name,
			CONCAT(FeeTypeNameID,' | ' ,FeeTypeNameText) AS DisplayValues,
	        '10000' as ParentId
   FROM  cre.feeschedulesconfig
  -- order by ParentId ASC

   UNION ALL

	SELECT 
	        CAST(TransactionTypesID as nvarchar(256))  as  LookupID,
			TransactionName as Name,
			CONCAT(TransactionTypesID,' | ' ,TransactionName) AS DisplayValues,
	        '10001' as ParentId
   FROM  cre.TransactionTypes WHERE (Calculated = 4 ) --OR AllowCalculationOverride = 3

   UNION ALL

	SELECT 
	        CAST(TransactionTypesID as nvarchar(256)) as  LookupID,
			TransactionName as Name,
			CONCAT(TransactionTypesID,' | ' ,TransactionName) AS DisplayValues,
	        '10002' as ParentId
   FROM  cre.TransactionTypes -- WHERE Calculated = 3
   
   UNION ALL

	SELECT 
	        CAST(StatesID as nvarchar(256)) as  LookupID,
			StatesAbbreviation as Name,
			CONCAT(StatesID,' | ' ,StatesAbbreviation) AS DisplayValues,
	        '10003' as ParentId
   FROM  App.[StatesMaster]

   UNION ALL

   Select   CAST(LookupID as nvarchar(256)) as LookupID,
			Name,
			CONCAT(LookupID,' | ' ,Name) AS DisplayValues,
	       '10004' as ParentId
	FROM [Core].[Lookup] 
	WHERE ParentId=94 and [name] <> 'Draw Fee'

	UNION ALL

	Select   CAST(LookupID as nvarchar(256)) as LookupID,
			Name,
			CONCAT(LookupID,' | ' ,Name) AS DisplayValues,
	       '10005' as ParentId
	FROM [Core].[Lookup] 
	WHERE ParentId=112

	UNION ALL

	SELECT 
	CAST(TagMasterXIRRID as nvarchar(256)) as  LookupID,
	Name,
	CONCAT(TagMasterXIRRID,' | ' ,[Name]) AS DisplayValues,
	'10006' as ParentId
	FROM  [CRE].[TagMasterXIRR]


	--UNION ALL

	--Select CAST(AccountID as nvarchar(256)) as LookupID,
	--		[Text] as [Name],
	--		CONCAT(AccountID,' | ' ,[Text]) AS DisplayValues,
	--       '10006' as ParentId
	--From(
	--	Select acc.AccountID as AccountID,acc.name as [Text] ,'Debt' as [Type]  
	--	from cre.Debt d   
	--	Inner Join core.Account acc on acc.AccountID =  d.AccountID   
	--	where  IsDeleted<> 1   
  
	--	UNION ALL    
  
	--	Select acc.AccountID as AccountID,acc.name as [Text] ,'Equity' as [Type]  
	--	from cre.Equity d   
	--	Inner Join core.Account acc on acc.AccountID =  d.AccountID   
	--	where IsDeleted<> 1 
	--)a

	--UNION ALL

	--SELECT 
	--CAST(TransactionTypesID as nvarchar(256)) as  LookupID,
	--TransactionName as Name,
	--CONCAT(TransactionTypesID,' | ' ,TransactionName) AS DisplayValues,
	--'10007' as ParentId
	--FROM  cre.TransactionTypes


	


	order by ParentId ASC
END



