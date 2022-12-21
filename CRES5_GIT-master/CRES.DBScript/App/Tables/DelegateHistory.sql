CREATE TABLE [App].[DelegateHistory] (
    [DelegateHistoryID] UNIQUEIDENTIFIER CONSTRAINT [DF__DelegateH__Deleg__025333F4] DEFAULT (newid()) NOT NULL,
    [DelegatedUserID]   UNIQUEIDENTIFIER NOT NULL,
    [UserID]            UNIQUEIDENTIFIER NOT NULL,
    [SessionStartDate]  DATETIME         NULL,
    [SessionEndDate]    DATETIME         NULL,
    [SessionStatus]     INT              NULL,
    [EntryType]         INT              NULL,
    [CreatedBy]         NVARCHAR (256)   NULL,
    [CreatedDate]       DATETIME         CONSTRAINT [DF__DelegateH__Creat__0347582D] DEFAULT (getdate()) NULL,
    [UpdatedBy]         NVARCHAR (256)   NULL,
    [UpdatedDate]       DATETIME         CONSTRAINT [DF__DelegateH__Updat__043B7C66] DEFAULT (getdate()) NULL,
    DelegateHistoryID_autoid int identity(1,1)
);
go
ALTER TABLE [App].[DelegateHistory]
ADD CONSTRAINT PK_DelegateHistory_DelegateHistoryID_autoid PRIMARY KEY (DelegateHistoryID_autoid);