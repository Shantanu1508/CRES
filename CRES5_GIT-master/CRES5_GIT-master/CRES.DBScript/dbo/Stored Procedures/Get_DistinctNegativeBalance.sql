

-- Procedure
-- Procedure
CREATE Procedure Get_DistinctNegativeBalance
as
Begin
Insert into Note_NegativeBalMasterTable
(
creDealID
,DealName
,Crenoteid
,SmallVsHighBal
,UserRuleYvsUseRuleN
,FF_Vs_FullyFunded
,HasScheduledPrincp
,HasPIK
)

Select * from NegativeNoteBalanceMaster
End