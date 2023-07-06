CREATE TABLE [CRE].[CalculatorStatistics] (
    [CalculatorStatisticsID] INT              IDENTITY (1, 1) NOT NULL,
    [NoteID]                 NVARCHAR (256)   NULL,
    [CalcProcessTimeInSecs]  DECIMAL (28, 15) NULL,
    [DBProcessTimeInSecs]    DECIMAL (28, 15) NULL,
    [TotalTimeInSecs]        DECIMAL (28, 15) NULL,
    [AnalysisID]             NVARCHAR (256)   NULL,
    [CreatedDate]            DATETIME         NULL,
    CONSTRAINT [PK_CalculatorStatisticsID] PRIMARY KEY CLUSTERED ([CalculatorStatisticsID] ASC)
);

