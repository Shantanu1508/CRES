CREATE TABLE [dbo].[Temp_Prod_WFCheckListDetail] (
    [WFCheckListDetailID] INT            NOT NULL,
    [TaskId]              NVARCHAR (MAX) NULL,
    [WFCheckListMasterID] INT            NULL,
    [CheckListName]       NVARCHAR (256) NULL,
    [CheckListStatus]     INT            NULL,
    [Comment]             NVARCHAR (MAX) NULL,
    [CreatedBy]           NVARCHAR (256) NULL,
    [CreatedDate]         DATETIME       NULL,
    [UpdatedBy]           NVARCHAR (256) NULL,
    [UpdatedDate]         DATETIME       NULL,
    [ShardName]           NVARCHAR (256) NULL
);

