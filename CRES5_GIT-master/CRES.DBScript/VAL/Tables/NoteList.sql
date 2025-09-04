CREATE TABLE [VAL].[NoteList] (
    [NoteListID]                  INT              IDENTITY (1, 1) NOT NULL,
    [NoteID]                      NVARCHAR (256)   NULL,
    [NoteNominalDMOrPriceForMark] DECIMAL (28, 15) NULL,
    [CreatedBy]                   NVARCHAR (256)   NULL,
    [CreatedDate]                 DATETIME         NULL,
    [UpdateBy]                    NVARCHAR (256)   NULL,
    [UpdatedDate]                 DATETIME         NULL,
    [CREDealName]                 NVARCHAR (256)   NULL,
    [MarkedDateMasterID]          INT              NULL,
    [CREDealID]                   NVARCHAR (256)   NULL,
    CONSTRAINT [PK_NoteList_NoteListID] PRIMARY KEY CLUSTERED ([NoteListID] ASC),
    CONSTRAINT [FK_NoteList_MarkedDateMasterID] FOREIGN KEY ([MarkedDateMasterID]) REFERENCES [VAL].[MarkedDateMaster] ([MarkedDateMasterID])
);
GO

