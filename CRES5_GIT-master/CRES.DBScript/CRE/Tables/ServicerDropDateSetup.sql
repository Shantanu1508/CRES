CREATE TABLE [CRE].[ServicerDropDateSetup] (
    [ServicerDropDateSetupID] UNIQUEIDENTIFIER CONSTRAINT [DF__ServicerD__Servi__1EF99443] DEFAULT (newid()) NOT NULL,
    [NoteID]                  UNIQUEIDENTIFIER NOT NULL,
    [ModeledPMTDropDate]      DATE             NULL,
    [PMTDropDateOverride]     DATE             NULL,
    [CreatedBy]               NVARCHAR (256)   NULL,
    [CreatedDate]             DATETIME         NULL,
    [UpdatedBy]               NVARCHAR (256)   NULL,
    [UpdatedDate]             DATETIME         NULL,
    CONSTRAINT [PK_ServicerDropDateSetupID] PRIMARY KEY CLUSTERED ([ServicerDropDateSetupID] ASC)
);

