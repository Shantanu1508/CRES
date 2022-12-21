
CREATE TYPE [dbo].[tbltype_CashFlow_V1] AS TABLE (
	[Date]            DATE             NULL,
	[Note] NVARCHAR (256)   NULL,
	[Type] NVARCHAR (256)   NULL,
	[value]          DECIMAL (28, 15) NULL,
	[FeeName]         NVARCHAR (256)   NULL,
	Rate	DECIMAL (28, 15) NULL
  
);
