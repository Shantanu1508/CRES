CREATE TYPE [dbo].[TableTypeActivityLogDetail] AS TABLE (
    [ParentModuleName]        NVARCHAR (256) NULL,  
	[ChildModuleName]        NVARCHAR (256) NULL,
    [ModuleID]		NVARCHAR (256) NULL, 
	[FieldName]        NVARCHAR (256) NULL,
	[FieldValue]        NVARCHAR (256) NULL,
	[Comment]        NVARCHAR (MAX) NULL,
	[CreatedBy]   NVARCHAR (256) NULL
	);