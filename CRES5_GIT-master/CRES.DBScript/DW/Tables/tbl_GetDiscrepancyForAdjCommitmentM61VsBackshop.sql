CREATE TABLE [DW].[tbl_GetDiscrepancyForAdjCommitmentM61VsBackshop](
[Deal Name]							NVARCHAR(256) NULL,
[Deal ID]							NVARCHAR(256) NULL,
[Note ID]							NVARCHAR(256) NULL,
[Note Name]							NVARCHAR(256) NULL,
[Financing Source]					NVARCHAR(256) NULL,
[Enable M61 Calculation]			NVARCHAR(256) NULL,
[M61_NoteAdjustedTotalCommitment]	DECIMAL(28,15) NULL,	
[TotalCurrentAdjustedCommitment]	DECIMAL(28,15) NULL,
[Delta]								DECIMAL(28,15) NULL,
[Deal Type]							NVARCHAR(256) NULL,
[Payoff Date]						DATE NULL,
[LastUpdatedDate]					DATETIME NULL);