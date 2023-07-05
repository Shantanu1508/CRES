CREATE TYPE [dbo].[TableTypePeriodicInterestRateUsed] AS TABLE (
    [NoteID]                                UNIQUEIDENTIFIER NULL,
    [Date]                                  DATE             NULL,
    [CouponSpread]                          DECIMAL (28, 15) NULL,
    [AllInCouponRate]                       DECIMAL (28, 15) NULL,
    [AllInPikRate]                          DECIMAL (28, 15) NULL,
    [LiborRate]                             DECIMAL (28, 15) NULL,
    [IndexFloor]                            DECIMAL (28, 15) NULL,
    [CouponRate]                            DECIMAL (28, 15) NULL,
    [AdditionalPIKinterestRatefromPIKTable] DECIMAL (28, 15) NULL,
    [AdditionalPIKSpreadfromPIKTable]       DECIMAL (28, 15) NULL,
    [PIKIndexFloorfromPIKTable]             DECIMAL (28, 15) NULL,
    [AnalysisID]                            UNIQUEIDENTIFIER NULL);

