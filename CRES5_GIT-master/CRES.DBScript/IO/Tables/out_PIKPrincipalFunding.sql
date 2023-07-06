CREATE TABLE [IO].[out_PIKPrincipalFunding] (
    [out_PIKPrincipalFundingID] INT              IDENTITY (1, 1) NOT NULL,
    [CRENoteID]                 NVARCHAR (256)   NULL,
    [FundingDate]               DATE             NULL,
    [FundingAmount]             DECIMAL (28, 12) NULL,
    [Comments]                  NVARCHAR (MAX)   NULL,
    [FundingPurpose]            NVARCHAR (256)   NULL,
    [AuditUserName]             NVARCHAR (256)   NULL,
    [ExportTimeStamp]           DATETIME         NULL,
    [Status]                    NVARCHAR (256)   NULL,
    [Applied]                   BIT              NULL,
    [WireConfirm]               BIT              NULL,
    [DrawFundingId]             NVARCHAR (256)   NULL,
    [WF_CurrentStatus]          NVARCHAR (256)   NULL,
    [PIKReasonCode]             NVARCHAR (256)   NULL
);

go

ALTER TABLE [IO].out_PIKPrincipalFunding
ADD CONSTRAINT PK_out_PIKPrincipalFunding PRIMARY KEY (out_PIKPrincipalFundingid);