CREATE TABLE [Core].[LookupParentMapping] (
    [LookupParentMappingID] UNIQUEIDENTIFIER CONSTRAINT [DF__LookupPar__Looku__22401542] DEFAULT (newid()) NOT NULL,
    [ParentID]              INT              NULL,
    [LookupType]            NVARCHAR (256)   NULL,
    [IsVisisble]            BIT              NULL,
    [CreatedBy]             NVARCHAR (256)   NULL,
    [CreatedDate]           DATETIME         NULL,
    [UpdatedBy]             NVARCHAR (256)   NULL,
    [UpdatedDate]           DATETIME         NULL,
    CONSTRAINT [PK_LookupParentMappingID] PRIMARY KEY CLUSTERED ([LookupParentMappingID] ASC)
);

