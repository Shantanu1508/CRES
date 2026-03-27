CREATE TABLE [CRE].[DealRelationship] (
    [DealRelationshipID] INT IDENTITY NOT NULL,
	[DealID]             UNIQUEIDENTIFIER NOT NULL,
    [RelationshipID]     INT              NOT NULL,
    [LinkedDealID]       UNIQUEIDENTIFIER NOT NULL,
    [CreatedBy]          NVARCHAR (256)   NULL,
    [CreatedDate]        DATETIME         NULL,
    [UpdatedBy]          NVARCHAR (256)   NULL,
    [UpdatedDate]        DATETIME         NULL
);