CREATE TABLE [App].[TestCasesDetails] (
    [TestCasesDetailsID] UNIQUEIDENTIFIER CONSTRAINT [DF__TestCases__TestC__1431ED0D] DEFAULT (newid()) NOT NULL,
    [TestCasesID]        UNIQUEIDENTIFIER NOT NULL,
    [ObjectID]           UNIQUEIDENTIFIER NOT NULL,
    [CreatedBy]          NVARCHAR (256)   NULL,
    [CreatedDate]        DATETIME         NULL,
    [UpdatedBy]          NVARCHAR (256)   NULL,
    [UpdatedDate]        DATETIME         NULL,
    CONSTRAINT [PK_TestCasesDetailsID] PRIMARY KEY CLUSTERED ([TestCasesDetailsID] ASC),
    CONSTRAINT [FK_TestCasesDetails_TestCasesDetailsID] FOREIGN KEY ([TestCasesID]) REFERENCES [App].[TestCasesMaster] ([TestCasesID])
);

