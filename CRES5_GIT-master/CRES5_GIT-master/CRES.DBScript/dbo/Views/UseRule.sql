-- View
-- View
Create View [dbo].[UseRule]
As

select Dealname , DealID, d.dealkey
,UseRule= Case when MAX( UseRuletoDetermineNoteFunding ) = 4 then 'N' else 'Y' end from deal D
Inner join Note N on D.DealKey = n.DealKey
where UseRuletoDetermineNoteFunding is not null
Group by Dealname , DealID, d.dealkey 
