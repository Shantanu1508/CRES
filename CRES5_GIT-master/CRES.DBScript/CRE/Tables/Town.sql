CREATE TABLE [CRE].[Town] (
    [LookupID]    INT            IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (256) NOT NULL,
    [Value]       NVARCHAR (256) NULL,
    [Value1]      NVARCHAR (256) NULL,
    [SortOrder]   SMALLINT       NOT NULL,
    [StatusID]    INT            NOT NULL,
    [CreatedBy]   NVARCHAR (256) NULL,
    [CreatedDate] DATETIME       NULL,
    [UpdatedBy]   NVARCHAR (256) NULL,
    [UpdatedDate] DATETIME       NULL,
    CONSTRAINT [PK_LookupID] PRIMARY KEY CLUSTERED ([LookupID] ASC)
);

