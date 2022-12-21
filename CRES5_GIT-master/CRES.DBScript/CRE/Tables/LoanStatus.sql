Create table cre.LoanStatus
(
	LoanStatusID int IDENTITY (1, 1) NOT NULL,
	LoanStatusCd nvarchar(5)	null,
	LoanStatusDesc	nvarchar(256)	null,
	OrderKey int null

CONSTRAINT [PK_LoanStatusID] PRIMARY KEY CLUSTERED ([LoanStatusID] ASC),
)


