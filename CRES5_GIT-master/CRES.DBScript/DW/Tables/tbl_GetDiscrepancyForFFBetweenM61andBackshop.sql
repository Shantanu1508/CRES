CREATE TABLE [DW].[tbl_GetDiscrepancyForFFBetweenM61andBackshop](
[Deal Name]				NVARCHAR(256) NULL,
[Deal ID]				NVARCHAR(256) NULL,
[Note ID]				NVARCHAR(256) NULL,
[M61 Funding Date]		DATE NULL,
[M61 Funding Amount]	DECIMAL(28,15) NULL,
[BS Funding Date]		DATE NULL,
[BS Funding Amount]		DECIMAL(28,15) NULL,
[Delta]					DECIMAL(28,15) NULL,
[LastUpdatedDate]		DATETIME NULL);