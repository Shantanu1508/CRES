CREATE TABLE [IO].[IN_AcctProperty] (
    [ControlId]             NVARCHAR (10)  NOT NULL,
    [PropertyId]            INT            NULL,
    [PropertyName]          NVARCHAR (MAX) NULL,
    [City]                  NVARCHAR (MAX) NULL,
    [State]                 NVARCHAR (MAX) NULL,
    [PropertyTypeMajorCd_F] NVARCHAR (MAX) NULL,
    [PropertyTypeMajorDesc] NVARCHAR (MAX) NULL,
    [ShardName]             NVARCHAR (MAX) NULL
);

