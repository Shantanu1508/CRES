CREATE TABLE [App].[UserDelegateConfig] (
    [UserDelegateConfigID] UNIQUEIDENTIFIER CONSTRAINT [DF__UserDeleg__UserD__0623C4D8] DEFAULT (newid()) NOT NULL,
    [UserID]               UNIQUEIDENTIFIER NOT NULL,
    [DelegatedUserID]      UNIQUEIDENTIFIER NOT NULL,
    [StartDate]            DATE             NULL,
    [EndDate]              DATE             NULL,
    [IsActive]             BIT              NULL,
    [CreatedBy]            NVARCHAR (256)   NULL,
    [CreatedDate]          DATETIME         CONSTRAINT [DF__UserDeleg__Creat__0717E911] DEFAULT (getdate()) NULL,
    [UpdatedBy]            NVARCHAR (256)   NULL,
    [UpdatedDate]          DATETIME         CONSTRAINT [DF__UserDeleg__Updat__080C0D4A] DEFAULT (getdate()) NULL,
    UserDelegateConfig_autoid int identity(1,1)
);

go
ALTER TABLE [App].[UserDelegateConfig]
ADD CONSTRAINT PK_UserDelegateConfig_UserDelegateConfig_autoid PRIMARY KEY (UserDelegateConfig_autoid);