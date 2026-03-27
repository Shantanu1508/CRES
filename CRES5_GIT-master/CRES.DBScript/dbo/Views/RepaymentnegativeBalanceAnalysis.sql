CREATE View [dbo].[RepaymentnegativeBalanceAnalysis]
as
Select Convert(varchar(100),creDealID)creDealID, Convert(varchar(100),N.DealName)DealName, convert( varchar(100),N.Crenoteid  )Crenoteid
,HasScheduledPrincipal
,SmallVsHighBal
,Convert(varchar (100),UserRuleYvsUseRuleN)UserRuleYvsUseRuleN
,FF_Vs_FullyFunded
,ISNULL([Date], '1/1/1999')[Date]
,ISNULL(Cast(Round([endingbalance],2,1)AS decimal(28,8)),0)[endingbalance]
,ISNULL(Cast(Round([ScheduledPrincipal],2,1)AS decimal (28,8)),0)[ScheduledPrincipal]
,isnull([HighorSmallNegativebalance],'')[HighorSmallNegativebalance]
,ISNULL(Cast(Round([Delta] ,2,1)as decimal(28,8)),0)[Delta]
from [Note_NegativeBal] N

Left join [dbo].[NegativebalanceAmort] NA on NA.Crenoteid= N.Crenoteid
where (Delta not like '%e%' or  endingbalance not like '%e%' or ScheduledPrincipal  not like '%e%')