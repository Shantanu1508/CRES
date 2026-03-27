CREATE TABLE [DW].[WFTaskDetailBI] (
    [WFTaskDetailID]           INT            NOT NULL,
    [WFStatusPurposeMappingID] INT            NULL,
    [TaskID]                   NVARCHAR (256) NULL,
    [TaskTypeID]               INT            NULL,
    [TaskTypeBI]               NVARCHAR (256) NULL,
    [Comment]                  NVARCHAR (MAX) NULL,
    [SubmitType]               INT            NULL,
    [SubmitTypeBI]             NVARCHAR (256) NULL,
    [CreatedBy]                NVARCHAR (256) NULL,
    [CreatedDate]              DATETIME       NULL,
    [UpdatedBy]                NVARCHAR (256) NULL,
    [UpdatedDate]              DATETIME       NULL,
    [IsDeleted]                BIT            DEFAULT ((0)) NOT NULL,
    [DelegatedUserID]          NVARCHAR (256) NULL,
    [SpecialInstruction]       NVARCHAR (MAX) NULL,
    [AdditionalComment]        NVARCHAR (MAX) NULL,
    [WFGroupText]              NVARCHAR (256) NULL,
    [StatusName]               NVARCHAR (256) NULL,
    [StatusDisplayName]        NVARCHAR (256) NULL,
    [DealFundingDisplayName]   NVARCHAR (256) NULL,
    [WFUnderReviewDisplayName] NVARCHAR (256) NULL,
    [WFFinalStatus]            NVARCHAR (256) NULL,
    [WFTaskDetailBI_AutoID]    INT            IDENTITY (1, 1) NOT NULL,

    Username nvarchar(256) null,
    WFStatusMasterID int null,
    FundingDate date,
    PurposeID int,
    PurposeText nvarchar(256),
    Amount decimal(28,15)

    CONSTRAINT [PK_WFTaskDetailBI_AutoID] PRIMARY KEY CLUSTERED ([WFTaskDetailBI_AutoID] ASC)
);



