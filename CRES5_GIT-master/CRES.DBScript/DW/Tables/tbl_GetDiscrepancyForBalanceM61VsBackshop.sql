CREATE TABLE [DW].[tbl_GetDiscrepancyForBalanceM61VsBackshop](
[Deal Name]			NVARCHAR(256) NULL,
[Deal ID]			NVARCHAR(256) NULL,
[Note ID]			NVARCHAR(256) NULL,
[Note Name]			NVARCHAR(256) NULL,
[Financing Source]	NVARCHAR(256) NULL,
[M61_CurrentBls]	DECIMAL(28,15) NULL,
[BS_CurrentBls]		DECIMAL(28,15) NULL,
[Delta]				DECIMAL(28,15) NULL,
[Payoff Date]		DATE NULL,
[LastUpdatedDate]	DATETIME NULL);