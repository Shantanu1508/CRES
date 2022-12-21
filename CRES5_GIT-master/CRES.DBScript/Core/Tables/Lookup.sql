CREATE TABLE [Core].[Lookup] (
    [LookupID]    INT            IDENTITY (1, 1) NOT NULL,
    [ParentID]    INT            NOT NULL,
    [Name]        NVARCHAR (256) NOT NULL,
    [Value]       NVARCHAR (256) NULL,
    [Value1]      NVARCHAR (256) NULL,
    [SortOrder]   SMALLINT       NOT NULL,
    [StatusID]    INT            NOT NULL,
    [CreatedBy]   NVARCHAR (256) NULL,
    [CreatedDate] DATETIME       NULL,
    [UpdatedBy]   NVARCHAR (256) NULL,
    [UpdatedDate] DATETIME       NULL,
    [IsInternal]  BIT            NULL,
    CONSTRAINT [PK_LookupID] PRIMARY KEY CLUSTERED ([LookupID] ASC),
    CONSTRAINT [PK_Lookup_StatusID] FOREIGN KEY ([StatusID]) REFERENCES [Core].[Lookup] ([LookupID])
);


GO
ALTER TABLE [Core].[Lookup] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON);



