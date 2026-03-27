CREATE TABLE [IO].[out_FutureFunding] (
    [CRENoteID]           NVARCHAR (MAX)   NULL,
    [FundingDate]         DATE             NULL,
    [FundingAmount]       DECIMAL (28, 12) NULL,
    [Comments]            NVARCHAR (MAX)   NULL,
    [FundingPurpose]      NVARCHAR (MAX)   NULL,
    [AuditUserName]       NVARCHAR (MAX)   NULL,
    [ExportTimeStamp]     DATETIME         NULL,
    [Status]              NVARCHAR (MAX)   NULL,
    [Applied]             BIT              NULL,
    [WireConfirm]         BIT              NULL,
    [DrawFundingId]       NVARCHAR (MAX)   NULL,
    [WF_CurrentStatus]    NVARCHAR (256)   NULL,
    [out_FutureFundingID] INT              IDENTITY (1, 1) NOT NULL,
    [DealFundingRowno]    INT              NULL,
    [DealFundingID]       UNIQUEIDENTIFIER NULL, 
    [IsProjectedPaydown] BIT NULL DEFAULT 0, 
    [GeneratedBy] INT NULL,
    [GeneratedByText] NVARCHAR (256)   NULL,
    DealID UNIQUEIDENTIFIER null,
    IsDeleted bit,
    FF_BlankJson bit null,
    AdjustmentType  NVARCHAR (256)   NULL,
    FundingAdjustmentTypeCd_F nvarchar(256)
);
go
ALTER TABLE [IO].[out_FutureFunding]
ADD CONSTRAINT PK_out_FutureFunding_out_FutureFundingID PRIMARY KEY (out_FutureFundingID);


