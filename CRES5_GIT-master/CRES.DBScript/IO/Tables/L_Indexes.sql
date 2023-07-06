CREATE TABLE [IO].[L_Indexes] (
    [IndexID]     INT              IDENTITY (1, 1) NOT NULL,
    [Date]        DATE             NULL,
    [IndexType]   INT              NULL,
    [Value]       DECIMAL (28, 15) NULL,
    [CreatedBy]   NVARCHAR (256)   NULL,
    [CreatedDate] DATETIME         NULL,
    [UpdatedBy]   NVARCHAR (256)   NULL,
    [UpdatedDate] DATETIME         NULL
);

go

ALTER TABLE [IO].[L_Indexes]
ADD CONSTRAINT PK_L_Indexes_L_IndexesID PRIMARY KEY ([IndexID]);