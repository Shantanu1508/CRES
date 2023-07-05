CREATE EXTERNAL TABLE [dbo].[Ex_Prod_Event] (
    [EventID] UNIQUEIDENTIFIER NULL,
    [AccountID] UNIQUEIDENTIFIER NULL,
    [Date] DATE NULL,
    [EventTypeID] INT NULL,
    [EffectiveStartDate] DATE NULL,
    [EffectiveEndDate] DATE NULL,
    [SingleEventValue] DECIMAL (28, 15) NULL,
    [StatusID] INT NULL,
    [CreatedBy] NVARCHAR (256) NULL,
    [CreatedDate] DATETIME NULL,
    [UpdatedBy] NVARCHAR (256) NULL,
    [UpdatedDate] DATETIME NULL
)
    WITH (
    DATA_SOURCE = [RemoteReferenceCRESProduction],
    SCHEMA_NAME = N'CORE',
    OBJECT_NAME = N'EVENT'
    );

