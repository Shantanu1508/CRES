CREATE TYPE [dbo].[tbltype_WLDealAccounting] AS TABLE
(
	[WLDealAccountingID]            Int ,
    [DealID]          UNIQUEIDENTIFIER ,
	[StartDate] DATE,
	[EndDate] DATE,
	[TypeID]        INT ,
    [Comment]          NVARCHAR (MAX) ,
    [UserID]          NVARCHAR (256)   ,
	IsDeleted		bit
)
