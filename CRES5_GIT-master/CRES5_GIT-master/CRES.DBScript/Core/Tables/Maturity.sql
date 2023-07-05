CREATE TABLE [Core].[Maturity] (
    [MaturityID]           UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [EventId]              UNIQUEIDENTIFIER NOT NULL,
    [SelectedMaturityDate] DATE             NULL,
    [CreatedBy]            NVARCHAR (256)   NULL,
    [CreatedDate]          DATETIME         NULL,
    [UpdatedBy]            NVARCHAR (256)   NULL,
    [UpdatedDate]          DATETIME         NULL,
    [MaturityAutoID]       INT              IDENTITY (1, 1) NOT NULL,
    [MaturityDate]         DATE             NULL,
    [MaturityType]         INT              NULL,
    [Approved]             INT              NULL,
    [IsAutoApproved]       BIT              NULL,
    CONSTRAINT [PK_MaturityAutoID] PRIMARY KEY CLUSTERED ([MaturityAutoID] ASC),
    CONSTRAINT [FK_MaturityID_EventId] FOREIGN KEY ([EventId]) REFERENCES [Core].[Event] ([EventID])
);


--GO
--ALTER TABLE [Core].[Maturity] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON);




GO
CREATE NONCLUSTERED INDEX [nci_wi_Maturity_C95B262EF6A10313EB581A525994E4AF]
    ON [Core].[Maturity]([EventId] ASC)
    INCLUDE([CreatedBy], [CreatedDate], [SelectedMaturityDate], [UpdatedBy], [UpdatedDate]);

