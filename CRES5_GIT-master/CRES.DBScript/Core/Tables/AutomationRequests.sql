CREATE TABLE [Core].[AutomationRequests] (
    [AutomationRequestsID]	int iDENTITY(1,1) not null,
    [DealID]				UNIQUEIDENTIFIER  NULL,
    [RequestTime]			DATETIME         NULL,    
    [StartTime]				DATETIME         NULL,
    [EndTime]				DATETIME         NULL,
	[StatusID]				INT              NULL,
	AutomationType			int		null,
    [ErrorMessage]			NVARCHAR (MAX)   NULL
    
    CONSTRAINT [PK_CoreAutomationRequests] PRIMARY KEY CLUSTERED ([AutomationRequestsID] ASC)
);

