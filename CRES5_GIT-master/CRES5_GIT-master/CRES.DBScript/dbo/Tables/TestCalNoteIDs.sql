CREATE TABLE [dbo].[TestCalNoteIDs] (
    [TestCalNoteID]        INT              IDENTITY (1, 1) NOT NULL,
    [NoteID]               UNIQUEIDENTIFIER NULL,
    [RequestTime]          DATETIME         NULL,
    [CalculationRequestID] UNIQUEIDENTIFIER NULL,
    [UserName]             NVARCHAR (MAX)   NULL,
    [IsRealTime]           BIT              NULL,
    [AnalysisID]           UNIQUEIDENTIFIER NULL,
    [CalculationModeID]    INT              NULL,
    [CalculationModeText]  VARCHAR (1000)   NULL,
    [ServerIndex]          INT              NULL,
    [CalcBatch]            UNIQUEIDENTIFIER NULL,
    PRIMARY KEY CLUSTERED ([TestCalNoteID] ASC)
);

