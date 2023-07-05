CREATE TABLE [App].[StatesMaster] (
    [StatesID]    INT IDENTITY (1, 1) NOT NULL,
	[CountryName] nvarchar(256)  null,
    [StatesName]   Nvarchar(256)  NULL,
	[StatesAbbreviation] Nvarchar(256) null,
    [CreatedBy]   NVARCHAR (256) NULL,
    [CreatedDate] DATETIME       NULL,
    [UpdatedBy]   NVARCHAR (256) NULL,
    [UpdatedDate] DATETIME       NULL,
    CONSTRAINT [PK_StatesID] PRIMARY KEY CLUSTERED ([StatesID] ASC)
);
