CREATE TABLE [DW].[tbl_GetDiscrepancyForExportPaydown](
[Deal Name]			NVARCHAR(256) NULL,
[Deal ID]			NVARCHAR(256) NULL,
[Note ID]			NVARCHAR(256) NULL,
[Note Name]			NVARCHAR(256) NULL,
[Date]				DATE NULL,
[M61 Amount]		DECIMAL(28,15) NULL,
[BS Amount]			DECIMAL(28,15) NULL,
[Delta]				DECIMAL(28,15) NULL,
[LastUpdatedDate]	DATETIME NULL);