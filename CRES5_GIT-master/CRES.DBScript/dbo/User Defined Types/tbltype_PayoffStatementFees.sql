CREATE TYPE [dbo].[tbltype_PayoffStatementFees] AS TABLE (
   [PayoffStatementFeesID]  INT NULL,
   [DealID]          UNIQUEIDENTIFIER NULL,
   [FeeName]   NVARCHAR (256)   NULL,
   [FeeType]  int ,
   [Value]  DECIMAL (28, 15) NULL,
   [Comment]   NVARCHAR (256)   NULL
);