CREATE TABLE [IO].[L_M61AddinLanding] (
    [M61AddinLandingID] INT              IDENTITY (1, 1) NOT NULL,
    [BatchLogGenericID] INT              NULL,
    [NoteID]            NVARCHAR (256)   NULL,
    [NoteName]          NVARCHAR (256)   NULL,
    [DueDate]           DATETIME         NULL,
    [TransactionDate]   DATETIME         NULL,
    [RemitDate]         DATETIME         NULL,
    [Value]             DECIMAL (28, 15) NULL,
    [TransactionTypeID] INT              NULL,
    [ServicerMasterID]  INT              NULL,
    [EffectiveDate]     DATETIME         NULL,
    [Status]            NVARCHAR (256)   NULL,
    [Comment]           NVARCHAR (MAX)   NULL,
    [TableName]         NVARCHAR (256)   NULL,
    [CreatedBy]         NVARCHAR (256)   NULL,
    [CreatedDate]       DATETIME         NULL,
    [UpdatedBy]         NVARCHAR (256)   NULL,
    [UpdatedDate]       DATETIME         NULL,
    [Cash_NonCash] NVARCHAR(256) NULL, 
    CONSTRAINT [PK_M61AddinLandingID] PRIMARY KEY CLUSTERED ([M61AddinLandingID] ASC)
);

