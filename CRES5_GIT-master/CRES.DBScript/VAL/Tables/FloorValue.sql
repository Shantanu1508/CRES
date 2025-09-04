CREATE TABLE [VAL].[FloorValue] (    
	FloorValueID    INT    IDENTITY (1, 1) NOT NULL,	
	MarkedDateMasterID    INT ,
	IndexTypeName	nvarchar(256),
	CurrentMarketLoanFloor	decimal(28,15),
	Term	decimal(28,15),
	LoanFloor	decimal(28,15),

	CreatedBy	nvarchar(256),
	CreatedDate	Datetime,
	UpdateBy	nvarchar(256),
	UpdatedDate	Datetime

    CONSTRAINT [PK_FloorValue_FloorValueID] PRIMARY KEY CLUSTERED ([FloorValueID] ASC)   ,
	CONSTRAINT [FK_FloorValue_MarkedDateMasterID] FOREIGN KEY (MarkedDateMasterID) REFERENCES [VAL].[MarkedDateMaster] (MarkedDateMasterID) 
);



