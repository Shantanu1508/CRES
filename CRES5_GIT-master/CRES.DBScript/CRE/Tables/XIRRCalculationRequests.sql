CREATE TABLE [CRE].[XIRRCalculationRequests] (
    [XIRRCalculationRequestsID] INT              IDENTITY (1, 1) NOT NULL,
    [XIRRConfigID]              INT              NULL,
    [Status]                    INT              NULL,
    [StartTime]                 DATETIME         NULL,
    [EndTime]                   DATETIME         NULL,
    [ErrorMessage]              NVARCHAR (256)   NULL,
    [AnalysisID]                UNIQUEIDENTIFIER NULL,
    [CreatedBy]                 NVARCHAR (256)   NULL,
    [CreatedDate]               DATETIME         NULL,
    [UpdatedBy]                 NVARCHAR (256)   NULL,
    [UpdatedDate]               DATETIME         NULL,
    [RequestTime]               DATETIME         NULL,
    [XIRRReturnGroupID]         INT              NULL,
    [Type]                      NVARCHAR (256)   NULL,
    [DealAccountID]             UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_XIRRCalculationRequestsID] PRIMARY KEY CLUSTERED ([XIRRCalculationRequestsID] ASC),
    CONSTRAINT [FK_XIRRCalculationRequests_XIRRConfigID] FOREIGN KEY ([XIRRConfigID]) REFERENCES [CRE].[XIRRConfig] ([XIRRConfigID])
);
GO

