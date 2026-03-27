CREATE TABLE [DW].[InterimDropDateBI] (
    [CRENoteID]                 NVARCHAR (256)   NULL,
    [Date]                      DATE             NULL,
    [Amount]                    DECIMAL (28, 15) NULL,
    [NextAccrualDate]           DATE             NULL,
    [PreviousAccrual]           DATE             NULL,
    [Purpose]                   NVARCHAR (256)   NULL,
    [PrevioustoPreviousAccrual] DATE             NULL,
    [NexttoNextAccrual]         DATE             NULL,
    [InterimDropDateBI_AutoID]  INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_InterimDropDateBI_AutoID] PRIMARY KEY CLUSTERED ([InterimDropDateBI_AutoID] ASC)
);



