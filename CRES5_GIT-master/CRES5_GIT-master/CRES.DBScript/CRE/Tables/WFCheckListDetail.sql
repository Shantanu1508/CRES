CREATE TABLE [CRE].[WFCheckListDetail] (
    [WFCheckListDetailID] INT            IDENTITY (1, 1) NOT NULL,    
    [TaskId]              NVARCHAR (MAX) NULL,
    [WFCheckListMasterID] INT            NULL,
    [CheckListName]       NVARCHAR (256) NULL,
    [CheckListStatus]     INT            NULL,
    [Comment]             NVARCHAR (MAX) NULL,
    [CreatedBy]           NVARCHAR (256) NULL,
    [CreatedDate]         DATETIME       NULL,
    [UpdatedBy]           NVARCHAR (256) NULL,
    [UpdatedDate]         DATETIME       NULL,
    [TaskTypeID]              INT NULL,
    [IsDeleted]                BIT     DEFAULT ((0)) NULL,
    CONSTRAINT [PK_WFCheckListDetailID] PRIMARY KEY CLUSTERED ([WFCheckListDetailID] ASC)
);

