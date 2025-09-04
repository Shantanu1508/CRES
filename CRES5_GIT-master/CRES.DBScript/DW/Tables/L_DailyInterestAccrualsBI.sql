CREATE TABLE [DW].[L_DailyInterestAccrualsBI] (
    [DailyInterestAccrualsID]          INT              NOT NULL,
    [DailyInterestAccrualsGUID]        UNIQUEIDENTIFIER NOT NULL,
    [NoteID]                           UNIQUEIDENTIFIER NOT NULL,
    [Date]                             DATETIME         NULL,
    [DailyInterestAccrual]             DECIMAL (28, 15) NULL,
    [AnalysisID]                       UNIQUEIDENTIFIER NULL,
    [CRENoteID]                        NVARCHAR (256)   NULL,
    [AnalysisName]                     NVARCHAR (256)   NULL,
    [CreatedBy]                        NVARCHAR (256)   NULL,
    [CreatedDate]                      DATETIME         NULL,
    [UpdatedBy]                        NVARCHAR (256)   NULL,
    [UpdatedDate]                      DATETIME         NULL,
    [L_DailyInterestAccrualsBI_AutoID] INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_L_DailyInterestAccrualsBI_AutoID] PRIMARY KEY CLUSTERED ([L_DailyInterestAccrualsBI_AutoID] ASC)
);



