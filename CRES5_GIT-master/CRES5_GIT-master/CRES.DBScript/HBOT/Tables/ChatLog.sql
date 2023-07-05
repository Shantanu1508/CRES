CREATE TABLE [HBOT].[ChatLog] (
    [ChatLogID]   INT            IDENTITY (1, 1) NOT NULL,
    [Status]      NVARCHAR (256) NULL,
    [Question]    NVARCHAR (MAX) NULL,
    [CreatedBy]   NVARCHAR (256) NULL,
    [CreatedDate] DATETIME       NULL,
    [ParentId]    INT            NULL,
    [IntentName]  NVARCHAR (256) NULL,
    [SentBy]      NVARCHAR (256) NULL,
	[SessionID]   NVARCHAR (256) NULL,
    CONSTRAINT [PK_ChatLogID] PRIMARY KEY CLUSTERED ([ChatLogID] ASC)
);

