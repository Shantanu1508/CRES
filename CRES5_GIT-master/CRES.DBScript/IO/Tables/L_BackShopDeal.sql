CREATE TABLE [IO].[L_BackShopDeal]
(
	[L_BackShopDealID]    INT IDENTITY (1, 1) NOT NULL,
	ControlId	nvarchar(256),
	dealname	nvarchar(256),
	LoanStatusCd_F	nvarchar(10),
	LoanStatusDesc	nvarchar(256),
	ShardName nvarchar(256)

	CONSTRAINT [PK_L_BackShopDealID] PRIMARY KEY CLUSTERED ([L_BackShopDealID] ASC),
)
