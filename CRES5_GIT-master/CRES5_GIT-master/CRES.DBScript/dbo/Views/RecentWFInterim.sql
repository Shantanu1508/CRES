

CREATE view [dbo].[RecentWFInterim]
as
Select    w.CREDealID, w.Fundingdate, w.Amount, Max(Updateddate) Updateddate from workflow W
Outer apply (select  CREDealID, Fundingdate, Amount, StatusNameBI as StatusName  from  workflow W1
				Where w.CREDealID = w1.CREDealID and w.Fundingdate= w1.Fundingdate
				and w.Amount =w1.Amount
				and w.updateddate =w1.updateddate 
				group by CREDealID, Fundingdate, Amount, StatusNameBI
				
			)x
--where w.credealid = '18-0581'		and w.Fundingdate  = '6/18/2020'		
group by w.CREDealID, w.Fundingdate, w.Amount
