CREATE TABLE [CRE].[YieldCalcInput]
(
	[YieldCalcInputID]    INT  IDENTITY (1, 1) NOT NULL,
    [CRENoteID]  NVARCHAR (256) NULL,
    [NPVdate]      Date	        NULL,
	[Value] decimal(28,15)  NULL,
	[Effectivedate] date null,
	AnalysisID Uniqueidentifier null,
	YieldType   NVARCHAR (256) NULL,
    [CreatedBy]   NVARCHAR (256) NULL,
    [CreatedDate] DATETIME       NULL,
    [UpdatedBy]   NVARCHAR (256) NULL,
    [UpdatedDate] DATETIME       NULL
    CONSTRAINT [PK_YieldCalcInputID] PRIMARY KEY CLUSTERED ([YieldCalcInputID] ASC)
);
