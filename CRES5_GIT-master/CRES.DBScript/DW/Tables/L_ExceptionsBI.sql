CREATE TABLE [DW].[L_ExceptionsBI] (
    [ExceptionID]           UNIQUEIDENTIFIER NOT NULL,
    [ObjectID]              UNIQUEIDENTIFIER NOT NULL,
    [ObjectTypeID]          INT              NOT NULL,
    [ObjectTypeBI]          NVARCHAR (180)   NULL,
    [FieldName]             NVARCHAR (256)   NULL,
    [Summary]               NVARCHAR (MAX)   NULL,
    [ActionLevelID]         INT              NULL,
    [ActionLevelBI]         NVARCHAR (180)   NULL,
    [CreatedBy]             NVARCHAR (256)   NULL,
    [CreatedDate]           DATETIME         NULL,
    [UpdatedBy]             NVARCHAR (256)   NULL,
    [UpdatedDate]           DATETIME         NULL,
    [L_ExceptionsBI_AutoID] INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_L_ExceptionsBI_AutoID] PRIMARY KEY CLUSTERED ([L_ExceptionsBI_AutoID] ASC)
);



