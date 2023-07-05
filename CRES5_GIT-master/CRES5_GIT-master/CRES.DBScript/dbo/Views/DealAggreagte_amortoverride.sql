Create View [dbo].DealAggreagte_amortoverride
as
select DealName, d1.DealId, Sum(n1.MonthlyDSoverridewhenamortizing)MonthlyDSoverridewhenamortizing
					, SUM(n1.TotalCommitment)TotalCommitment  from Deal D1
			Inner Join Note N1 on N1.DealKey = D1.DealKey
				
				and isnull(n1.MonthlyDSoverridewhenamortizing,0) <>0
				--and  Dealname = 'HGI, Homewood Suites and Best Western Grant Park'
				Group by d1.DealID,DealName
