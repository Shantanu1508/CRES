CREATE TABLE [App].[FastFunction] (
    [FunctionID]   UNIQUEIDENTIFIER CONSTRAINT [DF__FastFunct__Funct__162F4418] DEFAULT (newid()) NOT NULL,
    [FunctionName] NVARCHAR (256)   NULL,
    [FunctionType] INT              CONSTRAINT [DF__FastFunct__Funct__17236851] DEFAULT ((1)) NOT NULL,
    [CreatedBy]    NVARCHAR (256)   NULL,
    [CreatedDate]  DATETIME         NULL,
    [UpdatedBy]    NVARCHAR (256)   NULL,
    [UpdatedDate]  DATETIME         NULL,
    [IsDefault]    BIT              CONSTRAINT [DF__FastFunct__IsDef__18178C8A] DEFAULT ((0)) NOT NULL
);

