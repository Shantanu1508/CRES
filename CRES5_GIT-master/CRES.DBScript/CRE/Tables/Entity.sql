CREATE TABLE [CRE].[Entity] (
    [EntityID]    INT            IDENTITY (1, 1) NOT NULL,
    [EntityName]  NVARCHAR (256) NULL,
    [ClientID]    INT            NULL,
    [CreatedBy]   NVARCHAR (256) NULL,
    [CreatedDate] DATETIME       NULL,
    [UpdatedBy]   NVARCHAR (256) NULL,
    [UpdatedDate] DATETIME       NULL,
    CONSTRAINT [PK_EntityID] PRIMARY KEY CLUSTERED ([EntityID] ASC),
    CONSTRAINT [FK_Entity_ClientID] FOREIGN KEY ([ClientID]) REFERENCES [CRE].[Client] ([ClientID])
);

