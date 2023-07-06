CREATE TABLE [CRE].[WFTaskDetail] (
    [WFTaskDetailID]           INT            IDENTITY (1, 1) NOT NULL,
    [WFStatusPurposeMappingID] INT            NULL,
    [TaskID]                   NVARCHAR (MAX) NULL,
    [TaskTypeID]               INT            NULL,
    [Comment]                  NVARCHAR (MAX) NULL,
    [SubmitType]               INT            NULL,
    [CreatedBy]                NVARCHAR (256) NULL,
    [CreatedDate]              DATETIME       NULL,
    [UpdatedBy]                NVARCHAR (256) NULL,
    [UpdatedDate]              DATETIME       NULL,
    [IsDeleted]                BIT            CONSTRAINT [DF__WFTaskDet__IsDel__436BFEE3] DEFAULT ((0)) NOT NULL,
    [DelegatedUserID]          NVARCHAR (256) NULL,
    CONSTRAINT [PK_WFTaskDetailID] PRIMARY KEY CLUSTERED ([WFTaskDetailID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_WFTaskDetail_WFStatusPurposeMappingID]
    ON [CRE].[WFTaskDetail]([WFStatusPurposeMappingID] ASC)
    INCLUDE([TaskID]);

