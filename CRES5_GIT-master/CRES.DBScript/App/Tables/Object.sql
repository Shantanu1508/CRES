CREATE TABLE [App].[Object] (
    [ObjectID]            UNIQUEIDENTIFIER NULL,
    [ObjectName]          VARCHAR (128)    NULL,
    [ObjectTypeID]        INT              NULL,
    [StatusID]            INT              NULL,
    [Object_ObjectAutoID] UNIQUEIDENTIFIER NULL,
    [CreatedBy]           NVARCHAR (256)   NULL,
    [CreatedDate]         DATETIME         NULL,
    [UpdatedBy]           NVARCHAR (256)   NULL,
    [UpdatedDate]         DATETIME         NULL,
    [ObjectAutoID]        UNIQUEIDENTIFIER CONSTRAINT [DF__Object__ObjectAu__60A75C0F] DEFAULT (newid()) NOT NULL,
    CONSTRAINT [PK_ObjectAutoID] PRIMARY KEY CLUSTERED ([ObjectAutoID] ASC),
    CONSTRAINT [PK_Object_Object_ObjectID] FOREIGN KEY ([Object_ObjectAutoID]) REFERENCES [App].[Object] ([ObjectAutoID])
);


GO
CREATE NONCLUSTERED INDEX [IX_Object_Object_ObjectAutoID]
    ON [App].[Object]([Object_ObjectAutoID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Object_ObjectID]
    ON [App].[Object]([ObjectID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Object_ObjectTypeID]
    ON [App].[Object]([ObjectTypeID] ASC)
    INCLUDE([ObjectID]);

