Create view DealshavingbothYandN
as
Select Dealname, Dealid from

(
select Dealname, D.Dealid, ISNULl(UseRuletoDetermineNoteFunding,4)UseRuletoDetermineNoteFunding from  Deal D
Inner join Note N on D.DealKey = N.Dealkey
group By D.Dealid, UseRuletoDetermineNoteFunding , dealname

)x
Group By Dealid, dealname
Having Count(Dealid)>1