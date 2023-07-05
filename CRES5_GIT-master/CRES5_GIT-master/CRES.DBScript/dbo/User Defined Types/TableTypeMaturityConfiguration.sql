CREATE TYPE [dbo].[TableMaturityConfiguration] AS TABLE
(
	DealID UNIQUEIDENTIFIER,
	CRENoteID nvarchar(256),
	MaturityMethodID INT, 
	MaturityGroupName nvarchar(256)
)
