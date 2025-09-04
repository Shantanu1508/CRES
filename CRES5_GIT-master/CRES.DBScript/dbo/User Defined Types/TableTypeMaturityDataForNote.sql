CREATE TYPE [dbo].[TableTypeMaturityDataForNote] AS TABLE (
	NoteID uniqueidentifier,	
	EffectiveDate date,		
	MaturityDate Date null,
	MaturityType int null,
	Approved int null,
	IsDeleted bit null,

	ActualPayoffDate      Date ,
	ExpectedMaturityDate  Date ,
	OpenPrepaymentDate	  Date ,
	ExtensionType int
);

