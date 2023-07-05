CREATE TYPE [dbo].[tblType_CheckListDetail] AS TABLE (
    [WFCheckListDetailID] INT            NULL,
    [TaskId]              NVARCHAR (MAX) NULL,
    [WFCheckListMasterID] INT            NULL,
    [CheckListName]       NVARCHAR (256) NULL,
    [CheckListStatus]     INT            NULL,
    [Comment]             NVARCHAR (MAX) NULL);

