
CREATE TABLE [CRE].[DuplicateTransactionAnalysisData] (
	[DuplicateTransactionAnalysisDataID]    INT            IDENTITY (1, 1) NOT NULL,
	AnalysisID				UNIQUEIDENTIFIER,
	AccountID	UNIQUEIDENTIFIER,
	Schenario	nvarchar(256),
	crenoteid	nvarchar(256),
	CalcEngineType	int,
	CalcEngineTypeName nvarchar(256),  
	[CreatedDate] DATETIME       NULL
  
    CONSTRAINT [PK_DuplicateTransactionAnalysisDataID] PRIMARY KEY CLUSTERED ([DuplicateTransactionAnalysisDataID] ASC),
    
);









