---drop PROCEDURE [dbo].[usp_InsertUpdateXIRRConfig] 
CREATE TYPE [dbo].[tblTypeXIRRConfigDetail] AS TABLE (
	[XIRRConfigID]  INT NULL,	
	[ObjectType] Nvarchar(100) NULL,
	[ObjectID] INT NULL
);