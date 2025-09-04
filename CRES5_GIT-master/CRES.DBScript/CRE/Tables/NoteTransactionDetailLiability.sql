
CREATE TABLE [CRE].[NoteTransactionDetailLiability] (
    [NoteTransactionDetailID]              UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [LiabilityNoteAccountID]                               UNIQUEIDENTIFIER NOT NULL,
    [TransactionDate]                      DATE             NULL,
    [TransactionType]                      INT              NULL,
    [Amount]                               DECIMAL (28, 15) NULL,
    [RelatedtoModeledPMTDate]              DATE             NULL,
    [ModeledPayment]                       DECIMAL (28, 15) NULL,
    [AmountOutstandingafterCurrentPayment] DECIMAL (28, 15) NULL,
    [CreatedBy]                            NVARCHAR (256)   NULL,
    [CreatedDate]                          DATETIME         NULL,
    [UpdatedBy]                            NVARCHAR (256)   NULL,
    [UpdatedDate]                          DATETIME         NULL,
    [ServicingAmount]                      DECIMAL (28, 15) NULL,
    [CalculatedAmount]                     DECIMAL (28, 15) NULL,
    [Delta]                                DECIMAL (28, 15) NULL,
    [M61Value]                             BIT              CONSTRAINT [DF__NoteTransLib__M61Va__2CF2ADDF] DEFAULT ((0)) NULL,
    [ServicerValue]                        BIT              CONSTRAINT [DF__NoteTransLib__Servi__2DE6D218] DEFAULT ((0)) NULL,
    [Ignore]                               BIT              CONSTRAINT [DF__NoteTransLib__Ignor__2EDAF651] DEFAULT ((0)) NULL,
    [OverrideValue]                        DECIMAL (28, 15) NULL,
    [comments]                             NVARCHAR (MAX)   NULL,
    [PostedDate]                           DATETIME         NULL,
    [ServicerMasterID]                     INT              NULL,
    [Deleted]                              BIT              CONSTRAINT [DF__NoteTransLib__Delet__2FCF1A8A] DEFAULT ((0)) NULL,
    [TransactionTypeText]                  NVARCHAR (256)   NULL,
    [TranscationReconciliationID]          UNIQUEIDENTIFIER NULL,
    [RemittanceDate]                       DATETIME         NULL,
    [Exception]                            NVARCHAR (256)   NULL,
    [Adjustment]                           DECIMAL (28, 15) NULL,
    [ActualDelta]                          DECIMAL (28, 15) NULL,
    [NoteTransactionDetailAutoID]          INT              IDENTITY (1, 1) NOT NULL,
    [OverrideReason]                       INT              NULL,
    [BerAddlint]                           DECIMAL (28, 15) NULL,
    [TransactionEntryAmount]               DECIMAL (28, 15) NULL,
    [Orig_ServicerMasterID]                INT              NULL,
    [InterestAdj]                          DECIMAL (28, 15) NULL,
    [AddlInterest]                         DECIMAL (28, 15) NULL,
    [TotalInterest]                        DECIMAL (28, 15) NULL,
    [WriteOffAmount]      DECIMAL (28, 15) NULL
    CONSTRAINT [PK_NoteTransactionDetailLiabilityID] PRIMARY KEY CLUSTERED ([NoteTransactionDetailID] ASC),
    CONSTRAINT [FK_NoteTransactionDetail_LiabilityNoteAccountID] FOREIGN KEY (LiabilityNoteAccountID) REFERENCES core.Account(AccountID)
);


GO
ALTER TABLE [CRE].[NoteTransactionDetailLiability] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON);




