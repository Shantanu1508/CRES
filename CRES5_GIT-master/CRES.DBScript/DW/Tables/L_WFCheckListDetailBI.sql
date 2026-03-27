CREATE TABLE [DW].[L_WFCheckListDetailBI] (
    [WFCheckListDetailID]          INT            NOT NULL,
    [TaskId]                       NVARCHAR (256) NULL,
    [WFCheckListMasterID]          INT            NULL,
    [CheckListName]                NVARCHAR (256) NULL,
    [CheckListStatus]              INT            NULL,
    [CheckListStatusText]          NVARCHAR (256) NULL,
    [Comment]                      NVARCHAR (MAX) NULL,
    [IsMandatory]                  BIT            NULL,
    [SortOrder]                    INT            NULL,
    [WorkFlowType]                 NVARCHAR (256) NULL,
    [CreatedBy]                    NVARCHAR (256) NULL,
    [CreatedDate]                  DATETIME       NULL,
    [UpdatedBy]                    NVARCHAR (256) NULL,
    [UpdatedDate]                  DATETIME       NULL,
    [L_WFCheckListDetailBI_AutoID] INT            IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_L_WFCheckListDetailBI_AutoID] PRIMARY KEY CLUSTERED ([L_WFCheckListDetailBI_AutoID] ASC)
);



