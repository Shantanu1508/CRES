CREATE EXTERNAL TABLE [dbo].[Ex_Prod_WFTaskAdditionalDetail] (
    [WFTaskAdditionalDetailID] INT NOT NULL,
    [TaskID] NVARCHAR (MAX) NULL,
    [SpecialInstruction] NVARCHAR (MAX) NULL,
    [AdditionalComment] NVARCHAR (MAX) NULL,
    [CreatedBy] NVARCHAR (256) NULL,
    [CreatedDate] DATETIME NULL,
    [UpdatedBy] NVARCHAR (256) NULL,
    [UpdatedDate] DATETIME NULL
)
    WITH (
    DATA_SOURCE = [RemoteReferenceCRESProduction],
    SCHEMA_NAME = N'CRE',
    OBJECT_NAME = N'WFTaskAdditionalDetail'
    );

