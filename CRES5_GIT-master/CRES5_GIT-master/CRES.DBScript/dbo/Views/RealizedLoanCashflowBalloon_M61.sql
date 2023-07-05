CREATE View [dbo].[RealizedLoanCashflowBalloon_M61]
As

Select NoteKey,
NoteID,
Date,
SUM(Amount)Amount,

Type,

CreatedBy,
CreatedDate,
UpdatedBy,
UpdatedDate,
( a.noteid+'_'+ a.Type + '_' + CONVERT (VARCHAR(10),a.Date, 110)  ) Note_Type_Date,
NoteID_Date_Scenario,
AnalysisID,
Scenario,
FeeName,
InitialIndexValueOverride,
NoteID_Date,
DealName,
DealID,
NoteName,
TR_CashFlow_Date,
TR_TransactionDate,
TR_DueDate,
TR_RemitDate
From(
	select  T.NoteID as NoteKey,      
	T.CRENoteID as NoteID,      
	Date,      
	Amount,   
	'Balloon' as Type, 
	T.CreatedBy,      
	T.CreatedDate,      
	T.UpdatedBy,      
	T.UpdatedDate ,      
	null as Note_Type_Date,        
	T.crenoteid+'_'+CONVERT (VARCHAR(10),Date, 110) + AnalysisName   NoteID_Date_Scenario,        
	AnalysisID,      
	AnalysisName as Scenario,      
	FeeName,      
	InitialIndexValueOverride,      
	T.crenoteid+'_'+CONVERT (VARCHAR(10),Date, 110)  NoteID_Date ,    
	DealName,    
	CreDealID as DealID,    
	N.Name as NoteName,      
	ISNULL(TransactionDateByRule,Date) as TR_CashFlow_Date,    
	TransactionDateServicingLog as TR_TransactionDate,    
	Date as TR_DueDate,    
	RemitDate as TR_RemitDate    
    
	From [DW].[TransactionEntryBI] T      
	left join DW.NoteBI N on N.Noteid = T.NoteID      
	where AnalysisName = 'Default'  
	
	and T.TransactionEntryID in	 ---Ignore ballon and FundingOrRepayment
	(
		Select b.TransactionEntryID
		From(
			Select T.TransactionEntryID,T.CreNoteID,T.type,T.Date,T.Amount 
			From [DW].[TransactionEntryBI] T      
			where AnalysisName = 'Default' and type ='Balloon'

			UNION ALL

			Select TF.TransactionEntryID,TF.CreNoteID,TF.type,TF.Date,TF.Amount 
			From [DW].[TransactionEntryBI] TF 	
			INNER JOIN(
				Select TransactionEntryID,CreNoteID,Date,Amount From [DW].[TransactionEntryBI] T      
				where AnalysisName = 'Default' and type ='Balloon'
			)TB on TF.CreNoteID = TB.CreNoteID and TF.Date = TB.Date
			where TF.AnalysisName = 'Default' and TF.type ='FundingOrRepayment'  and TF.Amount > 0

			UNION ALL

			Select T.TransactionEntryID,T.CreNoteID,T.type,T.Date,T.Amount 
			From [DW].[TransactionEntryBI] T      
			left join DW.NoteBI N on N.Noteid = T.NoteID
			where AnalysisName = 'Default' and type ='FundingOrRepayment' and T.Date = N.ActualPayOffDate
		)b	
	)

)a
--where a.noteid = '2702'
group by 
NoteKey,
NoteID,
Date,
Type,
CreatedBy,
CreatedDate,
UpdatedBy,
UpdatedDate,
NoteID_Date_Scenario,
AnalysisID,
Scenario,
FeeName,
InitialIndexValueOverride,
NoteID_Date,
DealName,
DealID,
NoteName,
TR_CashFlow_Date,
TR_TransactionDate,
TR_DueDate,
TR_RemitDate
