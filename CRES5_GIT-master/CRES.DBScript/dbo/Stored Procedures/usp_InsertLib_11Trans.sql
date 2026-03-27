CREATE PROCEDURE [dbo].[usp_InsertLib_11Trans]
(
	@tbltype_Lib [TableTypeLib_11Trans] READONLY,
	@EquityName nvarchar(256)
)
AS
BEGIN
	TRUNCATE TABLE [dbo].[Lib_11Trans];
	
	INSERT INTO [dbo].[Lib_11Trans](EquityName,[Deal ID],[Deal Name],[Note ID],[Note Name],[Description],[Date],[Owned],[Transaction Type],[Financing Facility],[Transaction],[Unallocated Subline],[Unallocated Equity],[Subline Balance],[Equity Balance]) 
	SELECT NULLIF(@EquityName            ,'')
	,[DealID]
	,NULLIF([DealName]            ,'')
	,NULLIF([NoteID]			  ,'')
	,NULLIF([NoteName]			  ,'')
	,NULLIF([Description]		  ,'')
	,NULLIF([Date]				  ,'')
	,NULLIF([Owned]				  ,'')
	,NULLIF([TransactionType]	  ,'')
	,NULLIF([FinancingFacility]	  ,'')
	,NULLIF([Transaction]		  ,'')
	,NULLIF([UnallocatedSubline]  ,'')
	,NULLIF([UnallocatedEquity]	  ,'')
	,NULLIF([SublineBalance]	  ,'')
	,NULLIF([EquityBalance] 	  ,'')	
	FROM @tbltype_Lib



	--TRUNCATE TABLE [dbo].['11Tran$']
	
	--INSERT INTO [dbo].['11Tran$']([Deal ID],[Deal Name],[Note ID],[Note Name],[Description],[Date],[Owned],[Transaction Type],[Financing Facility],[Transaction],[Unallocated Subline],[Unallocated Equity],[Subline Balance],[Equity Balance]) 
	--SELECT 
	--NULLIF([Deal ID],'') as [Deal ID]
	--,NULLIF([Deal Name],'') as [Deal Name]
	--,NULLIF([Note ID],'') as [Note ID]
	--,NULLIF([Note Name],'') as [Note Name]
	--,NULLIF([Description],'') as [Description]
	--,NULLIF([Date],'') as [Date]
	--,NULLIF([Owned],'') as [Owned]
	--,NULLIF([Transaction Type],'') as [Transaction Type]
	--,NULLIF([Financing Facility],'') as [Financing Facility]
	--,NULLIF([Transaction],'') as [Transaction]
	--,NULLIF([Unallocated Subline],'') as [Unallocated Subline]
	--,NULLIF([Unallocated Equity],'') as [Unallocated Equity]
	--,NULLIF([Subline Balance],'') as [Subline Balance]
	--,NULLIF([Equity Balance],'') as [Equity Balance]
	--FROM [dbo].[Lib_11Trans]

	


END