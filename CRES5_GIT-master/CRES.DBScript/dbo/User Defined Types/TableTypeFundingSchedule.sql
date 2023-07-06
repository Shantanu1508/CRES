CREATE TYPE [dbo].[TableTypeFundingSchedule] AS TABLE (
    [NoteID]           UNIQUEIDENTIFIER NULL,
    [Value]            DECIMAL (28, 12) NULL,
    [Date]             DATE             NULL,
    [PurposeID]        INT              NULL,
    [AccountId]        NVARCHAR (MAX)   NULL,
    [Applied]          BIT              NULL,
    [DrawFundingId]    NVARCHAR (256)   NULL,
    [Comments]         NVARCHAR (256)   NULL,
    [DealFundingRowno] INT              NULL,
    [isDeleted]        INT              NULL,
    [WF_CurrentStatus] NVARCHAR (256)   NULL,
    [GeneratedBy]  INT   NULL);

