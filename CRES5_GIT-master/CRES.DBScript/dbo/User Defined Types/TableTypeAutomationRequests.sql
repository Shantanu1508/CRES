
CREATE TYPE [dbo].[TableTypeAutomationRequests] AS TABLE (
    [DealID]				UNIQUEIDENTIFIER  NULL,
    [StatusText]        NVARCHAR (256)   NULL,    
    AutomationType          INT              NULL);
