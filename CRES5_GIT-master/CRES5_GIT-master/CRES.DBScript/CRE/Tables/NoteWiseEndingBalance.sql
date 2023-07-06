CREATE TABLE [CRE].[NoteWiseEndingBalance] (  
    [NoteId]                    UNIQUEIDENTIFIER NOT NULL, 
    [CRENoteID]                 NVARCHAR (256)   NULL,
    [SUM_EndingBalance]         decimal(28,15)              NOT NULL,
    [CreatedBy]                 NVARCHAR (256)   NULL,
    [CreatedDate]               DATETIME         NULL,
    [UpdatedBy]                 NVARCHAR (256)   NULL,
    [UpdatedDate]               DATETIME         NULL,
    NoteWiseEndingBalanceID int IDENTITY(1,1)
);
go

go
ALTER TABLE [CRE].[NoteWiseEndingBalance]
ADD CONSTRAINT PK_NoteWiseEndingBalance_NoteWiseEndingBalanceID PRIMARY KEY (NoteWiseEndingBalanceID);
