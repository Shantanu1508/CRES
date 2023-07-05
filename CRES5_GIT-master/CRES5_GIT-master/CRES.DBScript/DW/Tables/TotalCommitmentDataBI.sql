
CREATE TABLE [DW].[TotalCommitmentDataBI] (
TotalCommitmentDataBIID int IDENTITY(1,1) not null,
NoteID	UNIQUEIDENTIFIER	null,
CRENoteID	nvarchar(256)	null,
Date	Date	null,
Type	int	null,
TypeBI	nvarchar(256)	null,
value	decimal(28,15)	null,
NoteAdjustedTotalCommitment	decimal(28,15)	null,
NoteTotalCommitment	decimal(28,15)	null,
Rowno	int	null,
CREDealID	nvarchar(256)	null,
dealid	UNIQUEIDENTIFIER	null,
[CreatedBy]  NVARCHAR (256)   NULL,
[CreatedDate]   DATETIME         NULL,
[UpdatedBy]  NVARCHAR (256)   NULL,
[UpdatedDate]   DATETIME         NULL,

CONSTRAINT [PK_TotalCommitmentDataBIID] PRIMARY KEY CLUSTERED (TotalCommitmentDataBIID ASC)
);




