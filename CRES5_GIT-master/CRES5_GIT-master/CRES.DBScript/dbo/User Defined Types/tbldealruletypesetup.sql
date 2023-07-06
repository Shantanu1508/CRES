CREATE TYPE [dbo].[tbldealruletypesetup] AS TABLE (
    [AnalysisID]       UNIQUEIDENTIFIER NULL,
    [DealID]           UNIQUEIDENTIFIER NULL,
    [RuleTypeMasterID] INT              NULL,
    [RuleTypeDetailID] INT              NULL);
GO

