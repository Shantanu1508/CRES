CREATE TABLE [App].[ActivityLogDetail] (
    [ActivityLogDetailID]    INT            IDENTITY (1, 1) NOT NULL,    
	[ActivityLogDetailGUID]    UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
	[ParentModuleName]        NVARCHAR (256) NULL,  
	[ChildModuleName]        NVARCHAR (256) NULL,
    [ModuleID]		NVARCHAR (256) NULL, 
	[FieldName]        NVARCHAR (256) NULL,
	[FieldValue]        NVARCHAR (256) NULL,
	[Comment]        NVARCHAR (MAX) NULL,
	[CreatedBy]   NVARCHAR (256) NULL,
    [CreatedDate] DATETIME       NULL,

    CONSTRAINT [PK_ActivityLogDetailID] PRIMARY KEY CLUSTERED ([ActivityLogDetailID] ASC)
);