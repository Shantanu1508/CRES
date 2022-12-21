CREATE TABLE [dbo].[BasisBatchRunDetailStaging] (
    [DealID]           NVARCHAR (50)   NOT NULL,
    [DealName]         NVARCHAR (100)  NOT NULL,
    [Noteid]           NVARCHAR (50)   NOT NULL,
    [To_be_Amortized]  FLOAT (53)      NOT NULL,
    [SL_Amort]         FLOAT (53)      NOT NULL,
    [PVAmort]          FLOAT (53)      NOT NULL,
    [GAAPAmort]        FLOAT (53)      NOT NULL,
    [Delta_SL_Amort]   FLOAT (53)      NOT NULL,
    [Delta_PV_Amort]   FLOAT (53)      NOT NULL,
    [Delta_GAAP_Amort] FLOAT (53)      NOT NULL,
    [CalcStatus]       NVARCHAR (50)   NOT NULL,
    [Type]             NVARCHAR (50)   NULL,
    [errormessage]     NVARCHAR (1000) NULL
);

