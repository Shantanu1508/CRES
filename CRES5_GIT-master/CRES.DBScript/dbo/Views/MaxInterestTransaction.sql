	
CREATE View [dbo].[MaxInterestTransaction]
As
	
select N1.CRENoteID,  MAX(T1.Date) Date From [CRE].[TransactionEntry] T1
						Inner Join Cre.Note N1 on N1.Noteid = T1.Noteid
				
						Where [Type] = 'InterestPaid'
						and T1.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
						Group by CrenoteId	

