CREATE TABLE [DW].[L_InterestCalculatorBI] (
    [InterestCalculatorID]          UNIQUEIDENTIFIER NULL,
    [InterestCalculatorAutoID]      INT              NULL,
    [NoteID]                        UNIQUEIDENTIFIER NULL,
    [CRENoteID]                     NVARCHAR (256)   NULL,
    [AccrualStartDate]              DATE             NULL,
    [AccrualEndDate]                DATE             NULL,
    [PaymentDate]                   DATE             NULL,
    [BeginningBalance]              DECIMAL (28, 15) NULL,
    [AnalysisID]                    UNIQUEIDENTIFIER NULL,
    [LIBOR]                         DECIMAL (28, 15) NULL,
    [Spread]                        DECIMAL (28, 15) NULL,
    [AllInOnecoupon]                DECIMAL (28, 15) NULL,
    [EndingBalance]                 DECIMAL (28, 15) NULL,
    [Repayment]                     DECIMAL (28, 15) NULL,
    [Funding]                       DECIMAL (28, 15) NULL,
    [ScheduledPrincipal]            DECIMAL (28, 15) NULL,
    [PikInterest]                   DECIMAL (28, 15) NULL,
    [InterestExcludePrepayDate]     DECIMAL (28, 15) NULL,
    [InterestFullAccrual]           DECIMAL (28, 15) NULL,
    [CreatedBy]                     NVARCHAR (256)   NULL,
    [CreatedDate]                   DATETIME         NULL,
    [UpdatedBy]                     NVARCHAR (256)   NULL,
    [UpdatedDate]                   DATETIME         NULL,
    [L_InterestCalculatorBI_AutoID] INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_L_InterestCalculatorBI_AutoID] PRIMARY KEY CLUSTERED ([L_InterestCalculatorBI_AutoID] ASC)
);



