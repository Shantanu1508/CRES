CREATE TABLE [CRE].[TagMaster] (
    [TagMasterID] UNIQUEIDENTIFIER CONSTRAINT [DF__TagMaster__TagMa__7132C993] DEFAULT (newid()) NOT NULL,
    [TagName]     NVARCHAR (256)   NULL,
    [TagDesc]     NVARCHAR (256)   NULL,
    [CreatedBy]   NVARCHAR (256)   NULL,
    [CreatedDate] DATETIME         NULL,
    [UpdatedBy]   NVARCHAR (256)   NULL,
    [UpdatedDate] DATETIME         NULL,
    [AnalysisID]  UNIQUEIDENTIFIER NULL,
    [StatusID]    INT              CONSTRAINT [DF__TagMaster__Statu__7226EDCC] DEFAULT ((1)) NOT NULL,
    [PeriodID]    UNIQUEIDENTIFIER NULL,
    [IsDeleted]   INT              CONSTRAINT [DF__TagMaster__IsDel__731B1205] DEFAULT ((0)) NOT NULL,
    [TagFileName] NVARCHAR (256)   NULL,
    CONSTRAINT [PK_TagMasterID] PRIMARY KEY CLUSTERED ([TagMasterID] ASC)
);

