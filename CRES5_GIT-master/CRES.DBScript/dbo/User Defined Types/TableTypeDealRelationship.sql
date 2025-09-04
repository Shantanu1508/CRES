CREATE TYPE [DBO].[TableTypeDealRelationship] AS TABLE(
    [DealID]             UNIQUEIDENTIFIER NULL,
    [RelationshipID]     INT              NULL,
    [LinkedDealID]       nvarchar(256)    NULL
);