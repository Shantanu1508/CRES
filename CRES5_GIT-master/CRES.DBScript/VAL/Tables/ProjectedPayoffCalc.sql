CREATE TABLE [VAL].[ProjectedPayoffCalc] (    

	ProjectedPayoffCalcID    INT    IDENTITY (1, 1) NOT NULL,	
	MarkedDateMasterID int,
	ControlID nvarchar(256),
	DealName nvarchar(256),
	Client nvarchar(256),
	PropertyType nvarchar(256),
	OpenDate nvarchar(256),
	CreatedBy	nvarchar(256),
	CreatedDate	Datetime,
	UpdateBy	nvarchar(256),
	UpdatedDate	Datetime,
	[FullyExtendedMaturityDate] DATE           NULL,
    CONSTRAINT [PK_ProjectedPayoffCalc_ProjectedPayoffCalcID] PRIMARY KEY CLUSTERED ([ProjectedPayoffCalcID] ASC),
	CONSTRAINT [FK_ProjectedPayoffCalc_MarkedDateMasterID] FOREIGN KEY (MarkedDateMasterID) REFERENCES [VAL].[MarkedDateMaster] (MarkedDateMasterID) 
);





