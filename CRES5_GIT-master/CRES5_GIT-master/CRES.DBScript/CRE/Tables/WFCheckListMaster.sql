CREATE TABLE [CRE].[WFCheckListMaster] (
    [WFCheckListMasterID] INT            IDENTITY (1, 1) NOT NULL,
    [CheckListName]       NVARCHAR (256) NULL,
    [IsMandatory]         BIT            NULL,
    [CreatedBy]           NVARCHAR (256) NULL,
    [CreatedDate]         DATETIME       NULL,
    [UpdatedBy]           NVARCHAR (256) NULL,
    [UpdatedDate]         DATETIME       NULL,
    [SortOrder]           INT            NULL,
    [WorkFlowType]        NVARCHAR (256) NULL,
    CONSTRAINT [PK_WFCheckListMasterID] PRIMARY KEY CLUSTERED ([WFCheckListMasterID] ASC)
);

