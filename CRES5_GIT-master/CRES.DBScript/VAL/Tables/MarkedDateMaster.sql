CREATE TABLE [VAL].[MarkedDateMaster] (    
	MarkedDateMasterID    INT    IDENTITY (1, 1) NOT NULL,		
	MarkedDate	Date,
	CreatedBy	nvarchar(256),
	CreatedDate	Datetime,
	UpdateBy	nvarchar(256),
	UpdatedDate	Datetime

    CONSTRAINT [PK_MarkedDateMaster_MarkedDateMasterID] PRIMARY KEY CLUSTERED ([MarkedDateMasterID] ASC)   
);





