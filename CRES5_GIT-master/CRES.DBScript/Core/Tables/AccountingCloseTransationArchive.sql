CREATE TABLE [CORE].[AccountingCloseTransationArchive] (
	AccountingCloseTransationArchiveID		int IDENTITY(1,1) not null,
    [PeriodID]			UNIQUEIDENTIFIER NULL,

    [TransactionEntryID]                  UNIQUEIDENTIFIER NULL,
    [NoteID]                              UNIQUEIDENTIFIER NOT NULL,
    [Date]                                DATETIME         NULL,
    [Amount]                              DECIMAL (28, 15) NULL,
    [Type]                                NVARCHAR (MAX)   NULL,
    [AnalysisID]                          UNIQUEIDENTIFIER NULL,
    [FeeName]                             NVARCHAR (256)   NULL,
    [StrCreatedBy]                        NVARCHAR (256)   NULL,
    [GeneratedBy]                         NVARCHAR (256)   NULL,
    [TransactionDateByRule]               DATE             NULL,
    [TransactionDateServicingLog]         DATE             NULL,
    [RemitDate]                           DATE             NULL,
    [FeeTypeName]                         NVARCHAR (256)   NULL,
    [Comment]                             NVARCHAR (MAX)   NULL,
    [PaymentDateNotAdjustedforWorkingDay] DATETIME         NULL,
    [PurposeType]                         NVARCHAR (256)   NULL,
    [Cash_NonCash]                        NVARCHAR (256)   NULL,
    [IOTermEndDate]                       DATE             NULL,
    LIBORPercentage       decimal(28,15) null,
    SpreadPercentage	   decimal(28,15) null,
    PIKInterestPercentage decimal(28,15) null,
    PIKLiborPercentage	   decimal(28,15) null,
	NonCommitmentAdj NVARCHAR (10)   NULL,
    AllInCouponRate decimal(28,15),

	[IsDeleted]                       INT             DEFAULT ((0)) NOT NULL,
	[CreatedBy]                           NVARCHAR (256)   NULL,
    [CreatedDate]                         DATETIME         NULL,
    [UpdatedBy]                           NVARCHAR (256)   NULL,
    [UpdatedDate]                         DATETIME         NULL,

    [AdjustmentType] NVARCHAR(256) null
    CONSTRAINT [PK_AccountingCloseTransationArchiveID] PRIMARY KEY CLUSTERED (AccountingCloseTransationArchiveID ASC),
   
);

