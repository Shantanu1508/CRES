
CREATE View [dbo].[FundingTabSchedulePrincipal]
as
Select Crenoteid, SUM(n.Amount) Amount 
				from NoteFundingSchedule N
				Where Purpose = 'Amortization' and DealName not Like '%Test%' 
				and n.Date <= GETDATE()  and DealName not like '%Copy%'
				Group by N.Crenoteid