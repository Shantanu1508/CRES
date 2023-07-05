CREATE TABLE [CRE].[Servicer] (
    [ServicerID]             INT              IDENTITY (1, 1) NOT NULL,
    [ServicerGUID]           UNIQUEIDENTIFIER CONSTRAINT [DF__Servicer__Servic__1C1D2798] DEFAULT (newid()) NOT NULL,
    [ServicerName]           NVARCHAR (256)   NULL,
    [ServicerDropDate]       INT              NULL,
    [ServicereDayAjustement] INT              NULL,
    [isDefault]              BIT              NULL,
    [CreatedBy]              NVARCHAR (256)   NULL,
    [CreatedDate]            DATETIME         NULL,
    [UpdatedBy]              NVARCHAR (256)   NULL,
    [UpdatedDate]            DATETIME         NULL,
    [EmailID]                NVARCHAR (256)   NULL,
    [RepaymentDropDate]      INT              NULL,
    CONSTRAINT [PK_ServicerID] PRIMARY KEY CLUSTERED ([ServicerID] ASC)
);

