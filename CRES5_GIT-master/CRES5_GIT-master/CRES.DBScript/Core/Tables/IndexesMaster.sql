CREATE TABLE [Core].[IndexesMaster] (
    [IndexesMasterID]   INT              IDENTITY (1, 1) NOT NULL,
    [IndexesMasterGuid] UNIQUEIDENTIFIER CONSTRAINT [DF__IndexesMa__Index__4B0D20AB] DEFAULT (newid()) NOT NULL,
    [IndexesName]       NVARCHAR (256)   NULL,
    [Description]       NVARCHAR (256)   NULL,
    [CreatedBy]         NVARCHAR (256)   NULL,
    [CreatedDate]       DATETIME         NULL,
    [UpdatedBy]         NVARCHAR (256)   NULL,
    [UpdatedDate]       DATETIME         NULL,
    CONSTRAINT [PK_IndexesMasterID] PRIMARY KEY CLUSTERED ([IndexesMasterID] ASC)
);

