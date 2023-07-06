CREATE TABLE [dbo].[HBOT_AutoComplete] (
    [ID]        INT           IDENTITY (1, 1) NOT NULL,
    [TAG]       VARCHAR (55)  NOT NULL,
    [QUES]      VARCHAR (300) NOT NULL,
    [PARAMETER] VARCHAR (300) NOT NULL,
    [isActive]  INT           NOT NULL,
    CONSTRAINT [PK_ID] PRIMARY KEY CLUSTERED ([ID] ASC)
);

