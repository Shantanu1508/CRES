CREATE TABLE [CRE].[CashFlow_V1] (

[CashFlow_V1]      INT              IDENTITY (1, 1) NOT NULL,
[Date]                        DATETIME         NULL,
[Note]                      NVARCHAR (256)   NULL,
[Type]                        NVARCHAR (256)   NULL,
[Value]                      DECIMAL (28, 15) NULL,
[FeeName]                     NVARCHAR (256)   NULL,
[Rate]                      DECIMAL (28, 15) NULL,
[CreatedBy]                   NVARCHAR (256)   NULL,
[CreatedDate]                 DATETIME         NULL,
[UpdatedBy]                   NVARCHAR (256)   NULL,
[UpdatedDate]                 DATETIME         NULL,
[AnalysisID]                  UNIQUEIDENTIFIER NULL    
  
CONSTRAINT [PK_CashFlow_V1] PRIMARY KEY CLUSTERED (CashFlow_V1 ASC)
);

