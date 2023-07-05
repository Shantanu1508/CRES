CREATE TABLE [CRE].[Deal] (
    [DealID]                            UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [DealName]                          NVARCHAR (256)   NULL,
    [CREDealID]                         NVARCHAR (256)   NULL,
    [DealType]                          INT              NULL,
    [LoanProgram]                       INT              NULL,
    [LoanPurpose]                       INT              NULL,
    [Status]                            INT              NULL,
    [AppReceived]                       DATE             NULL,
    [EstClosingDate]                    DATE             NULL,
    [BorrowerRequest]                   NVARCHAR (256)   NULL,
    [RecommendedLoan]                   DECIMAL (28, 15) NULL,
    [TotalFutureFunding]                DECIMAL (28, 15) NULL,
    [Source]                            INT              NULL,
    [BrokerageFirm]                     NVARCHAR (256)   NULL,
    [BrokerageContact]                  NVARCHAR (256)   NULL,
    [Sponsor]                           NVARCHAR (256)   NULL,
    [Principal]                         NVARCHAR (256)   NULL,
    [NetWorth]                          DECIMAL (28, 15) NULL,
    [Liquidity]                         DECIMAL (28, 15) NULL,
    [ClientDealID]                      NVARCHAR (256)   NULL,
    [GeneratedBy]                       INT              NULL,
    [CreatedBy]                         NVARCHAR (256)   NULL,
    [CreatedDate]                       DATETIME         NULL,
    [UpdatedBy]                         NVARCHAR (256)   NULL,
    [UpdatedDate]                       DATETIME         NULL,
    [TotalCommitment]                   DECIMAL (28, 15) NULL,
    [AdjustedTotalCommitment]           DECIMAL (28, 15) NULL,
    [AggregatedTotal]                   DECIMAL (28, 15) NULL,
    [AssetManagerComment]               NVARCHAR (MAX)   NULL,
    [AssetManager]                      NVARCHAR (256)   NULL,
    [DealCity]                          NVARCHAR (256)   NULL,
    [DealState]                         NVARCHAR (256)   NULL,
    [DealPropertyType]                  NVARCHAR (256)   NULL,
    [FullyExtMaturityDate]              DATE             NULL,
    [UnderwritingStatus]                INT              NULL,
    [LinkedDealID]                      NVARCHAR (256)   NULL,
    [DealComment]                       NVARCHAR (MAX)   NULL,
    [SourceDealID]                      UNIQUEIDENTIFIER NULL,
    [IsDeleted]                         BIT              DEFAULT ((0)) NULL,
    [AllowSizerUpload]                  INT              NULL,
    [AMUserID]                          UNIQUEIDENTIFIER NULL,
    [AMTeamLeadUserID]                  UNIQUEIDENTIFIER NULL,
    [AMSecondUserID]                    UNIQUEIDENTIFIER NULL,
    [DealRule]                          NVARCHAR (2000)  NULL,
    [Companyname]                       NVARCHAR (256)   NULL,
    [FirstName]                         NVARCHAR (256)   NULL,
    [Lastname]                          NVARCHAR (256)   NULL,
    [StreetName]                        NVARCHAR (256)   NULL,
    [ZipCodePostal]                     NVARCHAR (256)   NULL,
    [PayeeName]                         NVARCHAR (256)   NULL,
    [TelephoneNumber1]                  NVARCHAR (256)   NULL,
    [FederalID1]                        NVARCHAR (MAX)   NULL,
    [TaxEscrowConstant]                 DECIMAL (28, 15) NULL,
    [InsEscrowConstant]                 DECIMAL (28, 15) NULL,
    [CollectTaxEscrow]                  NVARCHAR (256)   NULL,
    [CollectInsEscrow]                  NVARCHAR (256)   NULL,
    [DealCityWells]                     NVARCHAR (256)   NULL,
    [DealStateWells]                    NVARCHAR (256)   NULL,
    [BoxDocumentLink]                   NVARCHAR (500)   NULL,
    [DealGroupID]                       NVARCHAR (256)   NULL,
    [EnableAutoSpread]                  BIT              NULL,
    [AmortizationMethod]                INT              NULL,
    [ReduceAmortizationForCurtailments] INT              NULL,
    [BusinessDayAdjustmentForAmort]     INT              NULL,
    [NoteDistributionMethod]            INT              NULL,
    [PeriodicStraightLineAmortOverride] DECIMAL (28, 15) NULL,
    [FixedPeriodicPayment]              DECIMAL (28, 15) NULL,
    [EquityAmount]                      DECIMAL (28, 15) NULL,
    [RemainingAmount]                   DECIMAL (28, 15) NULL,
    [DealTypeMasterID]                  INT              NULL,
    [PropertyTypeBS]                    NVARCHAR (256)   NULL,
    [EnableAutoSpreadRepayments]        BIT              NULL,
    [AutoUpdateFromUnderwriting]        BIT              NULL,
    [KnownFullPayoffDate]               DATE             NULL,
    [ExpectedFullRepaymentDate]         DATE             NULL,
    [AutoPrepayEffectiveDate]           DATE             NULL,
    [EarliestPossibleRepaymentDate]     DATE             NULL,
    [LatestPossibleRepaymentDate]       DATE             NULL,
    [Blockoutperiod]                    INT              NULL,
    [PossibleRepaymentdayofthemonth]    INT              NULL,
    [Repaymentallocationfrequency]      INT              NULL,
    [RepaymentStartDate]                DATE             NULL,
    [RepaymentAutoSpreadMethodID]       INT              NULL,
    [DealLevelMaturity]                 BIT              NULL,
    [ApplyNoteLevelPaydowns]            BIT              NULL,
    [IsREODeal]                         BIT              NULL,
    [AlternateAssetManager2ID]          UNIQUEIDENTIFIER NULL,
    [AlternateAssetManager3ID]          UNIQUEIDENTIFIER NULL,
    [InquiryDate]                       DATETIME         NULL,
    [BalanceAware]                      BIT              NULL,
    [BS_CollateralStatusDesc]           NVARCHAR (256)   NULL,
    [BS_CollateralStatusDesclatest]     NVARCHAR (256)   NULL,
    [PropertyTypeMajorID]               INT              NULL,
    [BSCity]                            NVARCHAR (256)   NULL,
    [BSState]                           NVARCHAR (256)   NULL,
    [MSA_NAME]                          NVARCHAR (256)   NULL,
    [LoanStatusID]                      INT              NULL,
    [Prepaydate]                        DATE             NULL,
    [PropertyManagerEmail]              NVARCHAR (500)   NULL,
    [ICMFullyFundedEquity]              DECIMAL (28, 15) NULL,
    [EquityAtClosing]                   DECIMAL (28, 15) NULL,
    CONSTRAINT [PK_DealID] PRIMARY KEY CLUSTERED ([DealID] ASC)
);


GO
ALTER TABLE [CRE].[Deal] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON);




GO
CREATE NONCLUSTERED INDEX [IX_Deal_CREDealID]
    ON [CRE].[Deal]([CREDealID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Deal_CREDealID_IsDeleted]
    ON [CRE].[Deal]([CREDealID] ASC, [IsDeleted] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Deal_IsDeleted]
    ON [CRE].[Deal]([IsDeleted] ASC)
    INCLUDE([DealName], [CreatedDate]);


GO
CREATE NONCLUSTERED INDEX [IX_Deal_IsDeleted_DealID]
    ON [CRE].[Deal]([IsDeleted] ASC, [DealID] ASC)
    INCLUDE([DealName], [CREDealID]);


GO
CREATE NONCLUSTERED INDEX [IX_Deal_IsDeleted_DealName]
    ON [CRE].[Deal]([IsDeleted] ASC, [DealName] ASC)
    INCLUDE([UpdatedDate]);


GO
CREATE NONCLUSTERED INDEX [IX_Deal_LinkedDealID_IsDeleted]
    ON [CRE].[Deal]([LinkedDealID] ASC, [IsDeleted] ASC);

