CREATE TABLE [CRE].[TransactionTypesDecodeMapping] (
    [TransactionTypesDecodeMappingID]             INT              IDENTITY (1, 1) NOT NULL,
    [TransactionTypesDecodeMappingGUID]           UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [TransactionName]                NVARCHAR (256)   NULL,
    DecodeNo nvarchar(256)  null,
    DecodeName nvarchar(256) null,
	FeeType nvarchar(256) null,
	[Decode_Definition]              NVARCHAR (256)   NULL,
    [CreatedBy]                      NVARCHAR (256)   NULL,
    [CreatedDate]                    DATETIME         NULL,
    [UpdatedBy]                      NVARCHAR (256)   NULL,
    [UpdatedDate]                    DATETIME         NULL,
   
    CONSTRAINT [PK_TransactionTypesDecodeMappingID] PRIMARY KEY CLUSTERED ([TransactionTypesDecodeMappingID] ASC)
);