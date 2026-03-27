CREATE TABLE [CORE].[InterestExpenseSchedule] (
	[InterestExpenseScheduleID]		INT  IDENTITY (1, 1) NOT NULL, 	
	[InterestExpenseScheduleGUID]	UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
	[EventID]						UNIQUEIDENTIFIER NOT NULL,
	[InitialInterestAccrualEndDate]           DATE             NULL,
	[PaymentDayOfMonth]                       INT              NULL,
	[PaymentDateBusinessDayLag]               INT              NULL,
	[DeterminationDateLeadDays]               INT              NULL,
	[DeterminationDateReferenceDayOftheMonth] INT              NULL,
	[FirstRateIndexResetDate]				  DATE             NULL,
    [InitialIndexValueOverride]				  decimal(28,15)   NULL,    
	[CreatedBy]   NVARCHAR (256) NULL,
	[CreatedDate] DATETIME       NULL,
	[UpdatedBy]   NVARCHAR (256) NULL,
	[UpdatedDate] DATETIME       NULL,
	Recourse 				  decimal(28,15)   NULL,   

	CONSTRAINT [PK_InterestExpenseScheduleID] PRIMARY KEY CLUSTERED ([InterestExpenseScheduleID] ASC)
);
GO

ALTER TABLE [CORE].[InterestExpenseSchedule] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON)