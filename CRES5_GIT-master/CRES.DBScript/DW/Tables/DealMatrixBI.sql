CREATE TABLE [DW].[DealMatrixBI] (
    [DealID]              NVARCHAR (256)   NULL,
    [DealName]            NVARCHAR (256)   NULL,
    [Status]              NVARCHAR (256)   NULL,
    [Fund]                NVARCHAR (256)   NULL,
    [Commitment]          DECIMAL (28, 15) NULL,
    [Pool]                NVARCHAR (256)   NULL,
    [BillingNotes]        NVARCHAR (256)   NULL,
    [Initial]             DECIMAL (28, 15) NULL,
    [Extended]            DECIMAL (28, 15) NULL,
    [InitialFunding]      DATE             NULL,
    [InitialMaturity]     DATE             NULL,
    [ExtendedMaturity]    DATE             NULL,
    [PaidOffSold]         DATE             NULL,
    [DelphiFees]          DECIMAL (28, 15) NULL,
    [AssetManager]        NVARCHAR (256)   NULL,
    [Banker]              NVARCHAR (256)   NULL,
    [Underwritter]        NVARCHAR (256)   NULL,
    [DealMatrixBI_AutoID] INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_DealMatrixBI_AutoID] PRIMARY KEY CLUSTERED ([DealMatrixBI_AutoID] ASC)
);



