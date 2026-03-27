-- Procedure
-- Procedure

CREATE PROCEDURE [dbo].[usp_InsertLib_DealLiability]
(
	@tbltype_Lib [TableTypeLib_DealLiability] READONLY
)
AS
BEGIN
	TRUNCATE TABLE [dbo].[Lib_DealLiability];
	
	INSERT INTO [dbo].[Lib_DealLiability]([CREDealID],[DealName],[CRENoteID],[Name],[Structure],[Equity],[Facility]) 
	SELECT [CREDealID],[DealName],[CRENoteID],[Name],[Structure],[Equity],[Facility] FROM @tbltype_Lib;


	TRUNCATE TABLE [dbo].[DealLiability$];

	INSERT INTO [dbo].[DealLiability$]([CREDealID],[DealName],[CRENoteID],[Name],[Structure],[Equity],[Facility]) 
	SELECT 
	 NULLIF([CREDealID] ,'')  as [CREDealID]
	,NULLIF([DealName]	,'') as [DealName]
	,NULLIF([CRENoteID] ,'') as [CRENoteID]
	,NULLIF([Name]		,'') as [Name]
	,NULLIF([Structure] ,'') as [Structure]
	,NULLIF([Equity]	,'') as [Equity]
	,NULLIF([Facility]  ,'') as [Facility] 
	FROM [dbo].[Lib_DealLiability]

END