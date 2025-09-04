
Create View Repayanalysis_Negativebalneedtoreview
AS
Select [creDealID]
, T.DealName
,Crenoteid
,[HasScheduledPrincipal]
, Date
, endingbalance
, ScheduledPrincipal
,Delta
, SmallVsHighBal
, UserRuleYvsUseRuleN
,  FF_Vs_FullyFundied  from TotalNegativeBalance T
left join [NegativebalanceAmort] N on T.DealName = n.Dealname
where Crenoteid is  null