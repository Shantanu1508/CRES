CREATE TABLE [dbo].[BasisBatchRunDetail] (
    [CRENoteID]    NVARCHAR (256) NULL,
    [CREDealID]    NVARCHAR (256) NULL,
    [DealName]     NVARCHAR (256) NULL,
    [Status]       NVARCHAR (256) NOT NULL,
    [ErrorMessage] NVARCHAR (MAX) NULL
);

