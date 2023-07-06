CREATE TABLE [App].[DataDictionary] (
    [DataDictionaryID]  INT            IDENTITY (1, 1) NOT NULL,
    [DataType]          NVARCHAR (256) NULL,
    [Required]          NVARCHAR (256) NULL,
    [NamedRange]        NVARCHAR (256) NULL,
    [NamedCell]         NVARCHAR (256) NULL,
    [DBField]           NVARCHAR (256) NULL,
    [IsDropDown]        NVARCHAR (256) NULL,
    [UsedInSizer]       VARCHAR (5)    NULL,
    [UsedInBatchUpload] VARCHAR (5)    NULL,
    CONSTRAINT [PK_DataDictionaryID] PRIMARY KEY CLUSTERED ([DataDictionaryID] ASC)
);

