CREATE TABLE [CRE].[DependentCalcRequest] (
    [DependentCalcRequestID] UNIQUEIDENTIFIER CONSTRAINT [DF__Dependent__Depen__1C1D2798] DEFAULT (newid()) NOT NULL,
    [ParentNoteID]           UNIQUEIDENTIFIER NULL,
    [ChildNoteID]            UNIQUEIDENTIFIER NULL,
    [RequestTime]            DATETIME         NULL,
    [CreatedBy]              NVARCHAR (256)   NULL,
    [CreatedDate]            DATETIME         NULL,
    [UpdatedBy]              NVARCHAR (256)   NULL,
    [UpdatedDate]            DATETIME         NULL,
    CONSTRAINT [PK_DependentCalcRequestID] PRIMARY KEY CLUSTERED ([DependentCalcRequestID] ASC)
);

