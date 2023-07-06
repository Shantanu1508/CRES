CREATE TABLE [App].[TestCasesMaster] (
    [TestCasesID]              UNIQUEIDENTIFIER CONSTRAINT [DF__TestCases__TestC__11558062] DEFAULT (newid()) NOT NULL,
    [TestCasesName]            NVARCHAR (MAX)   NULL,
    [TestCasesDescription]     NVARCHAR (MAX)   NULL,
    [TestCasesFieldDefination] NVARCHAR (MAX)   NULL,
    [ModuleTypeID]             INT              NOT NULL,
    [StatusID]                 INT              NOT NULL,
    [TestCasesDBName]          NVARCHAR (MAX)   NULL,
    [CreatedBy]                NVARCHAR (256)   NULL,
    [CreatedDate]              DATETIME         NULL,
    [UpdatedBy]                NVARCHAR (256)   NULL,
    [UpdatedDate]              DATETIME         NULL,
    CONSTRAINT [PK_TestCasesID] PRIMARY KEY CLUSTERED ([TestCasesID] ASC)
);

