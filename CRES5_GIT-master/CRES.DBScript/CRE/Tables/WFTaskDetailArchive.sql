CREATE TABLE [CRE].[WFTaskDetailArchive] (
    [WFTaskDetailArchiveID]    INT            IDENTITY (1, 1) NOT NULL,
    [WFTaskDetailID]           INT            NULL,
    [WFStatusPurposeMappingID] INT            NULL,
    [TaskID]                   NVARCHAR (MAX) NULL,
    [TaskTypeID]               INT            NULL,
    [Comment]                  NVARCHAR (MAX) NULL,
    [SubmitType]               INT            NULL,
    [CreatedBy]                NVARCHAR (256) NULL,
    [CreatedDate]              DATETIME       NULL,
    [UpdatedBy]                NVARCHAR (256) NULL,
    [UpdatedDate]              DATETIME       NULL,
    [IsDeleted]                BIT            CONSTRAINT [DF__WFTaskDet__IsDel__6C6E1476] DEFAULT ((0)) NOT NULL,
    [DelegatedUserID]          NVARCHAR (256) NULL,
    CONSTRAINT [PK_WFTaskDetailArchiveID] PRIMARY KEY CLUSTERED ([WFTaskDetailArchiveID] ASC)
);

