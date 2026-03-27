

Print('Update  CRE.TransactionTypes Cash-NonCash')
Update  CRE.TransactionTypes set Cash_NonCash = 'NonCash' where TransactionName in ('PIKInterest','PIKPrincipalFunding')
Update  CRE.TransactionTypes set Cash_NonCash = 'Cash' where TransactionName in ('PIKInterestPaid','PIKPrincipalPaid')