CREATE TABLE [VAL].[NoteCashFlow] (    
	NoteCashFlowID    INT    IDENTITY (1, 1) NOT NULL,
	MarkedDateMasterID    INT ,

	DealID	UNIQUEIDENTIFIER	,
	Noteid	UNIQUEIDENTIFIER	,
	Date	Date	,
	Value	decimal(28,15)	,
	ValueOverride	decimal(28,15)	,
	ValueType	nvarchar(256)	,
	
	TransactionDate	Date	,
	DueDate	Date	,
	RemitDate	Date	,
	FeeName	nvarchar(256)	,
	Description	nvarchar(256)	,
	Cash_NonCash	nvarchar(256)	,

	AnalysisID	UNIQUEIDENTIFIER	,

	CreatedBy	nvarchar(256),
	CreatedDate	Datetime,
	UpdatedBy	nvarchar(256),
	UpdatedDate	Datetime,

    CONSTRAINT [PK_NoteCashFlowID] PRIMARY KEY CLUSTERED ([NoteCashFlowID] ASC)    ,
	CONSTRAINT [FK_NoteCashFlow_MarkedDateMasterID] FOREIGN KEY (MarkedDateMasterID) REFERENCES [VAL].[MarkedDateMaster] (MarkedDateMasterID) 
);





