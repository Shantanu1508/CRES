CREATE view [dbo].[Prod_TransactionEntry]
as 
select 
NoteID as NoteKey,
CRENoteID as NoteID,
Date,
Amount,
Type,
CreatedBy,
CreatedDate,
UpdatedBy,
UpdatedDate ,
( crenoteid+'_'+ Type  ) Note_Type_Date

From [DW].[Prod_TransactionEntry]





