CREATE TABLE [dbo].[tblPayOffPayDown] (
    [DealFundingID]     UNIQUEIDENTIFIER NULL,
    [FundingScheduleID] UNIQUEIDENTIFIER NULL,
    [SNO]               INT              NULL,
    [DealID]            UNIQUEIDENTIFIER NULL,
    [noteid]            UNIQUEIDENTIFIER NULL,
    [credealid]         NVARCHAR (256)   NULL,
    [dealname]          NVARCHAR (256)   NULL,
    [crenoteid]         NVARCHAR (256)   NULL,
    [DealF_Date]        DATE             NULL,
    [DealF_Amount]      DECIMAL (28, 15) NULL,
    [FF_Date]           DATE             NULL,
    [FF_Amount]         DECIMAL (28, 15) NULL,
    [PurposeText]       NVARCHAR (256)   NULL,
    [Comment]           NVARCHAR (MAX)   NULL,
    [WireConfirm]       INT              NULL,
    [Actualpayoffdate]  DATE             NULL,
    [Balloon]           DECIMAL (28, 15) NULL,
    [EndingBalance]     DECIMAL (28, 15) NULL,
    [M61Purpose]        NVARCHAR (256)   NULL,
    [M61PurposeID]      INT              NULL
);

