CREATE TYPE [dbo].[tbltype_WLDealPotentialImpairment] AS TABLE
(
	[WLDealPotentialImpairmentID]            INT ,
    [DealID]          UNIQUEIDENTIFIER ,
	[Date] DATE,
	[Amount] DECIMAL(28,15),
	[AdjustmentType] INT,
    [Comment] NVARCHAR (MAX) ,
	[RowNo] int null,
	[Applied] BIT,
	[NoteID] UNIQUEIDENTIFIER,
	[Value] DECIMAL(28,15),
    [UserID]          NVARCHAR (256),
	IsDeleted			BIT
)
