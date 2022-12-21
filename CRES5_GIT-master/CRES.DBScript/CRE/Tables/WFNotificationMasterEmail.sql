CREATE TABLE [CRE].[WFNotificationMasterEmail] (
    [WFNotificationMasterEmailID] INT            IDENTITY (1, 1) NOT NULL,
    [ClientID]                    INT            NULL,
    [LookupID]                    INT            NULL,
    [EmailID]                     NVARCHAR (250) NULL,
    [ParentClient]                NVARCHAR (250) NULL,
    CONSTRAINT [PK_WFNotificationMasterEmail] PRIMARY KEY CLUSTERED ([WFNotificationMasterEmailID] ASC)
);

