CREATE TABLE [CRE].[LiabilityBanker] (
[LiabilityBankerID]   INT IDENTITY (1, 1) NOT NULL,
[LiabilityBankerGUID] UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
[BankerName]        NVARCHAR (256)   NULL,
[CreatedBy]         NVARCHAR (256)   NULL,
[CreatedDate]       DATETIME         NULL,
[UpdatedBy]         NVARCHAR (256)   NULL,
[UpdatedDate]       DATETIME         NULL,

CONSTRAINT [PK_LiabilityBankerID] PRIMARY KEY CLUSTERED ([LiabilityBankerID] ASC)
);