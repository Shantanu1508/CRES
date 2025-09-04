CREATE TABLE [CRE].[XIRRConfig] (
    [XIRRConfigID]               INT              IDENTITY (1, 1) NOT NULL,
    [XIRRConfigGUID]             UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [ReturnName]                 NVARCHAR (256)   NULL,
    [Type]                       NVARCHAR (256)   NULL,
    [AnalysisID]                 UNIQUEIDENTIFIER NULL,
    [CreatedBy]                  NVARCHAR (256)   NULL,
    [CreatedDate]                DATETIME         NULL,
    [UpdatedBy]                  NVARCHAR (256)   NULL,
    [UpdatedDate]                DATETIME         NULL,
    [Comments]                   NVARCHAR (MAX)   NULL,
    [RowNumber]                  INT              NULL,
    [Group1]                     INT              NULL,
    [Group2]                     INT              NULL,
    [ReferencingDealLevelReturn] INT              NULL,
    [UpdateXIRRLinkedDeal]       INT              NULL,
    [ArchivalRequirement]        INT              NULL,
    [FileName_Output]            NVARCHAR (256)   NULL,
    [FileName_Input]             NVARCHAR (256)   NULL,
    [isSystemGenerated]          BIT              NULL,
    [CutoffRelativeDateID]       INT              NULL,
    [CutoffDateOverride]         DATE             NULL,
    [ShowReturnonDealScreen]     INT              NULL,
    [isAllowDelete]              BIT              NULL,
	[finsrcforwholeloaninvcalc]  NVARCHAR (256)   NULL,
    CONSTRAINT [PK_XIRRConfigID] PRIMARY KEY CLUSTERED ([XIRRConfigID] ASC)
);
GO

