CREATE TABLE [CRE].[DealTypeMaster] (
    [DealTypeMasterID] INT            IDENTITY (1, 1) NOT NULL,
    [DealTypeCode]     NVARCHAR (256) NULL,
    [DealTypeName]     NVARCHAR (256) NULL,
    [SortOrder]        INT            NULL,
    [Status]           INT            NULL,
    [CreatedBy]        NVARCHAR (256) NULL,
    [CreatedDate]      DATETIME       NULL,
    [UpdatedBy]        NVARCHAR (256) NULL,
    [UpdatedDate]      DATETIME       NULL,
    CONSTRAINT [PK_DealTypeMasterID] PRIMARY KEY CLUSTERED ([DealTypeMasterID] ASC)
);

