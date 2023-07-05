CREATE TABLE [App].[Logger] (
    [LoggerID]           INT           IDENTITY (1, 1) NOT NULL,
    [Severity]           NVARCHAR (50) NOT NULL,
    [Module]             VARCHAR (50)  NOT NULL,
    [Message]            VARCHAR (256) NULL,
    [Message_StackTrace] VARCHAR (MAX) NULL,
    [Priority]           VARCHAR (50)  NULL,
    [ExceptionSource]    VARCHAR (50)  NULL,
    [MethodName]         VARCHAR (100) NULL,
    [RequestText]        VARCHAR (MAX) NULL,
    [ObjectID]           VARCHAR (MAX) NULL,
    [CreatedBy]          VARCHAR (256) NULL,
    [CreatedDate]        DATETIME      NULL,
    CONSTRAINT [PK_LoggerID] PRIMARY KEY CLUSTERED ([LoggerID] ASC)
);

