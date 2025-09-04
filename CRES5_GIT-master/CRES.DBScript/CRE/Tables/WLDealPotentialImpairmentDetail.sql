CREATE TABLE [CRE].[WLDealPotentialImpairmentDetail]
(
	[WLDealPotentialImpairmentDetailID] Int IDENTITY (1, 1) NOT NULL,
	[WLDealPotentialImpairmentMasterID] Int NOT NULL,
	[NoteID] UNIQUEIDENTIFIER NOT NULL,
	[Value]        decimal(28,15) NULL,
	[CreatedBy]          NVARCHAR (256)   NULL,
    [CreatedDate]        DATETIME         NULL,
    [UpdatedBy]          NVARCHAR (256)   NULL,
    [UpdatedDate]        DATETIME         NULL,
	[RowNo]              INT      NULL
	CONSTRAINT [PK_WLDealPotentialImpairmentDetailID] PRIMARY KEY CLUSTERED ([WLDealPotentialImpairmentDetailID] ASC),
	CONSTRAINT [FK_WLDealPotentialImpairmentMasterID] FOREIGN KEY ([WLDealPotentialImpairmentMasterID]) REFERENCES [CRE].[WLDealPotentialImpairmentMaster] ([WLDealPotentialImpairmentMasterID]),
	CONSTRAINT [FK_WLDealPotentialImpairmentDetail_NoteID] FOREIGN KEY (NoteID) REFERENCES [CRE].[Note] ([NoteID])

)
