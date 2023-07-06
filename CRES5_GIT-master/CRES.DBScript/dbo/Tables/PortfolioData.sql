CREATE TABLE [dbo].[PortfolioData] (
    [data_date] DATETIME2 (7) NOT NULL,
    [lnkey]     NVARCHAR (50) NOT NULL,
    [investor]  NVARCHAR (50) NOT NULL,
    [upb]       FLOAT (53)    NOT NULL,
    CONSTRAINT [PK_PortfolioData] PRIMARY KEY CLUSTERED ([data_date] ASC, [lnkey] ASC)
);

