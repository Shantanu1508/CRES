CREATE TABLE [Core].[Exceptions] (
    [ExceptionID]      UNIQUEIDENTIFIER CONSTRAINT [DF__Exception__Excep__32767D0B] DEFAULT (newid()) NOT NULL,
    [ObjectID]         UNIQUEIDENTIFIER NOT NULL,
    [ObjectTypeID]     INT              NOT NULL,
    [FieldName]        NVARCHAR (256)   NULL,
    [Summary]          NVARCHAR (MAX)   NULL,
    [ActionLevelID]    INT              NULL,
    [CreatedBy]        NVARCHAR (256)   NULL,
    [CreatedDate]      DATETIME         NULL,
    [UpdatedBy]        NVARCHAR (256)   NULL,
    [UpdatedDate]      DATETIME         NULL,
    [ExceptionsAutoID] INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_Exception] PRIMARY KEY CLUSTERED ([ExceptionID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_Exceptions_ActionLevelID]
    ON [Core].[Exceptions]([ActionLevelID] ASC)
    INCLUDE([ObjectID]);


GO
CREATE NONCLUSTERED INDEX [IX_Exceptions_ObjectID]
    ON [Core].[Exceptions]([ObjectID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Exceptions_ObjectID_ActionLevelID]
    ON [Core].[Exceptions]([ObjectID] ASC, [ActionLevelID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Exceptions_ObjectID_ObjectTypeID]
    ON [Core].[Exceptions]([ObjectID] ASC, [ObjectTypeID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Exceptions_ObjectID_ObjectTypeID_ActionLevelID]
    ON [Core].[Exceptions]([ObjectID] ASC, [ObjectTypeID] ASC, [ActionLevelID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Exceptions_ObjectTypeID_FieldName]
    ON [Core].[Exceptions]([ObjectTypeID] ASC, [FieldName] ASC)
    INCLUDE([ObjectID], [ExceptionsAutoID]);

