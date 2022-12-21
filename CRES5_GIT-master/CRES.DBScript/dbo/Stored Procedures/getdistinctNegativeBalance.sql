
-- Procedure
-- Procedure
Create Procedure getdistinctNegativeBalance
as
Begin
Insert into Note_NegativeBalTable
(
creDealID
,DealName
,HasScheduledPrincipal
,SmallVsHighBal
,UserRuleYvsUseRuleN
,FF_Vs_FullyFunded
)

Select * from [Note_NegativeBal]
End