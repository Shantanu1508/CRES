CREATE TABLE [CRE].[DailyInterestAccruals] (
    [DailyInterestAccrualsID]   INT              IDENTITY (1, 1) NOT NULL,
    [DailyInterestAccrualsGUID] UNIQUEIDENTIFIER CONSTRAINT [DF__DailyInte__Daily__5649C92D] DEFAULT (newid()) NOT NULL,
    [NoteID]                    UNIQUEIDENTIFIER NOT NULL,
    [Date]                      DATETIME         NULL,
    [DailyInterestAccrual]      DECIMAL (28, 15) NULL,
    [AnalysisID]                UNIQUEIDENTIFIER NULL,
    [CreatedBy]                 NVARCHAR (256)   NULL,
    [CreatedDate]               DATETIME         NULL,
    [UpdatedBy]                 NVARCHAR (256)   NULL,
    [UpdatedDate]               DATETIME         NULL,
    [EndingBalance]             DECIMAL (28, 15) NULL,
	
	IndexRate		  DECIMAL (28, 15) NULL,
	AllInCouponRate DECIMAL (28, 15) NULL ,
	AllInPikRate	  DECIMAL (28, 15) NULL,
	PikSpreadOrRate DECIMAL (28, 15) NULL ,
	PIKIndexRate	  DECIMAL (28, 15) NULL,
    SpreadOrRate  DECIMAL (28, 15) NULL ,
    CONSTRAINT [FK_DailyInterestAccruals_Note_NoteID] FOREIGN KEY ([NoteID]) REFERENCES [CRE].[Note] ([NoteID])
);
go

ALTER TABLE [CRE].[DailyInterestAccruals]
ADD CONSTRAINT PK_DailyInterestAccruals_DailyInterestAccrualsID PRIMARY KEY (DailyInterestAccrualsID);

GO
CREATE NONCLUSTERED INDEX [nci_wi_DailyInterestAccruals_811609E1DD7F671F3CECA5028F0FB4D4]
    ON [CRE].[DailyInterestAccruals]([AnalysisID] ASC, [NoteID] ASC);


