CREATE TABLE [Core].[Period] (
    [PeriodID]      UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Name]          VARCHAR (256)    NULL,
    [StartDate]     DATE             NULL,
    [EndDate]       DATE             NULL,
    [StatusID]      INT              NULL,
    [CreatedBy]     NVARCHAR (256)   NULL,
    [CreatedDate]   DATETIME         NULL,
    [UpdatedBy]     NVARCHAR (256)   NULL,
    [UpdatedDate]   DATETIME         NULL,
    [AzureBlobLink] NVARCHAR (MAX)   NULL,
    [PeriodAutoID]  INT              IDENTITY (1, 1) NOT NULL,
    [AnalysisID]    UNIQUEIDENTIFIER NULL,
    [IsDeleted]     INT              CONSTRAINT [DF__Period__IsDelete__36B12243] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_PeriodID] PRIMARY KEY CLUSTERED ([PeriodID] ASC)
);

