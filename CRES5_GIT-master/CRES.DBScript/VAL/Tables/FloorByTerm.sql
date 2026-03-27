CREATE TABLE [VAL].[FloorByTerm] (    
	FloorByTermID    INT    IDENTITY (1, 1) NOT NULL,	
	
	FloorValueID	int,
	[Percentage]	decimal(28,15),
	[Month]	int,
	[Value]	decimal(28,15),

	CreatedBy	nvarchar(256),
	CreatedDate	Datetime,
	UpdateBy	nvarchar(256),
	UpdatedDate	Datetime

    CONSTRAINT [PK_FloorByTerm_FloorByTermID] PRIMARY KEY CLUSTERED ([FloorByTermID] ASC),
	CONSTRAINT [FK_FloorByTerm_FloorValueID] FOREIGN KEY (FloorValueID) REFERENCES [VAL].[FloorValue] (FloorValueID) 
);





