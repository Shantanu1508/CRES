CREATE TABLE [App].[CalcLog] (
    [CalcLogID]   INT            IDENTITY (1, 1) NOT NULL,
    [Msg1]        VARCHAR (MAX)  NULL,
    [Msg2]        VARCHAR (MAX)  NULL,
    [Msg3]        VARCHAR (MAX)  NULL,
    [Msg4]        VARCHAR (MAX)  NULL,
    [Msg5]        VARCHAR (MAX)  NULL,
    [Msg6]        VARCHAR (MAX)  NULL,
    [Msg7]        VARCHAR (MAX)  NULL,
    [Msg8]        VARCHAR (MAX)  NULL,
    [Msg9]        VARCHAR (MAX)  NULL,
    [Msg10]       VARCHAR (MAX)  NULL,
    [CreatedBy]   NVARCHAR (256) NULL,
    [CreatedDate] DATETIME       NULL,
    CONSTRAINT [PK_CalcLogID] PRIMARY KEY CLUSTERED ([CalcLogID] ASC)
);

