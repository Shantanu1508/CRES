CREATE TABLE [Core].[AutomationRequests] (
    [AutomationRequestsID]	int iDENTITY(1,1) not null,
    [DealID]				UNIQUEIDENTIFIER  NULL,
    [RequestTime]			DATETIME         NULL,    
    [StartTime]				DATETIME         NULL,
    [EndTime]				DATETIME         NULL,
	[StatusID]				INT              NULL,
	AutomationType			int		null,
    [ErrorMessage]			NVARCHAR (MAX)   NULL,
    [CreatedBy]      NVARCHAR (256)   NULL,
    [CreatedDate]    DATETIME         NULL,
    [UpdatedBy]      NVARCHAR (256)   NULL,
    [UpdatedDate]    DATETIME         NULL,
    [BatchType]      NVARCHAR (256)   NULL,
    [BatchID]      int   NULL,
	isEmailSent int default 4,
    [DealSaveStatus] NVARCHAR(256) NULL,
	isDealSentForCalc int default 4,
	[AnalysisID]      NVARCHAR (256)   NULL,
	[FileName]      NVARCHAR (MAX)   NULL,

    CONSTRAINT [PK_CoreAutomationRequests] PRIMARY KEY CLUSTERED ([AutomationRequestsID] ASC), 
    
);

