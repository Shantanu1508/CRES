CREATE TYPE [dbo].[tblnoteruletypesetup] AS TABLE (
    [AnalysisID]       UNIQUEIDENTIFIER NULL,
    [NoteID]           UNIQUEIDENTIFIER NULL,
    [RuleTypeMasterID] INT              NULL,
    [RuleTypeDetailID] INT              NULL);
GO

