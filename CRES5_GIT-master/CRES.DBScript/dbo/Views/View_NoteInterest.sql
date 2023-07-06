
CREATE View [dbo].[View_NoteInterest]
AS
SELECT T.DealName
,T.CreDealID AS DealID
,T.CRENoteID AS NoteID
,[DATE] as DueDate
,TransactionDateServicingLog AS TransactionDate
,RemitDate AS RemitDate
,[Type]
,Amount
FROM [DW].[TransactionEntryBI] T
LEFT JOIN DW.NoteBI N ON N.Noteid = T.NoteID
Left join dw.dealBI d on d.dealid = n.noteid
Where T.[Type] in ( 'InterestPaid','PIKInterest','PIKInterestPaid')

and AnalysisName = 'Default'


	
	

