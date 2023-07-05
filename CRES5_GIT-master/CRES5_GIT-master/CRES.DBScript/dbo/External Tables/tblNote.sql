CREATE EXTERNAL TABLE [dbo].[tblNote] (
    [NoteId] INT NULL,
    [ControlId_F] NVARCHAR (10) NOT NULL,
    [PrimaryDebtFlag] NVARCHAR (3) NULL
)
    WITH (
    DATA_SOURCE = [RemoteReferenceData]
    );

