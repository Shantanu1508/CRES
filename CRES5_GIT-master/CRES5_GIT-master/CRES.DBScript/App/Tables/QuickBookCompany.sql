CREATE TABLE [App].[QuickBookCompany] (
    [QuickBookCompanyID] INT            IDENTITY (1, 1) NOT NULL,
    [Name]               NVARCHAR (256) NULL,
    [EndPointID]         NVARCHAR (256) NULL,
    [AutofyCompanyID]    NVARCHAR (256) NULL,
    [CreatedBy]          NVARCHAR (256) NULL,
    [CreatedDate]        DATETIME       NULL,
    [UpdatedBy]          NVARCHAR (256) NULL,
    [UpdatedDate]        DATETIME       NULL, 
    [IsActive]           BIT            DEFAULT ((1)) NOT NULL
);
go

ALTER TABLE [App].[QuickBookCompany]
ADD CONSTRAINT PK_QuickBookCompany_QuickBookCompanyID PRIMARY KEY (QuickBookCompanyid);
