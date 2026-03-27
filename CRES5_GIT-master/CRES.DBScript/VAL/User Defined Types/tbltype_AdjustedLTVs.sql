CREATE TYPE [VAL].[tbltype_AdjustedLTVs] AS TABLE (
    [MarkedDate]                            DATETIME         NULL,
    [CREDealID]                             NVARCHAR (256)   NULL,
    [CREDealName]                           NVARCHAR (256)   NULL,
    [FundedDate]                            DATETIME         NULL,
    [TotalCommitment]                       DECIMAL (28, 15) NULL,
    [AsStabilizedAppraisal]                 DECIMAL (28, 15) NULL,
    [PropertyType]                          NVARCHAR (256)   NULL,
    [ValueDecline]                          DECIMAL (28, 15) NULL,
    [AdjustedAsStabilizedValue]             DECIMAL (28, 15) NULL,
    [RecourseCurrent]                       DECIMAL (28, 15) NULL,
    [AdjustedAsStabilizedValuewithRecourse] DECIMAL (28, 15) NULL,
    [AdjustedAsStabilizedLTV]               DECIMAL (28, 15) NULL,
    [UnadjustedAsStabilizedLTV]             DECIMAL (28, 15) NULL,
    [UserID]                                NVARCHAR (256)   NULL);

