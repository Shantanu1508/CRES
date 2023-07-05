CREATE TABLE [CRE].[PayruleSetup] (
    [PayruleSetupID]     UNIQUEIDENTIFIER CONSTRAINT [DF__PayruleSe__Payru__2D47B39A] DEFAULT (newid()) NOT NULL,
    [DealID]             UNIQUEIDENTIFIER NOT NULL,
    [StripTransferFrom]  UNIQUEIDENTIFIER NULL,
    [StripTransferTo]    UNIQUEIDENTIFIER NULL,
    [Value]              DECIMAL (28, 15) NULL,
    [RuleID]             INT              NULL,
    [CreatedBy]          NVARCHAR (256)   NULL,
    [CreatedDate]        DATETIME         NULL,
    [UpdatedBy]          NVARCHAR (256)   NULL,
    [UpdatedDate]        DATETIME         NULL,
    [PayruleSetupAutoID] INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_PayruleSetupID] PRIMARY KEY CLUSTERED ([PayruleSetupID] ASC),
    CONSTRAINT [FK_PayruleSetup_DealID] FOREIGN KEY ([DealID]) REFERENCES [CRE].[Deal] ([DealID])
);


GO
CREATE NONCLUSTERED INDEX [nci_wi_PayruleSetup_2E83130C3871F6FEB7D20FE7C1F37256]
    ON [CRE].[PayruleSetup]([StripTransferTo] ASC)
    INCLUDE([StripTransferFrom]);


GO
CREATE NONCLUSTERED INDEX [IX_PayruleSetup_DealID]
    ON [CRE].[PayruleSetup]([DealID] ASC)
    INCLUDE([StripTransferFrom], [StripTransferTo], [Value], [RuleID]);


GO
CREATE NONCLUSTERED INDEX [IX_PayruleSetup_DealID_StripTransferFrom]
    ON [CRE].[PayruleSetup]([DealID] ASC, [StripTransferFrom] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_PayruleSetup_StripTransferFrom]
    ON [CRE].[PayruleSetup]([StripTransferFrom] ASC);

