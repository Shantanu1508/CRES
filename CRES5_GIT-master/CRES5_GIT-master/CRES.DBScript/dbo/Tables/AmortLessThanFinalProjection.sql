CREATE TABLE [dbo].[AmortLessThanFinalProjection] (
    [DealName]                                           VARCHAR (100)    NULL,
    [Noteid]                                             VARCHAR (100)    NULL,
    [PrincipalTransactionsExcludeScheduleAmort]          DECIMAL (28, 15) NULL,
    [Scheduleprincpal]                                   DECIMAL (28, 15) NULL,
    [SchedulePrincipal_Plus_RestofPrincipalTransactions] DECIMAL (28, 15) NULL,
    [ProjectedFullPayoff]                                VARCHAR (100)    NULL
);

