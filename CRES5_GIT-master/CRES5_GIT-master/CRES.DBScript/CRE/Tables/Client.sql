CREATE TABLE [CRE].[Client] (
    [ClientID]    INT            IDENTITY (1, 1) NOT NULL,
    [ClientName]  NVARCHAR (256) NULL,
    [Status]      INT            NULL,
    [CreatedBy]   NVARCHAR (256) NULL,
    [CreatedDate] DATETIME       NULL,
    [UpdatedBy]   NVARCHAR (256) NULL,
    [UpdatedDate] DATETIME       NULL,
    [EmailId]     NVARCHAR (256) NULL,
    [ClientAbbr] NVARCHAR(256) NULL, 
    CONSTRAINT [PK_ClientID] PRIMARY KEY CLUSTERED ([ClientID] ASC)
);

