CREATE TABLE [CRE].[XIRRConfigArchive]
(
	[XIRRConfigArchiveID] INT IDENTITY (1, 1) NOT NULL,
	[XIRRConfigID]    INT,    
	[ArchiveDate] DATETIME       NULL,
	[CreatedBy]   NVARCHAR (256) NULL,
    [CreatedDate] DATETIME       NULL,
    [UpdatedBy]   NVARCHAR (256) NULL,
    [UpdatedDate] DATETIME       NULL,
	FileName_Input nvarchar(256),
	FileName_Output nvarchar(256),
    [Comments]    NVARCHAR (MAX) NULL,


	ReturnName NVARCHAR (256) NULL,
	[Type] NVARCHAR (100) NULL,
	[Tags] NVARCHAR (256) NULL,
	[Transaction] NVARCHAR (256) NULL,
	AnalysisID UNIQUEIDENTIFIER,
	ConfigSetup NVARCHAR (MAX) NULL,

    CONSTRAINT [PK_XIRRConfigArchiveID] PRIMARY KEY CLUSTERED ([XIRRConfigArchiveID] ASC),
	--CONSTRAINT [FK_XIRRConfigArchive_XIRRConfigID] FOREIGN KEY (XIRRConfigID) REFERENCES [CRE].[XIRRConfig] (XIRRConfigID)
)
