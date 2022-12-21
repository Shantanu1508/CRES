
CREATE TYPE [dbo].[tbltype_PayRuleDist_V1] AS TABLE (
	[Date]            DATE             NULL,
	[Note] NVARCHAR (256)   NULL,
	[Type] NVARCHAR (256)   NULL,
	[value]          DECIMAL (28, 15) NULL,
	[Rate]          DECIMAL (28, 15) NULL,
	[EffectiveDate]          date null,
	[FeeName]         NVARCHAR (256)   NULL,
	SourceNoteID NVARCHAR (256)   NULL
  
);



