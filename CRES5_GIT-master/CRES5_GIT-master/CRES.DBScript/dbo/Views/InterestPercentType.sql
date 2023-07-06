CREATE View [dbo].[InterestPercentType]
As

Select Distinct creNoteid, 
PercentType = Case when Valuetypeid = 151 THEN 'Spread'
	when Valuetypeid = 150 THEN 'Rate'
	End 

	 from [Core].[RateSpreadSchedule] R
Inner Join Core.Event E on R.eventID = E.eventid
Inner join Core.Lookup L on L.Lookupid = E.eventtypeid
inner join cre.note n on n.Account_Accountid = E.Accountid
where Lookupid = 14 and Valuetypeid in( 151,150)
and E.StatusID = 1

