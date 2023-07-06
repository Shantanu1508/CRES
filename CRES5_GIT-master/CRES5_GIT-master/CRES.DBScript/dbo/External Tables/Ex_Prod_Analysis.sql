CREATE EXTERNAL TABLE [dbo].[Ex_Prod_Analysis] (
    [AnalysisID] UNIQUEIDENTIFIER NOT NULL,
    [Name] VARCHAR (256) NULL,
    [StatusID] INT NULL,
    [Description] VARCHAR (256) NULL,
    [CreatedBy] NVARCHAR (256) NULL,
    [CreatedDate] DATETIME NULL,
    [UpdatedBy] NVARCHAR (256) NULL,
    [UpdatedDate] DATETIME NULL,
    [ScenarioColor] NVARCHAR (256) NULL
)
    WITH (
    DATA_SOURCE = [RemoteReferenceCRESProduction],
    SCHEMA_NAME = N'Core',
    OBJECT_NAME = N'Analysis'
    );

