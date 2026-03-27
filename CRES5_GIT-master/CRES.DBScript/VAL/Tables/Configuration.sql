CREATE TABLE [VAL].[Configuration] (
    ConfigurationID    INT    IDENTITY (1, 1) NOT NULL,	
    [Env]   NVARCHAR (256) NULL,
    [Key]   NVARCHAR (256) NULL,
    [Value] NVARCHAR (max) NULL

    CONSTRAINT [PK_Configuration_ConfigurationID] PRIMARY KEY CLUSTERED ([ConfigurationID] ASC),
);
GO

