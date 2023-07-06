


CREATE View [dbo].[RecentWF]
as
select w.* from workflow W
Inner join  RecentWFInterim R on R.Credealid = w.Credealid 
and R.Fundingdate = W.FundingDate and w.Updateddate = r.Updateddate
--where w.credealid = '17-1287'		
--and w.Fundingdate  = '6/18/2020'	

