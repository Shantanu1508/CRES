CREATE EXTERNAL TABLE [dbo].[Ex_Prod_WFTaskDetailArchive] (
    [WFTaskDetailArchiveID] INT NOT NULL,
    [WFTaskDetailID] INT NULL,
    [WFStatusPurposeMappingID] INT NULL,
    [TaskID] NVARCHAR (MAX) NULL,
    [TaskTypeID] INT NULL,
    [Comment] NVARCHAR (MAX) NULL,
    [SubmitType] INT NULL,
    [CreatedBy] NVARCHAR (256) NULL,
    [CreatedDate] DATETIME NULL,
    [UpdatedBy] NVARCHAR (256) NULL,
    [UpdatedDate] DATETIME NULL,
    [IsDeleted] BIT NOT NULL
)
    WITH (
    DATA_SOURCE = [RemoteReferenceCRESProduction],
    SCHEMA_NAME = N'CRE',
    OBJECT_NAME = N'WFTaskDetailArchive'
    );

