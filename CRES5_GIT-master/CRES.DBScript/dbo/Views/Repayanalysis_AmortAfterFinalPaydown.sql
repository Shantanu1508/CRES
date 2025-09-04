
CREATE View Repayanalysis_AmortAfterFinalPaydown
AS
Select [creDealID]
, T.DealName
,Crenoteid
,[HasScheduledPrincipal]
, Date
, endingbalance
,ScheduledPrincipal
,Delta
,SmallVsHighBal
, UserRuleYvsUseRuleN
,hasbothUseruleYUserRuleN = Case when x.dealname is null then 'no'else 'yes' end
  ,FF_Vs_FullyFundied  from TotalNegativeBalance T
left join [NegativebalanceAmort] N on T.DealName = n.Dealname
Left join (select Dealid, DealName from  DealshavingbothYandN D )x
on X.DealName  = T.Dealname
where Crenoteid is not null