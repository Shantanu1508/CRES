CREATE TABLE [CRE].[DailyGAAPBasisComponents] (
		[DailyGAAPBasisComponentsID]        INT              IDENTITY (1, 1) NOT NULL,
		[DailyGAAPBasisComponentsGUID]      UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
		[NoteID]                            UNIQUEIDENTIFIER NOT NULL,
		[Date]                              DATETIME         NULL,
		[AccumAmortofDeferredFees]          DECIMAL (28, 15) NULL,
		[AccumulatedAmortofDiscountPremium] DECIMAL (28, 15) NULL,
		[AccumulatedAmortofCapitalizedCost] DECIMAL (28, 15) NULL,
		EndingBalance                       DECIMAL (28, 15) NULL,
		GrossDeferredFees                   DECIMAL (28, 15) NULL,
		CleanCost                           DECIMAL (28, 15) NULL,
		CurrentPeriodInterestAccrualPeriodEnddate          DECIMAL (28, 15) NULL,
		CurrentPeriodPIKInterestAccrualPeriodEnddate          DECIMAL (28, 15) NULL,
		InterestSuspenseAccountBalance          DECIMAL (28, 15) NULL,
		[AnalysisID]                        UNIQUEIDENTIFIER NULL,
		[CreatedBy]                         NVARCHAR (256)   NULL,
		[CreatedDate]                       DATETIME         NULL,
		[UpdatedBy]                         NVARCHAR (256)   NULL,
		[UpdatedDate]                       DATETIME         NULL,

		CurrentPeriodInterestAccrual   DECIMAL (28, 15) NULL,
		CurrentPeriodPIKInterestAccrual DECIMAL (28, 15) NULL

    CONSTRAINT [FK_DailyGAAPBasisComponents_Note_NoteID] FOREIGN KEY ([NoteID]) REFERENCES [CRE].[Note] ([NoteID])
);

go
ALTER TABLE [CRE].[DailyGAAPBasisComponents]
ADD CONSTRAINT PK_DailyGAAPBasisComponents_DailyGAAPBasisComponentsID PRIMARY KEY (DailyGAAPBasisComponentsID);