CREATE TABLE [Core].[Register] (
    [RegisterID]  UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [AccountID]   UNIQUEIDENTIFIER NOT NULL,
    [AnalysisID]  UNIQUEIDENTIFIER NULL,
    [Name]        VARCHAR (256)    NULL,
    [StatusID]    INT              NULL,
    [CreatedBy]   NVARCHAR (256)   NULL,
    [CreatedDate] DATETIME         NULL,
    [UpdatedBy]   NVARCHAR (256)   NULL,
    [UpdatedDate] DATETIME         NULL,
    CONSTRAINT [PK_RegisterID] PRIMARY KEY CLUSTERED ([RegisterID] ASC),
    CONSTRAINT [FK_Register_AccountID] FOREIGN KEY ([AccountID]) REFERENCES [Core].[Account] ([AccountID]),
    CONSTRAINT [FK_Register_AnalysisID] FOREIGN KEY ([AnalysisID]) REFERENCES [Core].[Analysis] ([AnalysisID])
);

