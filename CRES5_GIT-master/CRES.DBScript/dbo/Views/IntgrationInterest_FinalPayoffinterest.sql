CREATE View [dbo].[IntgrationInterest_FinalPayoffinterest]
as
select 
NoteID as NoteKey,
T.CRENoteID as NoteID,

T.Date,
X.Date MaxDate, 
Amount,
Type,
CreatedBy,
CreatedDate,
UpdatedBy,
UpdatedDate ,
( T.crenoteid+'_'+ Type + '_' + CONVERT (VARCHAR(10),T.Date, 110)  ) Note_Type_Date,

T.crenoteid+'_'+CONVERT (VARCHAR(10),T.Date, 110)  NoteID_Date,

AnalysisID,
AnalysisName as Scenario,
FeeName


From [DW].[TransactionEntryBI] T

outer apply (Select MAX(T1.Date) Date, CRENoteID from  [DW].[TransactionEntryBI] T1
				Where Type = 'InterestPaid' and T.CRENoteID =  T1.CRENoteID
				and 	T.AnalysisID = T1.AnalysisID  and T.Type =  T1.Type 
				and T1.AccountTypeID = 1
				Group by T1.CRENoteID

				)X
Where 
 Type = 'InterestPaid' and T.Date = x.Date
 and T.AccountTypeID = 1




