CREATE TABLE [VAL].[ValuationRequests] (
    [ValuationRequestsID]	int iDENTITY(1,1) not null,
	MarkedDateMasterID    INT ,
    [DealID]				UNIQUEIDENTIFIER  NULL,
    [RequestTime]			DATETIME         NULL,    
    [StartTime]				DATETIME         NULL,
    [EndTime]				DATETIME         NULL,
	[StatusID]				INT              NULL,
	AnalysisID			UNIQUEIDENTIFIER		null,
    [ErrorMessage]			NVARCHAR (MAX)   NULL,
    [CreatedBy]      NVARCHAR (256)   NULL,
    [CreatedDate]    DATETIME         NULL,
    [UpdatedBy]      NVARCHAR (256)   NULL,
    [UpdatedDate]    DATETIME         NULL,
    NumberOfRetries int,

    VMMasterID  INT NULL,
    CNT int,
	isEmailsent   int default 4

    CONSTRAINT [PK_ValuationRequests_ValuationRequestsID] PRIMARY KEY CLUSTERED ([ValuationRequestsID] ASC), 
    CONSTRAINT [FK_ValuationRequests_MarkedDateMasterID] FOREIGN KEY (MarkedDateMasterID) REFERENCES [VAL].[MarkedDateMaster] (MarkedDateMasterID) 
);


