-- Procedure
-- Procedure

CREATE PROCEDURE [dbo].[usp_InsertLib_DealLibAdvRate]
(
	@tbltype_Lib [TableTypeLib_DealLibAdvRate] READONLY
)
AS
BEGIN
	TRUNCATE TABLE [dbo].[Lib_DealLibAdvRate];
	
	INSERT INTO [dbo].[Lib_DealLibAdvRate]([CREDealID],[DealName],[Equity],[Facility],[EffDate],[AdvRateFacility],[AdvRateEquity]) 
	SELECT [CREDealID],[DealName],[Equity],[Facility],[EffDate],[AdvRateFacility],[AdvRateEquity] FROM @tbltype_Lib;


	TRUNCATE TABLE [dbo].[DealLibAdvRate$];

	INSERT INTO [dbo].[DealLibAdvRate$]([CREDealID],[DealName],[Equity],[Facility],[EffDate],[AdvRateFacility],[AdvRateEquity]) 
	SELECT 
	 NULLIF([CREDealID]       ,'') as [CREDealID]
	,NULLIF([DealName]		  ,'') as [DealName]
	,NULLIF([Equity]		  ,'') as [Equity]
	,NULLIF([Facility]		  ,'') as [Facility]
	,NULLIF([EffDate]		  ,'') as [EffDate]
	,NULLIF([AdvRateFacility] ,'') as [AdvRateFacility]
	,NULLIF([AdvRateEquity]   ,'') as [AdvRateEquity] 
	FROM [dbo].[Lib_DealLibAdvRate];

END