CREATE TYPE [dbo].[tblPrepayPremiumoutput] AS TABLE (
    [prepaydate]     DATE             NULL,
    [prepaypremium]  DECIMAL (28, 15) NULL,
    [openprepaydate] DATE             NULL,
    [bal]            DECIMAL (28, 15) NULL,
    [DealID]         VARCHAR (256)    NULL);
GO

