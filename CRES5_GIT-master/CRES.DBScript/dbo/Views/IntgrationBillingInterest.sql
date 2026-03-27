CREATE View [dbo].[IntgrationBillingInterest]
as
select 
NoteID as NoteKey,
T.CRENoteID as NoteID,

T.Date,

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

Where AnalysisName = 'Default' 
and Type = 'BillingInterestPaid' 
and T.AccountTypeID = 1 
