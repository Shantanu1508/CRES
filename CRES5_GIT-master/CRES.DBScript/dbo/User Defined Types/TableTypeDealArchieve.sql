CREATE TYPE [dbo].[TableTypeDealArchieve] AS TABLE (
    [DealFundingID] UNIQUEIDENTIFIER NULL,
    [DealID]        UNIQUEIDENTIFIER NULL,
    [Date]          DATE             NULL,
    [Value]         DECIMAL (28, 15) NULL,
    [Comment]       NVARCHAR (256)   NULL,
    [PurposeID]     INT              NULL,
    [CreatedBy]     VARCHAR (256)    NULL,
    [CreatedDate]   VARCHAR (256)    NULL,
    [UpdatedBy]     VARCHAR (256)    NULL,
    [UpdatedDate]   VARCHAR (256)    NULL);

