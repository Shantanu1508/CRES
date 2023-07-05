CREATE TABLE [Core].[FeeCouponStripReceivable] (
    [FeeCouponStripReceivableID]     UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [EventId]                        UNIQUEIDENTIFIER NOT NULL,
    [Date]                           DATE             NULL,
    [Value]                          DECIMAL (28, 15) NULL,
    [CreatedBy]                      NVARCHAR (256)   NULL,
    [CreatedDate]                    DATETIME         NULL,
    [UpdatedBy]                      NVARCHAR (256)   NULL,
    [UpdatedDate]                    DATETIME         NULL,
    [SourceNoteId]                   UNIQUEIDENTIFIER NULL,
    [StrippedAmount]                 DECIMAL (28, 15) NULL,
    [RuleTypeID]                     INT              NULL,
    [FeeName]                        NVARCHAR (256)   NULL,
    [AnalysisID]                     UNIQUEIDENTIFIER NULL,
    [FeeCouponStripReceivableAutoID] INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_FeeCouponStripReceivableAutoID] PRIMARY KEY CLUSTERED ([FeeCouponStripReceivableAutoID] ASC),
    CONSTRAINT [FK_FeeCouponStripReceivable_EventId] FOREIGN KEY ([EventId]) REFERENCES [Core].[Event] ([EventID])
);


GO
CREATE NONCLUSTERED INDEX [nci_wi_FeeCouponStripReceivable_EF86B3C47E3B66EC64E4BDE9CFC73E8A]
    ON [Core].[FeeCouponStripReceivable]([EventId] ASC, [AnalysisID] ASC)
    INCLUDE([CreatedBy], [CreatedDate], [Date], [FeeName], [RuleTypeID], [SourceNoteId], [StrippedAmount], [UpdatedBy], [UpdatedDate], [Value]);

