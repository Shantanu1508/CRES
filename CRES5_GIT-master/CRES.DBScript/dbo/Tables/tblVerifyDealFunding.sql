CREATE TABLE [dbo].[tblVerifyDealFunding] (
    [DealFundingID]     UNIQUEIDENTIFIER NULL,
    [DealID]            UNIQUEIDENTIFIER NULL,
    [Date]              DATE             NULL,
    [Value]             DECIMAL (28, 15) NULL,
    [PurposeText]       NVARCHAR (256)   NULL,
    [SNO]               INT              NULL,
    [FundingScheduleID] UNIQUEIDENTIFIER NULL,
    [Comment]           NVARCHAR (256)   NULL,
    [FF_Date]           DATE             NULL,
    [FF_Amount]         DECIMAL (28, 15) NULL,
    [crenoteid]         NVARCHAR (256)   NULL,
    [credealid]         NVARCHAR (256)   NULL,
    [dealname]          NVARCHAR (256)   NULL,
    [WireConfirm]       INT              NULL,
    [noteid]            UNIQUEIDENTIFIER NULL
);

