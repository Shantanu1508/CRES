CREATE TYPE [dbo].[TableTypeCalculationRequestsLiability] AS TABLE (
    [AnalysisID]        NVARCHAR (256)   NULL,
    [AccountId]            UNIQUEIDENTIFIER NULL,
    [CalcEngineType] INT              NULL,
    [CalcType]          INT              NULL,
    [UserName]          NVARCHAR (256)   NULL,
    [StatusText]        NVARCHAR (256)   NULL
   );
