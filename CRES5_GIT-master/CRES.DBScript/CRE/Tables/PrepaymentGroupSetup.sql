CREATE TABLE [CRE].[PrepaymentGroupSetup] (
   [PrepaymentGroupSetupID]    INT IDENTITY (1, 1) NOT NULL,
   [PrepaymentGroupSetupGUID]  UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
   [DealID]          UNIQUEIDENTIFIER NULL,
   [GroupId]         INT NULL,
   [AttributeName]   NVARCHAR (256)   NULL,
   [AttributeValue]  DECIMAL (28, 15) NULL,
   [CreatedBy]       NVARCHAR (256)   NULL,
   [CreatedDate]     DATETIME         NULL,
   [UpdatedBy]       NVARCHAR (256)   NULL,
   [UpdatedDate]     DATETIME         NULL,
   [IsDeleted]       INT              NULL

   CONSTRAINT [PK_PrepaymentGroupSetupID] PRIMARY KEY CLUSTERED ([PrepaymentGroupSetupID] ASC)
);