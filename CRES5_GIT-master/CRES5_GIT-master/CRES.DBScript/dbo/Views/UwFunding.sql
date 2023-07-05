

CREATE VIEW [dbo].[UwFunding] AS
SELECT 
FundingID,
Convert( Varchar(10),Noteid_F )Noteid_F,
Applied,
FundingDate,
FundingAmount,
Comments,
AuditAddDate,
AuditAddUserId,
AuditUpdateDate,
AuditUpdateUserId,
FundingCSPrincipal,
FundingLBInterest,
FundingLBLock,
FundingPurposeCD_F,
FundingDrawId,
FundingExpense,
ExpenseComments,
WireConfirm	
FROM [DW].[UwNoteFundingBI]
