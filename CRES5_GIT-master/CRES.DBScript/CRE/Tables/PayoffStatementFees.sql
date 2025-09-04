CREATE TABLE [CRE].[PayoffStatementFees] (
   [PayoffStatementFeesID]    INT IDENTITY (1, 1) NOT NULL,  
   [DealID]          UNIQUEIDENTIFIER NULL, 
   [FeeName]   NVARCHAR (256)   NULL,
   [FeeType]  int ,
   [Value]  DECIMAL (28, 15) NULL,
   [CreatedBy]       NVARCHAR (256)   NULL,
   [CreatedDate]     DATETIME         NULL,
   [UpdatedBy]       NVARCHAR (256)   NULL,
   [UpdatedDate]     DATETIME         NULL,
   [Comment]		 NVARCHAR (max)   NULL

   CONSTRAINT [PK_PayoffStatementFeesID] PRIMARY KEY CLUSTERED ([PayoffStatementFeesID] ASC)
);

