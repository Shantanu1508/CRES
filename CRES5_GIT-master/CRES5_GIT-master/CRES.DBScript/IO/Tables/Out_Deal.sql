CREATE TABLE [IO].[Out_Deal] (
    [Out_DealID]  UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [BatchLogID]  UNIQUEIDENTIFIER NOT NULL,
    [CreatedBy]   NVARCHAR (256)   NULL,
    [CreatedDate] DATETIME         NULL,
    [UpdatedBy]   NVARCHAR (256)   NULL,
    [UpdatedDate] DATETIME         NULL,
    CONSTRAINT [PK_Out_DealID] PRIMARY KEY CLUSTERED ([Out_DealID] ASC)
);

