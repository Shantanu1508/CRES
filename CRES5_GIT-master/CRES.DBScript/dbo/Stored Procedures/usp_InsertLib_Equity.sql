-- Procedure
-- Procedure

CREATE PROCEDURE [dbo].[usp_InsertLib_Equity]
(
	@tbltype_Lib [TableTypeLib_Equity] READONLY
)
AS
BEGIN
	TRUNCATE TABLE [dbo].[Lib_Equity];
	
	INSERT INTO [dbo].[Lib_Equity]([Equity Name],[Equity Type],[Status],[Currency],[Investor Capital ],[Capital Reserve Requirement],[Reserve Requirement],
		[Capital Call Notice Business Days ],[Inception Date ],[Last Date to Invest ],[Linked Short Term Borrowing Facility ],[Commitment ],[Initial Maturity Date]) 
	
	SELECT [EquityName],[EquityType],[Status],[Currency],[InvestorCapital],[CapitalReserveRequirement],[ReserveRequirement],
		[CapitalCallNoticeBusinessDays],[InceptionDate],[LastDatetoInvest],[LinkedShortTermBorrowingFacility],[Commitment],[InitialMaturityDate] FROM @tbltype_Lib;


		---------------------------------------------

	Truncate table [dbo].[Equity$]

	INSERT INTO [dbo].[Equity$]([Equity Name],[Equity Type],[Status],[Currency],[Investor Capital ],[Capital Reserve Requirement],[Reserve Requirement],
		[Capital Call Notice Business Days ],[Inception Date ],[Last Date to Invest ],[Linked Short Term Borrowing Facility ],[Commitment ],[Initial Maturity Date]) 
	
	SELECT 
	 NULLIF([Equity Name]								,'') as [Equity Name]
	,NULLIF([Equity Type]								,'') as [Equity Type]
	,NULLIF([Status]									,'') as [Status]
	,NULLIF([Currency]									,'') as [Currency]
	,NULLIF([Investor Capital ]						,'') as [Investor Capital ]
	,NULLIF([Capital Reserve Requirement]				,'') as [Capital Reserve Requirement]
	,NULLIF([Reserve Requirement]						,'') as [Reserve Requirement]
	,NULLIF([Capital Call Notice Business Days ]		,'') as [Capital Call Notice Business Days ]
	,NULLIF([Inception Date ]							,'') as [Inception Date ]
	,NULLIF([Last Date to Invest ]						,'') as [Last Date to Invest ]
	,NULLIF([Linked Short Term Borrowing Facility ]	,'') as [Linked Short Term Borrowing Facility ]
	,NULLIF([Commitment ]								,'') as [Commitment ]
	,NULLIF([Initial Maturity Date]					,'') as [Initial Maturity Date]
	FROM [dbo].[Lib_Equity];

END