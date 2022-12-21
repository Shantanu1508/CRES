CREATE TYPE [dbo].[TableTypeMaturityData] AS TABLE (
	DealID uniqueidentifier,
	NoteID uniqueidentifier,
	EffectiveDate  Date ,
	MaturityDate Date null,
	MaturityType int null,
	Approved int null,
	IsDeleted bit null,
	ActualPayoffDate      Date ,
	ExpectedMaturityDate  Date ,
	OpenPrepaymentDate	  Date ,
	CRENoteID nvarchar(256),
	MaturityMethodID int null
);


