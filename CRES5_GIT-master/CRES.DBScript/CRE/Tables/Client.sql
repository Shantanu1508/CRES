CREATE TABLE [CRE].[Client] (
    [ClientID]    INT            IDENTITY (1, 1) NOT NULL,
    [ClientName]  NVARCHAR (256) NULL,
    [Status]      INT            NULL,
    [CreatedBy]   NVARCHAR (256) NULL,
    [CreatedDate] DATETIME       NULL,
    [UpdatedBy]   NVARCHAR (256) NULL,
    [UpdatedDate] DATETIME       NULL,
    [EmailId]     NVARCHAR (256) NULL,
    [ClientAbbr]  NVARCHAR (256) NULL,
    [IsThirdParty] BIT DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_ClientID] PRIMARY KEY CLUSTERED ([ClientID] ASC)
);


GO
ALTER TABLE [CRE].[Client] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON);



