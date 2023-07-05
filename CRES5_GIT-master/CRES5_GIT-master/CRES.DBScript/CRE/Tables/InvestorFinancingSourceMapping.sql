CREATE TABLE [CRE].[InvestorFinancingSourceMapping] (
    [InvestorFinancingSourceMappingID] INT            IDENTITY (1, 1) NOT NULL,
    [ClientID]                         INT            NULL,
    [FinancingSourceID]                INT            NULL,
    [WellsInvestorID]                  NVARCHAR (256) NULL,
    [AcoreInvestorID]                  NVARCHAR (256) NULL,
    CONSTRAINT [PK_InvestorFinancingSourceMappingID] PRIMARY KEY CLUSTERED ([InvestorFinancingSourceMappingID] ASC)
);

