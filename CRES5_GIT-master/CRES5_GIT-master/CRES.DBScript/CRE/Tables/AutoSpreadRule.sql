CREATE TABLE [CRE].[AutoSpreadRule] (
    [AutoSpreadRuleID]   UNIQUEIDENTIFIER CONSTRAINT [DF__AutoSprea__AutoS__37C5420D] DEFAULT (newid()) NOT NULL,
    [DealID]             UNIQUEIDENTIFIER NOT NULL,
    [PurposeType]        INT              NULL,
    [PurposeSubType]     NVARCHAR (256)   NULL,
    [DebtAmount]         DECIMAL (28, 15) NULL,
    [EquityAmount]       DECIMAL (28, 15) NULL,
    [StartDate]          DATE             NULL,
    [EndDate]            DATE             NULL,
    [DistributionMethod] INT              NULL,
    [FrequencyFactor]    INT              NULL,
    [Comment]            NVARCHAR (256)   NULL,
    [CreatedBy]          NVARCHAR (256)   NULL,
    [CreatedDate]        DATETIME         NULL,
    [UpdatedBy]          NVARCHAR (256)   NULL,
    [UpdatedDate]        DATETIME         NULL,
    [RequiredEquity]     DECIMAL (28, 15) NULL,
    [AdditionalEquity]   DECIMAL (28, 15) NULL,
    CONSTRAINT [PK_AutoSpreadRuleID] PRIMARY KEY CLUSTERED ([AutoSpreadRuleID] ASC)
);

