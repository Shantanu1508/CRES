CREATE TABLE [CRE].[WFRejectStatus] (
    [WFRejectStatusID] INT            IDENTITY (1, 1) NOT NULL,
    [WFStatusMasterID] INT            NULL,
    [SearchKey]        NVARCHAR (256) NULL,
    [PurposeTypeID]    INT            NULL,
    CONSTRAINT [PK_WFRejectStatusID] PRIMARY KEY CLUSTERED ([WFRejectStatusID] ASC)
);

