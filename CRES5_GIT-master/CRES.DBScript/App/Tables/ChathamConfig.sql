CREATE TABLE [App].[ChathamConfig] (
	[ChathamConfigID]    INT            IDENTITY (1, 1) NOT NULL,    
	[URL]        NVARCHAR (256) NULL,
	[RatesCode]       NVARCHAR (256) NULL, 
	[IndexTypeID]    INT            NULL,
	[IndexesMasterGuid] UNIQUEIDENTIFIER null,
	[Description] NVARCHAR (256) NULL,  
	[IsActive]    bit            NOT NULL,
	[CreatedBy]   NVARCHAR (256) NULL,
	[CreatedDate] DATETIME       NULL,
	[UpdatedBy]   NVARCHAR (256) NULL,
	[UpdatedDate] DATETIME       NULL,
	FrequencyType  NVARCHAR (256) NULL,  
    CONSTRAINT [PK_ChathamConfigID] PRIMARY KEY CLUSTERED ([ChathamConfigID] ASC)
    
);


GO

