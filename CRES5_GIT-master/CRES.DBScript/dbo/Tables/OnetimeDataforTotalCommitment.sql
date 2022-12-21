CREATE TABLE [dbo].[OnetimeDataforTotalCommitment] (
    [dealid]            UNIQUEIDENTIFIER NULL,
    [credealid]         NVARCHAR (256)   NULL,
    [noteid]            UNIQUEIDENTIFIER NULL,
    [NoteId_F]          NVARCHAR (256)   NULL,
    [AdjustmentDate]    DATE             NULL,
    [Type]              NVARCHAR (256)   NULL,
    [AdjustmentAmount]  DECIMAL (28, 15) NULL,
    [AdjustmentComment] NVARCHAR (MAX)   NULL,
    [ClosingDate]       DATE             NULL,
    [Flag]              NVARCHAR (256)   NULL
);

