CREATE View [dbo].[Calcuationstatus]
As

Select D.DealKey
, D.Status
, D.DealID
, dealName
, N.Noteid
, L.Name
, C.StatusID
, Analysisid
, UserName
, [RequestTime]
, Maturity_DateBI
, Type = Case when D.DealName Like '%Refi%' and [StubPaidInArrears] = 3 Then 'Refinanced Purchase'
				when D.DealName Like '%Refi%' and [StubPaidInArrears] <> 3 Then 'Refinanced'
				when D.DealName Like '%Upsize%' and [StubPaidInArrears] = 3   Then 'upsize'
				when D.DealName Like '%Upsize%' Then 'upsize'
				when  [StubPaidInArrears] = 3  and D.DealName not Like '%Refi%' Then 'Purchase'
				When D.DealName not Like '%Refi%' or D.DealName not Like '%Upsize%'  
				and ([StubPaidInArrears] = 3 or [StubPaidInArrears] is null) then 'Originated' End
, Maturity_Year = YEAR(Maturity_DateBI)
,ClosingDate_Year = Year(CLosingDate)

, ClosingDate from [Core].[CalculationRequests] C
Inner join Core. LookUP L on C.StatusID = L.Lookupid
Inner join dbo.Note N on N.Notekey = C.Noteid
Inner join dbo.Deal D on N.dealKey = D.dealKey



