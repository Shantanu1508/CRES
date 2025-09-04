CREATE TYPE [dbo].[tbltype_PrepaymentGroupSetup] AS TABLE (
   [PrepaymentGroupSetupID]  INT NULL,
   [DealID]          UNIQUEIDENTIFIER NULL,
   [GroupId]         INT NULL,
   [AttributeName]   NVARCHAR (256)   NULL,
   [AttributeValue]  DECIMAL (28, 15) NULL,
   [IsDeleted]       INT              NULL
);