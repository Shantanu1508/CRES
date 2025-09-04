CREATE TABLE [CRE].[XIRRConfigFilter] (
    [XIRRConfigFilterID]    INT            IDENTITY (1, 1) NOT NULL,
	[XIRRConfigID]          INT  NULL,
	[XIRRFilterSetupID]     INT  NULL,
	[FilterDropDownValue]   NVARCHAR (256) NULL,
	[CreatedBy]   NVARCHAR (256) NULL,
    [CreatedDate] DATETIME       NULL,
    [UpdatedBy]   NVARCHAR (256) NULL,
    [UpdatedDate] DATETIME       NULL,
	[RowNumber]   INT            NULL

    CONSTRAINT [PK_XIRRConfigFilterID] PRIMARY KEY CLUSTERED ([XIRRConfigFilterID] ASC)
	CONSTRAINT [FK_XIRRConfigID] FOREIGN KEY (XIRRConfigID) REFERENCES [CRE].[XIRRConfig] (XIRRConfigID)
);