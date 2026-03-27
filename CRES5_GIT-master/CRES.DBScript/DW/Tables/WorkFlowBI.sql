CREATE TABLE [DW].[WorkFlowBI] (
    [dealid]                   UNIQUEIDENTIFIER NULL,
    [dealfundingid]            UNIQUEIDENTIFIER NULL,
    [CREDealID]                NVARCHAR (256)   NULL,
    [DealName]                 NVARCHAR (256)   NULL,
    [Deadline]                 DATE             NULL,
    [Fundingdate]              DATE             NULL,
    [Amount]                   DECIMAL (28, 15) NULL,
    [StatusName]               NVARCHAR (256)   NULL,
    [Username]                 NVARCHAR (256)   NULL,
    [wf_isAllow]               INT              NULL,
    [UpdatedDate]              DATETIME         NULL,
    [WorkFlowComment]          NVARCHAR (MAX)   NULL,
    [PurposeIDText]            NVARCHAR (256)   NULL,
    [Applied]                  BIT              NULL,
    [dealfunComment]           NVARCHAR (MAX)   NULL,
    [DrawFundingID]            NVARCHAR (256)   NULL,
    [WFTaskDetailID]           INT              NULL,
    [TaskID]                   UNIQUEIDENTIFIER NULL,
    [TaskTypeID]               INT              NULL,
    [SubmitType]               INT              NULL,
    [WFStatusPurposeMappingID] INT              NULL,
    [PurposeTypeId]            INT              NULL,
    [OrderIndex]               INT              NULL,
    [WFStatusMasterID]         INT              NULL,
    [TaskTypeIDText]           NVARCHAR (256)   NULL,
    [SubmitTypeText]           NVARCHAR (256)   NULL,
    [PurposeID]                INT              NULL,
    [GeneratedBy]              INT              NULL,
    [GeneratedByBI]            NVARCHAR (100)   NULL,
    [WorkFlowBI_AutoID]        INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_WorkFlowBI_AutoID] PRIMARY KEY CLUSTERED ([WorkFlowBI_AutoID] ASC)
);




GO
CREATE NONCLUSTERED INDEX [iWorkFlowBI_CREDealID]
    ON [DW].[WorkFlowBI]([CREDealID] ASC);

