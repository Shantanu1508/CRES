

-- Procedure
CREATE PROCEDURE usp_RepaymentnegativeBalanceAnalysis
as
Begin

insert into RepaymentnegativeBalAnalysisTable
Select creDealID
, N.DealName
, N.Crenoteid  
,HasScheduledPrincipal
,SmallVsHighBal
,UserRuleYvsUseRuleN
,FF_Vs_FullyFunded
,[Date]
,[endingbalance]
,[ScheduledPrincipal]
--,SmallVsHighBal
,[Delta]
from [Note_NegativeBal] N

Left join [dbo].[NegativebalanceAmort] NA on NA.Crenoteid= N.Crenoteid

End