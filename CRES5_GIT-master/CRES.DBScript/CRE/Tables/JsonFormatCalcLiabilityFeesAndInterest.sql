CREATE TABLE [CRE].[JsonFormatCalcLiabilityFeesAndInterest] (
    [JsonFormatCalcLiabilityFeesAndInterestID] INT            IDENTITY (1, 1) NOT NULL,
    [Position]                                 NVARCHAR (256)  NULL,
    [Key]                                      NVARCHAR (50)  NULL,
    [KeyFormat]                                NVARCHAR (50)  NULL,
    [DataType]                                 NVARCHAR (50)  NULL,
    [IsActive]                                 BIT            NULL,
    [ParentID]                                 INT            NULL,
    [FilterBy]                                 NVARCHAR (50)  NULL,
    [IsDynamic]                                BIT            DEFAULT ((0)) NULL,
    [DynamicField]                             NVARCHAR (256) NULL,
    [DynamicFieldValue]                             NVARCHAR (256) NULL,
    [IsOptional]                               BIT DEFAULT ((0)) NULL,

    CONSTRAINT [PK_JsonFormatCalcLiabilityFeesAndInterest] PRIMARY KEY CLUSTERED ([JsonFormatCalcLiabilityFeesAndInterestID] ASC)
);


