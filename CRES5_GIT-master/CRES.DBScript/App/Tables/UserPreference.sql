CREATE TABLE [App].[UserPreference] (
	[UserPreferenceID] INT IDENTITY(1,1) NOT NULL,
	[UserID]               UNIQUEIDENTIFIER NULL,   
	ParentModuleName	NVARCHAR (256)   NULL,
	ModuleType	NVARCHAR (256)   NULL,
	ModuleName	NVARCHAR (256)   NULL,
	HTMLTagID	NVARCHAR (256)   NULL,
	IsActive	bit,
	[CreatedBy]            NVARCHAR (256)   NULL,
	[CreatedDate]          DATETIME         NULL,
	[UpdatedBy]            NVARCHAR (256)   NULL,
	[UpdatedDate]          DATETIME         NULL,

    CONSTRAINT [PK_UserPreferenceID] PRIMARY KEY CLUSTERED ([UserPreferenceID] ASC)
);

