CREATE TYPE [dbo].[TableTypeServicerDropDateSetup] AS TABLE (
    [ServicerDropDateSetupID] UNIQUEIDENTIFIER NULL,
    [NoteID]                  UNIQUEIDENTIFIER NULL,
    [ModeledPMTDropDate]      DATE             NULL,
    [PMTDropDateOverride]     DATE             NULL);

