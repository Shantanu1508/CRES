
CREATE TABLE [DW].[ServicerBalance] (
    [ServicerBalanceID]    INT            IDENTITY (1, 1) NOT NULL,
	CREDealid	nvarchar(256),
	DealName	nvarchar(256),
	WatchlistStatus	nvarchar(256),
	CRENoteID	nvarchar(256),
	NoteName	nvarchar(256),
	ServicerName	nvarchar(256),
	ServicerID	nvarchar(256),
	PurposeType	nvarchar(256),
	LastPaydown	Date,
	LastPaydownAmount	decimal(28,15),
	M61_Balance	decimal(28,15),
	Servicer_Balance	decimal(28,15),
	delta	decimal(28,15),
	List_crenoteid	nvarchar(256),
	[CreatedDate] DATETIME       NULL,
   ServicingStatusBS nvarchar(256)
    CONSTRAINT [PK_ServicerBalanceID] PRIMARY KEY CLUSTERED ([ServicerBalanceID] ASC),
   
);

go

ALTER TABLE [DW].[ServicerBalance] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON);


	
