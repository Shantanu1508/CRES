CREATE TABLE [IO].[IN_AcctDeal] (
    [ControlId]        NVARCHAR (10)    NOT NULL,
    [DealName]         NVARCHAR (75)    NOT NULL,
    [AssetManager]     NVARCHAR (75)    NULL,
    [CommitmentAmount] DECIMAL (28, 12) NULL,
    [ShardName]        NVARCHAR (MAX)   NULL
);

