--drop  PROCEDURE [dbo].[usp_SplitFeeTransaction]
--Drop TYPE [dbo].[TableTypeSplitTranscation]
CREATE TYPE [dbo].[TableTypeSplitTranscation] AS TABLE(
	[Transactionid] [uniqueidentifier]  NULL,
	[DueDate] [date] NULL,
	[RemittanceDate] [date] NULL,
	[DealId] [uniqueidentifier] NULL,
	[NoteID] [uniqueidentifier] NULL,
	[TransactionType] [nvarchar](250) NULL,
	[M61Amount] [decimal](28, 15) NULL,
	[ServicingAmount] [decimal](28, 15) NULL,
	[CalculatedAmount] [decimal](28, 15) NULL,
	[Delta] [decimal](28, 15) NULL,
	[Adjustment] [decimal](28, 15) NULL,
	[ActualDelta] [decimal](28, 15) NULL,
	[M61Value] [bit] NULL,
	[ServicerValue] [bit] NULL,
	[Ignore] [bit] NULL,
	ServicingAmount_Distr [decimal](28, 15) NULL,
	[OverrideValue] [decimal](28, 15) NULL,
	[comments] [nvarchar](max) NULL,
	[TransactionDate] [date] NULL,
	[OverrideReason] [int] NULL,
	Exception [nvarchar](250) NULL,
	AddlInterest [decimal](28, 15) NULL,
	TotalInterest [decimal](28, 15) NULL,
	InterestAdj [decimal](28, 15) NULL,
	ServcerMasterID int NULL,
	BatchLogID int NULL,
	Received bit null,
	BerAddlint decimal(28, 15) NULL

)
GO


