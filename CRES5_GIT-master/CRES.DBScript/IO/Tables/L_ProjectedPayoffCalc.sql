CREATE TABLE [IO].[L_ProjectedPayoffCalc] (    

	ProjectedPayoffCalcID    INT    IDENTITY (1, 1) NOT NULL,	
	ControlID nvarchar(256),
	DealName nvarchar(256),
	Client nvarchar(256),
	PropertyType nvarchar(256),
	OpenDate nvarchar(256),
	CreatedBy	nvarchar(256),
	CreatedDate	Datetime,
	UpdateBy	nvarchar(256),
	UpdatedDate	Datetime,
	FullyExtendedMaturityDate	Date	

    CONSTRAINT [PK_L_ProjectedPayoffCalc_ProjectedPayoffCalcID] PRIMARY KEY CLUSTERED ([ProjectedPayoffCalcID] ASC),
	
);





