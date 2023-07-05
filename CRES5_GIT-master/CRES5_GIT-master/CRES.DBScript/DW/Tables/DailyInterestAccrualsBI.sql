CREATE TABLE [DW].[DailyInterestAccrualsBI] (
    [DailyInterestAccrualsID]   INT              NOT NULL,
    [DailyInterestAccrualsGUID] UNIQUEIDENTIFIER NOT NULL,
    [NoteID]                    UNIQUEIDENTIFIER NULL,
    [Date]                      DATETIME         NULL,
    [DailyInterestAccrual]      DECIMAL (28, 15) NULL,
    [AnalysisID]                UNIQUEIDENTIFIER NULL,
    [CRENoteID]                 NVARCHAR (256)   NULL,
    [AnalysisName]              NVARCHAR (256)   NULL,
    [CreatedBy]                 NVARCHAR (256)   NULL,
    [CreatedDate]               DATETIME         NULL,
    [UpdatedBy]                 NVARCHAR (256)   NULL,
    [UpdatedDate]               DATETIME         NULL
);

