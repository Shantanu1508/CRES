
Print('Remove eff date beyond the actual payoff date ')

--Select eventID, D.DealName, CreDealID, CreNoteID, ActualPayoffDate, Date, l.Name, EffectiveStartDate, EffectiveEndDate, eve.StatusID 
--from [CORE].[Event] eve 
--left JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID 
--INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID 
--LEFT JOIN core.Lookup l on l.lookupID= eve.EventTypeID 
--left join cre.Deal d on d.DealID=n.DealID 
--Where acc.IsDeleted = 0 
--and l.Name like 'FundingSchedule' 
--and CREDealID='18-0344' 
--and EffectiveStartDate='2023-07-31' -- and CreNoteID='16878' -- Order by DealName, CreNoteID, Name, EffectiveStartDate



--Update Core.Event Set StatusID=2 where EventID in 
--( 	
--	Select eventID 	
--	from [CORE].[Event] eve 	
--	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID 	
--	INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID 	
--	LEFT JOIN core.Lookup l on l.lookupID= eve.EventTypeID 	
--	left join cre.Deal d on d.DealID=n.DealID 	
--	Where acc.IsDeleted = 0 and l.Name like 'FundingSchedule' and CREDealID='18-0344'and EffectiveStartDate='2023-07-31' 	
--)




Select eventID, D.DealName, CreDealID, CreNoteID, ActualPayoffDate, Date, l.Name, EffectiveStartDate, EffectiveEndDate, eve.StatusID 
from [CORE].[Event] eve left JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID 
INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID 
LEFT JOIN core.Lookup l on l.lookupID= eve.EventTypeID 
left join cre.Deal d on d.DealID=n.DealID 
Where acc.IsDeleted = 0 and l.Name like 'FundingSchedule' and CREDealID='18-0344' 
and EffectiveStartDate = '2023-04-30'
and n.crenoteid in (
'12400',
'12402',
'17071',
'16879',
'16885',
'17069',
'16880',
'17070',
'16882',
'16878',
'16883',
'17068')



Select eventID, D.DealName, CreDealID, CreNoteID, ActualPayoffDate, Date, l.Name, EffectiveStartDate, EffectiveEndDate, eve.StatusID 
from [CORE].[Event] eve left JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID 
INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID 
LEFT JOIN core.Lookup l on l.lookupID= eve.EventTypeID 
left join cre.Deal d on d.DealID=n.DealID 
Where acc.IsDeleted = 0 and l.Name like 'FundingSchedule' and CREDealID='18-0344' 
and EffectiveStartDate = '2023-07-31'
and n.crenoteid in (
'12400',
'12402',
'17071',
'16879',
'16885',
'17069',
'16880',
'17070',
'16882',
'16878',
'16883',
'17068')




Update Core.Event Set StatusID=2 where EventID in (
'D504DEAA-CA15-4B8C-A6EA-CDA86986D9EF',
'23EA508A-57AE-42F1-9344-59C0A51DC3B7',
'6503C53D-57AB-4139-BD1F-14BCD735BA28',
'AB7267D5-9196-4BD6-B418-249E2846754D',
'82654772-347E-4CA1-8E38-65FB1996F192',
'FD8D4416-F127-4E1B-9775-8DA706443827',
'1BD6A515-69B2-4F48-BF83-35D13C2288E4',
'27306E57-59FC-4282-9C0E-4459307629E0',
'4B7249E4-41C5-47BB-8245-004D111E8055',
'D00A56C5-654E-4A8D-AA29-674603413168',
'C886639E-4A2E-4301-B7D8-5C947462E1CC',
'E320BA98-2B1A-4978-9395-8446C77EC25C'
)

--===========================================



Update Core.Event Set EffectiveStartDate= '2023-04-30' where EventID in (
'AF86C1AC-C680-4095-94EA-6F2AA27BF817',
'72FFD211-909D-4A5F-B664-D832AF6B3E0B',
'423E6C33-70D5-4146-90AF-CB52E232A313',
'1DFAACE7-FFD3-4E69-ADBE-29D15499261C',
'4A77E302-4BFB-41F9-8AE9-539EB671BEED',
'0C82D70A-F209-4355-B7EA-F41DBC4C067F',
'38E73FA2-7191-48BF-AD2E-9F114B882B33',
'0E2C5503-0F44-4BFB-878A-A4D149078212',
'7D3D0F7D-4487-46F1-B3D0-FD6C38503D00',
'FD72B625-71C0-4BBD-A148-A2C86F516363',
'05BD58B4-C906-4614-8218-C8C01394D80C',
'E2C14CEF-44E5-469B-9F3E-4E5D2CC3681D'
)