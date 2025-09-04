CREATE TYPE [dbo].[TableTypeLiabilityCalcRequests] AS TABLE (
    [AccountId]            UNIQUEIDENTIFIER NULL,
    [StatusText]        NVARCHAR (256)   NULL,
    [UserName]          NVARCHAR (256)   NULL,
    [PriorityText]      NVARCHAR (256)   NULL,
    [AnalysisID]        NVARCHAR (256)   NULL,
    [CalcType]          INT              NULL);