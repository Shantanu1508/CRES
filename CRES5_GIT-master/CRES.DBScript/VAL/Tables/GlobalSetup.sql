CREATE TABLE [VAL].[GlobalSetup] (
    
	GlobalSetupID    INT    IDENTITY (1, 1) NOT NULL,
	MarkedDateMasterID    INT ,

	UseDurSpreadVolWt	int,
	GAAPBasisInputsIncludeAccrued	int,
	MinimumExcessIOCredit	int,
	PercentageofFloorValueincludedinMark	decimal(28,15),
	---MarkedDate	Date,
	FloorIndexDate	Date,
	
	CreatedBy	nvarchar(256),
	CreatedDate	Datetime,
	UpdatedBy	nvarchar(256),
	UpdatedDate	Datetime,
	 [PricingGridKey]                       NVARCHAR (256)   NULL,
    [PricingGridMarketSOFRFloor]           DECIMAL (28, 15) NULL,
	[LIBORForecast]					DECIMAL (28, 15) NULL
    CONSTRAINT [PK_GlobalSetupID] PRIMARY KEY CLUSTERED ([GlobalSetupID] ASC)    ,
	CONSTRAINT [FK_GlobalSetup_MarkedDateMasterID] FOREIGN KEY (MarkedDateMasterID) REFERENCES [VAL].[MarkedDateMaster] (MarkedDateMasterID) 
);





