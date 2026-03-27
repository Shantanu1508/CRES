CREATE view AutospreadAnalysis
AS
Select 
vwd.DealID
,d.Dealname
,[TeamLeadAMBI] AMOversight
,vwd.[AssetManagerBI] PrimaryAM
,Min(ClosingDate)ClosingDate
, UseRule = 'Y'
, EnableAutospread =Case when ISNULL(D.EnableAutoSpread,0)= 0 then 'No' else 'Yes' end 
,SUM(Amount)SUMFF_Amount
,SUM(InitialFundingamount)InitialFunding
,SUM([M61Commitment])[M61Commitment]


,Year(MIN(Closingdate))Year_ClosingDate


from DealFundingSchedule DS
Left join cre.deal D on D.Dealid = DS.dealkey
Left join note n on n.dealkey = d.dealid
Left join Deal vwd on vwd.dealkey =d.dealid
Where date > Getdate() 
--and ISNULL(EnableAutospread,0)=0 
and Amount >0.01 
and date>getdate() and vwD.status = 'Active' and ActualPayoffDate is null
and [UseRuletoDetermineNoteFunding] = 3

Group by D.Dealname, D.EnableAutoSpread,vwd.[AssetManagerBI]
,vwd.DealID,TeamLeadAMBI,UseRuletoDetermineNoteFunding