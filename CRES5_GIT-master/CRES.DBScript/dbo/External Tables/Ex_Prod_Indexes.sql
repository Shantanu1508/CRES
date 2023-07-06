CREATE EXTERNAL TABLE [dbo].[Ex_Prod_Indexes] (
    [IndexesId] UNIQUEIDENTIFIER NOT NULL,
    [AnalysisID] UNIQUEIDENTIFIER NULL,
    [Date] DATE NULL,
    [IndexType] INT NULL,
    [Value] DECIMAL (28, 15) NULL,
    [CreatedBy] NVARCHAR (256) NULL,
    [CreatedDate] DATETIME NULL,
    [UpdatedBy] NVARCHAR (256) NULL,
    [UpdatedDate] DATETIME NULL
)
    WITH (
    DATA_SOURCE = [RemoteReferenceCRESProduction],
    SCHEMA_NAME = N'CORE',
    OBJECT_NAME = N'Indexes'
    );

