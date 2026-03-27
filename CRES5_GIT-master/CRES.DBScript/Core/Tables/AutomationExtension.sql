CREATE TABLE [Core].[AutomationExtension] 
(
    [AutomationExtensionID]	int iDENTITY(1,1) not null,
	AutomationRequestsID INT              NULL,	 
    [DealID]				UNIQUEIDENTIFIER  NULL,
    [BatchID]				INT              NULL,	 
    [ErrorMessage]			NVARCHAR (MAX)   NULL,
	[Message]			NVARCHAR (MAX)   NULL,	
    [CreatedBy]      NVARCHAR (256)   NULL,
    [CreatedDate]    DATETIME         NULL,
    [UpdatedBy]      NVARCHAR (256)   NULL,
    [UpdatedDate]    DATETIME         NULL ,
	DealFundingID				UNIQUEIDENTIFIER  NULL,
    PurposeType nvarchar(255) null,
    Amount decimal(28,15) null,
    [Date] datetime null


    CONSTRAINT [PK_CoreAutomationExtension] PRIMARY KEY CLUSTERED (AutomationExtensionID ASC)
);

 
