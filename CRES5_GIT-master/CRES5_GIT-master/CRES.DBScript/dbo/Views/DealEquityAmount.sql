CREATE VIEW [dbo].[DealEquityAmount] AS

select d.credealid,d.dealname,l.name as PurposeType,d.EquityAmount  as TotalEquity,asr.EquityAmount
from cre.deal d
inner join [CRE].[AutoSpreadRule] asr on asr.dealid =d.dealid
left join core.lookup l on l.lookupid = asr.PurposeType
--order by d.credealid,d.dealname,l.name


