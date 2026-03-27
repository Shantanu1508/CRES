---drop PROCEDURE [dbo].[usp_InsertUpdateXIRRConfig]   

CREATE TYPE [dbo].[tblTypeXIRRConfig] AS TABLE (
    [XIRRConfigID]  INT NULL,
	[ReturnName] Nvarchar(256) NULL,
	[Type] Nvarchar(100) NULL,
	[AnalysisID] UNIQUEIDENTIFIER NULL,	
	[Comments]    NVARCHAR (MAX) NULL,
	[Group1] INT NULL,
	[Group2] INT NULL,
	[ArchivalRequirement] int NULL,
	[ReferencingDealLevelReturn] NVARCHAR (MAX) NULL,
	[UpdateXIRRLinkedDeal] int
	);