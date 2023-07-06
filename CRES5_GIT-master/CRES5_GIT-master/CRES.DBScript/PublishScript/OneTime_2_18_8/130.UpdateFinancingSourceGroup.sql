Update cre.financingsourcemaster set FinancingSourceGroup = '3rd Party Owned'  where FinancingSourceName = '3rd Party Owned'
Update cre.financingsourcemaster set FinancingSourceGroup = 'ACORE Credit IV'  where FinancingSourceName = 'ACORE Credit IV'
Update cre.financingsourcemaster set FinancingSourceGroup = 'ACORE Credit IV'  where FinancingSourceName = 'ACORE Credit IV – Axos 2021'
Update cre.financingsourcemaster set FinancingSourceGroup = 'ACORE Credit IV'  where FinancingSourceName = 'ACORE Credit IV – Axos 2021 Offshore'
Update cre.financingsourcemaster set FinancingSourceGroup = 'ACORE Credit IV'  where FinancingSourceName = 'ACORE Credit IV - DB'
Update cre.financingsourcemaster set FinancingSourceGroup = 'ACORE Credit IV'  where FinancingSourceName = 'ACORE Credit IV - DB Offshore'
Update cre.financingsourcemaster set FinancingSourceGroup = 'ACORE Credit IV'  where FinancingSourceName = 'ACORE Credit IV - GS 2018'
Update cre.financingsourcemaster set FinancingSourceGroup = 'ACORE Credit IV'  where FinancingSourceName = 'ACORE Credit IV - GS 2018 Offshore'
Update cre.financingsourcemaster set FinancingSourceGroup = 'ACORE Credit IV'  where FinancingSourceName = 'ACORE Credit IV - MS'
Update cre.financingsourcemaster set FinancingSourceGroup = 'ACORE Credit IV'  where FinancingSourceName = 'ACORE Credit IV - MS Offshore - MS'
Update cre.financingsourcemaster set FinancingSourceGroup = 'ACORE Credit IV'  where FinancingSourceName = 'ACORE Credit IV - Note Repo'
Update cre.financingsourcemaster set FinancingSourceGroup = 'ACORE Credit IV'  where FinancingSourceName = 'ACORE Credit IV - Offshore'
Update cre.financingsourcemaster set FinancingSourceGroup = 'ACORE Credit IV'  where FinancingSourceName = 'ACORE Credit IV - WF'
Update cre.financingsourcemaster set FinancingSourceGroup = 'ACORE Credit IV'  where FinancingSourceName = 'ACORE Credit IV - WF Offshore'
Update cre.financingsourcemaster set FinancingSourceGroup = 'ACORE Credit Partners II'  where FinancingSourceName = 'ACORE Credit Partners II'
Update cre.financingsourcemaster set FinancingSourceGroup = 'ACORE Hospitality Investments'  where FinancingSourceName = 'ACORE Hospitality Investments'
Update cre.financingsourcemaster set FinancingSourceGroup = 'ACORE Spec Sits'  where FinancingSourceName = 'ACORE Spec Sits'
Update cre.financingsourcemaster set FinancingSourceGroup = 'AFLAC & TRE ACR'  where FinancingSourceName = 'AFLAC US'
Update cre.financingsourcemaster set FinancingSourceGroup = 'ACORE Hospitality Investments'  where FinancingSourceName = 'Aksia Sidecar'
Update cre.financingsourcemaster set FinancingSourceGroup = 'ACORE Credit IV'  where FinancingSourceName = 'BcIMC Sidecar'
Update cre.financingsourcemaster set FinancingSourceGroup = 'Co-Fund'  where FinancingSourceName = 'Co-Fund'
Update cre.financingsourcemaster set FinancingSourceGroup = 'Delaware Life'  where FinancingSourceName = 'Delaware Life'
Update cre.financingsourcemaster set FinancingSourceGroup = 'Delphi Floating'  where FinancingSourceName = 'Delphi ACORE'
Update cre.financingsourcemaster set FinancingSourceGroup = 'Delphi Fixed'  where FinancingSourceName = 'Delphi Fixed'
Update cre.financingsourcemaster set FinancingSourceGroup = 'Delphi Offshore'  where FinancingSourceName = 'Delphi Offshore'
Update cre.financingsourcemaster set FinancingSourceGroup = 'Delphi Offshore'  where FinancingSourceName = 'Delphi Offshore Sold'
Update cre.financingsourcemaster set FinancingSourceGroup = 'Delphi Floating'  where FinancingSourceName = 'Delphi Portfolio'
Update cre.financingsourcemaster set FinancingSourceGroup = 'Delphi Floating'  where FinancingSourceName = 'Delphi Warehouse Line'
Update cre.financingsourcemaster set FinancingSourceGroup = 'Harel Participation'  where FinancingSourceName = 'Harel Participation'
Update cre.financingsourcemaster set FinancingSourceGroup = 'Note Sale'  where FinancingSourceName = 'Note Sale'
Update cre.financingsourcemaster set FinancingSourceGroup = 'AFLAC & TRE ACR'  where FinancingSourceName = 'TRE ACR Portfolio'
Update cre.financingsourcemaster set FinancingSourceGroup = 'Winthrop - Participation'  where FinancingSourceName = 'Winthrop - Participation'


go


Update dw.NoteBI SET dw.NoteBI.FinancingSourceGroup = a.FinancingSourceGroup
From(
	Select n.noteid,LFinancingSourceID.FinancingSourceGroup
	From CRE.Note n
	Inner Join CORE.Account ac ON ac.AccountID = n.Account_AccountID
	left join [CRE].[FinancingSourceMaster] LFinancingSourceID on LFinancingSourceID.FinancingSourceMasterID = n.FinancingSourceID
)a
where dw.NoteBI.noteid = a.noteid
