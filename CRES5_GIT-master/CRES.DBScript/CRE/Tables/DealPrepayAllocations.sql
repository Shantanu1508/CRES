CREATE TABLE [CRE].[DealPrepayAllocations] (
    [DealPrepayAllocationsID] INT              IDENTITY (1, 1) NOT NULL,
    [DealID]                  UNIQUEIDENTIFIER NOT NULL,
    [NoteID]                  UNIQUEIDENTIFIER NOT NULL,
    [PrepayDate]              DATE             NULL,
    [MinmultDue]              DECIMAL (28, 15) NULL,
    [CreatedBy]               NVARCHAR (256)   NULL,
    [CreatedDate]             DATETIME         NULL,
    [UpdatedBy]               NVARCHAR (256)   NULL,
    [UpdatedDate]             DATETIME         NULL,
    CONSTRAINT [PK_DealPrepayAllocationsID] PRIMARY KEY CLUSTERED ([DealPrepayAllocationsID] ASC)
);
GO

