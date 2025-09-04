CREATE TABLE [CRE].[WFTaskAdditionalDetail] (
    [WFTaskAdditionalDetailID] INT            IDENTITY (1, 1) NOT NULL,    
    [TaskID]                   NVARCHAR (MAX) NULL,
    [SpecialInstruction]       NVARCHAR (MAX) NULL,
    [AdditionalComment]        NVARCHAR (MAX) NULL,
    [CreatedBy]                NVARCHAR (256) NULL,
    [CreatedDate]              DATETIME       NULL,
    [UpdatedBy]                NVARCHAR (256) NULL,
    [UpdatedDate]              DATETIME       NULL,
    [TaskTypeID]               INT NULL,
    [ExitFee]                  DECIMAL (28, 15) NULL,
    [ExitFeePercentage]                  DECIMAL (28, 15) NULL,
    [PrepayPremium]                  DECIMAL (28, 15) NULL,
    [FCApprover]               UNIQUEIDENTIFIER NULL,
    [AdditionalEmail]          NVARCHAR (500) NULL,
    [AdditionalEmailUpdatedDate]              DATETIME       NULL,
    CONSTRAINT [PK_WFTaskAdditionalDetailID] PRIMARY KEY CLUSTERED ([WFTaskAdditionalDetailID] ASC)
);

