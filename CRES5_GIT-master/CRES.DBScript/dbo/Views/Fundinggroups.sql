


CREATE VIEW [dbo].Fundinggroups AS
SELECT 
--Fundingdate
Convert( Varchar(10),Noteid_F )Noteid_F,

SUM(FundingAmount)FundingAmount,


PurposeTypeBI = Case when SUM(FundingAmount) > 0 and FundingPurposeCD_F <> 'PIK Non-Commit Adj' Then 'Funding'
		When FundingPurposeCD_F Like 'Loan Amortization'  THEN 'Amort'
		When  FundingPurposeCD_F = 'PIK Non-Commit Adj'Then 'PIKInterest' End

FROM [DW].[UwNoteFundingBI]
Where FundingDate between  '7/1/2020' and '7/8/2020'
Group by Noteid_F, FundingPurposeCD_F
