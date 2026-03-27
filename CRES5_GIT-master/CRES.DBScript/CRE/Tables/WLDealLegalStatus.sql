CREATE TABLE [CRE].[WLDealLegalStatus] (
    [WLDealLegalStatusID] INT              IDENTITY (1, 1) NOT NULL,
    [DealID]              UNIQUEIDENTIFIER NOT NULL,
    [StartDate]           DATETIME            NULL,
    [Comment]             NVARCHAR (MAX)   NULL,
    [CreatedBy]           NVARCHAR (256)   NULL,
    [CreatedDate]         DATETIME         NULL,
    [UpdatedBy]           NVARCHAR (256)   NULL,
    [UpdatedDate]         DATETIME         NULL,
    [Type]                NVARCHAR (256)   NULL,
    [ReasonCode]          NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_WLDealLegalStatusID] PRIMARY KEY CLUSTERED ([WLDealLegalStatusID] ASC),
    CONSTRAINT [FK_WLDealLegalStatus_DealID] FOREIGN KEY ([DealID]) REFERENCES [CRE].[Deal] ([DealID])
);



