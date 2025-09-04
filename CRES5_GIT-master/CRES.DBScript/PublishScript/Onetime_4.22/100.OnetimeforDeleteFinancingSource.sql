Delete from CRE.InvestorFinancingSourceMapping where financingsourceid in (
	Select FinancingSourceMasterID from cre.FinancingSourceMaster Where FinancingSourceMasterID NOT IN (
		Select Distinct FinancingSourceID from cre.Note 
		Where FinancingSourceID IS NOT NULL
	)
)



Delete from CRE.QBAccountFinancingSourceMapping where financingsourceid in (
	Select FinancingSourceMasterID from cre.FinancingSourceMaster Where FinancingSourceMasterID NOT IN (
		Select Distinct FinancingSourceID from cre.Note 
		Where FinancingSourceID IS NOT NULL
		
	)
)




Delete from cre.FinancingSourceMaster Where FinancingSourceMasterID NOT IN (
	Select Distinct FinancingSourceID from cre.Note 
	Where FinancingSourceID IS NOT NULL
	
)



