CREATE TABLE [dbo].[tblNoteTransfer_Hisory] (
    [DealID]             UNIQUEIDENTIFIER NULL,
    [noteid]             UNIQUEIDENTIFIER NULL,
    [eventid]            UNIQUEIDENTIFIER NULL,
    [FundingScheduleID]  UNIQUEIDENTIFIER NULL,
    [dealname]           NVARCHAR (256)   NULL,
    [credealid]          NVARCHAR (256)   NULL,
    [crenoteid]          NVARCHAR (256)   NULL,
    [effectiveStartdate] DATE             NULL,
    [date]               DATE             NULL,
    [value]              DECIMAL (28, 15) NULL,
    [PurposeType]        NVARCHAR (256)   NULL
);

