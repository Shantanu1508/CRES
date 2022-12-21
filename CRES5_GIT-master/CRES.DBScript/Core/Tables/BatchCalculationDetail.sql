CREATE TABLE [Core].[BatchCalculationDetail] (
    [BatchCalculationDetailID] INT              IDENTITY (1, 1) NOT NULL,
    [BatchCalculationMasterID] INT              NULL,
    [NoteID]                   UNIQUEIDENTIFIER NULL,
    [StartTime]                DATETIME         NULL,
    [EndTime]                  DATETIME         NULL,
    [StatusID]                 INT              NULL,
    [ErrorMessage]             NVARCHAR (MAX)   NULL
);
go
ALTER TABLE [Core].[BatchCalculationDetail]
ADD CONSTRAINT PK_BatchCalculationDetail_BatchCalculationDetailID PRIMARY KEY ([BatchCalculationDetailID]);
