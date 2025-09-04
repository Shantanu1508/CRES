CREATE TABLE [DW].[AdjustmentComments] (
    [dealid]                    UNIQUEIDENTIFIER NULL,
    [credealid]                 NVARCHAR (256)   NULL,
    [noteid]                    UNIQUEIDENTIFIER NULL,
    [NoteId_F]                  NVARCHAR (256)   NULL,
    [AdjustmentDate]            DATE             NULL,
    [Type]                      NVARCHAR (256)   NULL,
    [AdjustmentAmount]          DECIMAL (28, 15) NULL,
    [AdjustmentComment]         NVARCHAR (MAX)   NULL,
    [ClosingDate]               DATE             NULL,
    [AdjustmentComments_AutoID] INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_AdjustmentComments_AutoID] PRIMARY KEY CLUSTERED ([AdjustmentComments_AutoID] ASC)
);



