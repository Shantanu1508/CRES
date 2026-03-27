CREATE TABLE [DW].[FullAccUnpaidInterest_Interim1BI] (
    [CRENoteID]                               NVARCHAR (256)   NULL,
    [Date]                                    DATE             NULL,
    [Amount]                                  DECIMAL (28, 15) NULL,
    [AccrualStartdate]                        DATE             NULL,
    [AccrualEndate]                           DATE             NULL,
    [Nextaccrualdate]                         DATE             NULL,
    [HolidayAdjustedPaymentDate]              DATE             NULL,
    [Monthend]                                DATE             NULL,
    [AccrualDays]                             INT              NULL,
    [LIBOR]                                   DECIMAL (28, 15) NULL,
    [Spread]                                  DECIMAL (28, 15) NULL,
    [AllinOnecoupon]                          DECIMAL (28, 15) NULL,
    [FullAccUnpaidInterest_Interim1BI_AutoID] INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_FullAccUnpaidInterest_Interim1BI_AutoID] PRIMARY KEY CLUSTERED ([FullAccUnpaidInterest_Interim1BI_AutoID] ASC)
);



