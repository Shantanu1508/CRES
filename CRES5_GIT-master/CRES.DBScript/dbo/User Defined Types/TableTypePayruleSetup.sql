CREATE TYPE [dbo].[TableTypePayruleSetup] AS TABLE (
    [DealID]            UNIQUEIDENTIFIER NOT NULL,
    [StripTransferFrom] UNIQUEIDENTIFIER NULL,
    [StripTransferTo]   UNIQUEIDENTIFIER NULL,
    [Value]             DECIMAL (28, 15) NULL,
    [RuleID]            INT              NULL);

