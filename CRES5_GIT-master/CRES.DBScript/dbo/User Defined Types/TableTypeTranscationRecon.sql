--Drop TYPE [dbo].[TableTypeTranscationRecon] 

CREATE TYPE [dbo].[TableTypeTranscationRecon] AS TABLE(
	[Transcationid] [uniqueidentifier] NOT NULL,
	[DateDue] [date] NULL,
	[RemittanceDate] [date] NULL,
	[DealId] [uniqueidentifier] NULL,
	[NoteID] [uniqueidentifier] NULL,
	[TransactionType] [nvarchar](250) NULL,
	[ServicingAmount] [decimal](28, 15) NULL,
	[CalculatedAmount] [decimal](28, 15) NULL,
	[Delta] [decimal](28, 15) NULL,
	[Adjustment] [decimal](28, 15) NULL,
	[ActualDelta] [decimal](28, 15) NULL,
	[AddlInterest] [decimal](28, 15) NULL,
	[TotalInterest] [decimal](28, 15) NULL,
	[M61Value] [bit] NULL,
	[ServicerValue] [bit] NULL,
	[Ignore] [bit] NULL,
	[OverrideValue] [decimal](28, 15) NULL,
	[comments] [nvarchar](max) NULL,
	[TransactionDate] [date] NULL,
	[SourceType] [nvarchar](250) NULL,
	[OverrideReason] [int] NULL,
	DueDateAlreadyReconciled [bit] NULL,
	[UpdatedBy] [uniqueidentifier] NULL,
	[WriteOffAmount] [decimal](28, 15) NULL
	
)
GO
