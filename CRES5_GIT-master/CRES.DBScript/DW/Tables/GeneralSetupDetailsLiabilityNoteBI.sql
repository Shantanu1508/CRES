CREATE TABLE [DW].[GeneralSetupDetailsLiabilityNoteBI](
	[GeneralSetupDetailsLiabilityAutoID] [int] NOT NULL,
	[GeneralSetupDetailsLiabilityID] [uniqueidentifier] NOT NULL,
	[EventId] [uniqueidentifier] NOT NULL,
	[PledgeDate] [date] NULL,
	[LiabilityNoteAccountID] [uniqueidentifier] NULL,
	[PaydownAdvanceRate] [decimal](28, 15) NULL,
	[FundingAdvanceRate] [decimal](28, 15) NULL,
	[TargetAdvanceRate] [decimal](28, 15) NULL,
	[MaturityDate] [date] NULL,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[UpdatedDate] [datetime] NULL,
	[ScheduleType] [nvarchar](256) NULL
)