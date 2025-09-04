CREATE TABLE [VAL].[AdjustedLTVs] (
    [AdjustedLTVsID]                        INT              IDENTITY (1, 1) NOT NULL,
    [MarkedDateMasterID]                    INT              NULL,
    [CREDealID]                             NVARCHAR (256)   NULL,
    [RecourseCurrent]                       DECIMAL (28, 15) NULL,
    [CreatedBy]                             NVARCHAR (256)   NULL,
    [CreatedDate]                           DATETIME         NULL,
    [UpdateBy]                              NVARCHAR (256)   NULL,
    [UpdatedDate]                           DATETIME         NULL,
    [CREDealName]                           NVARCHAR (256)   NULL,
    [FundedDate]                            DATETIME         NULL,
    [TotalCommitment]                       DECIMAL (28, 15) NULL,
    [AsStabilizedAppraisal]                 DECIMAL (28, 15) NULL,
    [PropertyType]                          NVARCHAR (256)   NULL,
    [ValueDecline]                          DECIMAL (28, 15) NULL,
    [AdjustedAsStabilizedValue]             DECIMAL (28, 15) NULL,
    [AdjustedAsStabilizedValuewithRecourse] DECIMAL (28, 15) NULL,
    [AdjustedAsStabilizedLTV]               DECIMAL (28, 15) NULL,
    [UnadjustedAsStabilizedLTV]             DECIMAL (28, 15) NULL,
    CONSTRAINT [PK_AdjustedLTVs_AdjustedLTVsID] PRIMARY KEY CLUSTERED ([AdjustedLTVsID] ASC),
    CONSTRAINT [FK_AdjustedLTVs_MarkedDateMasterID] FOREIGN KEY ([MarkedDateMasterID]) REFERENCES [VAL].[MarkedDateMaster] ([MarkedDateMasterID])
);
GO

