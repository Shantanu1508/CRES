CREATE TYPE [dbo].[TableTypeCalculationRequests] AS TABLE (
    [NoteId]            UNIQUEIDENTIFIER NULL,
    [StatusText]        NVARCHAR (256)   NULL,
    [UserName]          NVARCHAR (256)   NULL,
    [ApplicationText]   NVARCHAR (256)   NULL,
    [PriorityText]      NVARCHAR (256)   NULL,
    [AnalysisID]        NVARCHAR (256)   NULL,
    [CalculationModeID] INT              NULL,
    [CalcType]          INT              NULL);



