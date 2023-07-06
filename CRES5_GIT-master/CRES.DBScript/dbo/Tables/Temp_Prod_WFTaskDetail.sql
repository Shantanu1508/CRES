CREATE TABLE [dbo].[Temp_Prod_WFTaskDetail] (
    [WFTaskDetailID]           INT            NOT NULL,
    [WFStatusPurposeMappingID] INT            NULL,
    [TaskID]                   NVARCHAR (MAX) NULL,
    [TaskTypeID]               INT            NULL,
    [Comment]                  NVARCHAR (MAX) NULL,
    [SubmitType]               INT            NULL,
    [CreatedBy]                NVARCHAR (256) NULL,
    [CreatedDate]              DATETIME       NULL,
    [UpdatedBy]                NVARCHAR (256) NULL,
    [UpdatedDate]              DATETIME       NULL,
    [IsDeleted]                BIT            NOT NULL,
    [ShardName]                NVARCHAR (256) NULL
);

