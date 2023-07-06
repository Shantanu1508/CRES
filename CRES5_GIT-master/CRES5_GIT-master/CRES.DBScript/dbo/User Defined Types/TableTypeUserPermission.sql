CREATE TYPE [dbo].[TableTypeUserPermission] AS TABLE (
    [RoleID]            UNIQUEIDENTIFIER NULL,
    [ModuleTabMasterID] INT              NULL,
    [IsEdit]            BIT              NULL,
    [IsView]            BIT              NULL,
    [IsDelete]          BIT              NULL);

